#!/bin/bash

# Log output available on instance in /var/log/cloud-init-output.log

sudo yum update -y
sudo yum install -y bind-utils git iproute-tc jq nmap

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

printf "\nInstalling Docker\n"

sudo sysctl --system
sudo amazon-linux-extras install -y docker

sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "50m"
    },
    "storage-driver": "overlay2"
}
EOF

sudo service docker start
sudo usermod -a -G docker ec2-user
sudo systemctl enable --now docker
sudo systemctl daemon-reload
sudo systemctl restart docker

sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

printf "\nInstalling K8s Components\n"

sudo yum install -y \
    kubelet \
    kubeadm \
    kubectl \
    --disableexcludes=kubernetes

sudo systemctl enable --now kubelet

printf "\nInitializing K8s Cluster\n"

sudo systemctl enable kubelet.service

mkdir -p /home/ec2-user/manifests

cat <<EOF | tee /home/ec2-user/manifests/cluster-config.yaml
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
bootstrapTokens:
- token: ${k8s_token}
  ttl: 24h0m0s
localAPIEndpoint:
  bindPort: 6443
nodeRegistration:
  criSocket: /var/run/dockershim.sock
  imagePullPolicy: IfNotPresent
  taints:
  - effect: NoSchedule
    key: node-role.kubernetes.io/master
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
apiServer:
  timeoutForControlPlane: 4m0s
  certSANs:
  - "k8s.${env}.${domain_name}"
  extraArgs:
    cloud-provider: external
certificatesDir: /etc/kubernetes/pki
clusterName: ${cluster_name}
controllerManager: {}
dns: {}
etcd:
  local:
    dataDir: /var/lib/etcd
imageRepository: k8s.gcr.io
kubernetesVersion: ${k8s_version}
networking:
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
scheduler: {}
---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
providerID: ${cluster_name}
EOF

sudo kubeadm init \
    --config /home/ec2-user/manifests/cluster-config.yaml

mkdir -p "$${HOME}/.kube"
mkdir /home/ec2-user/.kube
cp -i /etc/kubernetes/admin.conf "$${HOME}/.kube"/config
sudo cp -i /etc/kubernetes/admin.conf /home/ec2-user/.kube/config
sudo chown 1000:1000 /home/ec2-user/.kube/config

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

kubectl create ns database

kubectl create ns "${env}" && \
    kubectl label namespace "${env}" istio-injection=enabled

kubectl create ns istio-ingress && \
		kubectl label namespace istio-ingress istio-injection=enabled

printf "\nAdding Helm Repos\n"

helm repo add cilium https://helm.cilium.io/ && \
    helm repo add istio https://istio-release.storage.googleapis.com/charts && \
	helm repo add jetstack https://charts.jetstack.io &&
    helm repo add beantown https://beantownpub.github.io/helm/ && \
    helm repo add aws-ccm https://kubernetes.github.io/cloud-provider-aws && \
    helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver && \
    helm repo update

printf "\nInstalling Cilium CNI\n"

helm upgrade cilium cilium/cilium --install \
    --version ${cilium_version} \
    --namespace kube-system --reuse-values \
    --set hubble.relay.enabled=true \
    --set hubble.ui.enabled=true \
    --set ipam.operator.clusterPoolIPv4PodCIDR="10.7.0.0/16"

sleep 15

helm upgrade istio-base istio/base --install \
    --namespace istio-system \
    --version ${istio_version} \
    --create-namespace

sleep 10

helm upgrade istiod istio/istiod --install \
	--version ${istio_version} \
    --namespace istio-system

helm upgrade istio-ingress istio/gateway --install \
    --version ${istio_version} \
    --namespace istio-ingress \
    --set service.type=None

printf "\nInstalling Cloud Controller Manager\n"

helm upgrade aws-ccm aws-ccm/aws-cloud-controller-manager \
    --install \
    --set args="{\
        --enable-leader-migration=true,\
        --cloud-provider=aws,\
        --v=2,\
        --cluster-cidr=${cluster_cidr},\
        --cluster-name=${cluster_name},\
        --external-cloud-volume-plugin=aws,\
        --configure-cloud-routes=false\
    }"

printf "\nInstalling EBS CSI Driver\n"

helm upgrade --install aws-ebs-csi-driver \
    --namespace kube-system \
    aws-ebs-csi-driver/aws-ebs-csi-driver


kubectl apply -f - <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: aws
provisioner: ebs.csi.aws.com
parameters:
  type: standard
reclaimPolicy: Retain
allowVolumeExpansion: true
mountOptions:
  - debug
volumeBindingMode: WaitForFirstConsumer
EOF

kubectl create -n kube-system sa jalbot

kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: jalbot-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: jalbot
  namespace: kube-system
EOF

TOKEN_NAME=$(kubectl -n kube-system get sa jalbot -o json | jq '.secrets[0].name' | tr -d '"')
TOKEN=$(kubectl -n kube-system get secret $${TOKEN_NAME} -o jsonpath='{.data.token}'| base64 --decode)

echo "$${TOKEN}" > /home/ec2-user/jalbot_token.txt

helm upgrade --install default-ingress beantown/default-ingress \
    --namespace istio-ingress \
    --set global.env=$(env) \
    --set domain=$(domain) \
    --debug
