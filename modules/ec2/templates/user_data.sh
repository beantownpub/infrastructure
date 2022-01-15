#!/bin/bash

LOG=/home/ec2-user/bootstrap_log.txt
printf "Current Dir: %s\n" "$(pwd)" >> /home/ec2-user/bootstrap_log.txt
printf "Current User: %s\n" "$(whoami)" >> /home/ec2-user/bootstrap_log.txt
printf "Log Dir: %s\n" "$${LOG}" >> /home/ec2-user/bootstrap_log.txt

sudo yum update -y || printf "Error updating Yum\n" >> /home/ec2-user/bootstrap_log.txt
sudo yum install -y bind-utils git iproute-tc jq nmap || printf "Error install packages\n" >> /home/ec2-user/bootstrap_log.txt

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

printf "\nInstalling Docker\n" >> /home/ec2-user/bootstrap_log.txt
sudo sysctl --system
sudo amazon-linux-extras install -y docker || printf "Error installing Docker\n" >> /home/ec2-user/bootstrap_log.txt

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
sudo usermod -a -G docker ec2-user || printf "Error updating docker perms\n" >> /home/ec2-user/bootstrap_log.txt
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

printf "\nInstalling K8s Components\n" >> /home/ec2-user/bootstrap_log.txt

sudo yum install -y \
    kubelet \
    kubeadm \
    kubectl \
    --disableexcludes=kubernetes || printf "Error installing K8s Components\n" >> /home/ec2-user/bootstrap_log.txt

sudo systemctl enable --now kubelet

printf "\nInitializing K8s Cluster\n" >> /home/ec2-user/bootstrap_log.txt

sudo systemctl enable kubelet.service || printf "Error kubelet.service\n" >> /home/ec2-user/bootstrap_log.txt

mkdir -p /home/ec2-user/manifests

cat <<EOF | tee /home/ec2-user/manifests/cluster-config.yaml
apiVersion: kubeadm.k8s.io/v1beta3
bootstrapTokens:
- token: ${k8s_token}
  ttl: 24h0m0s
kind: InitConfiguration
localAPIEndpoint:
  bindPort: 6443
nodeRegistration:
  criSocket: /var/run/dockershim.sock
  imagePullPolicy: IfNotPresent
  taints:
  - effect: NoSchedule
    key: node-role.kubernetes.io/master
---
apiServer:
  timeoutForControlPlane: 4m0s
  certSANs:
  - "k8s.${env}.${domain_name}"
apiVersion: kubeadm.k8s.io/v1beta3
certificatesDir: /etc/kubernetes/pki
clusterName: ${cluster_name}
controllerManager: {}
dns: {}
etcd:
  local:
    dataDir: /var/lib/etcd
imageRepository: k8s.gcr.io
kind: ClusterConfiguration
kubernetesVersion: ${k8s_version}
networking:
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
scheduler: {}
EOF

sudo kubeadm init \
    --config /home/ec2-user/manifests/cluster-config.yaml || printf "Error initializing cluster\n" >> /home/ec2-user/bootstrap_log.txt

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

helm repo add cilium https://helm.cilium.io/ && \
    helm repo add istio https://istio-release.storage.googleapis.com/charts && \
	helm repo add jetstack https://charts.jetstack.io &&
    helm repo update

helm upgrade cilium cilium/cilium --install \
    --version 1.10.5 \
    --namespace kube-system --reuse-values \
    --set hubble.relay.enabled=true \
    --set hubble.ui.enabled=true \
    --set ipam.operator.clusterPoolIPv4PodCIDR="10.7.0.0/16"\
    --debug

sleep 15

helm upgrade istio-base istio/base --install \
    --namespace istio-system \
    --version 1.12.1 \
    --create-namespace

sleep 10

helm upgrade istiod istio/istiod --install \
	--version 1.12.1 \
    --namespace istio-system

helm upgrade istio-ingress istio/gateway --install \
    --version 1.12.1 \
    --namespace istio-ingress \
    --set service.type=None


kubectl apply -n istio-ingress -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  labels:
    app: istio-ingress
    istio: ingress
  name: istio-ingress
spec:
  ports:
  - name: status-port
    nodePort: 32382
    port: 15021
    protocol: TCP
    targetPort: 15021
  - name: http2
    nodePort: 30080
    port: 80
    protocol: TCP
    targetPort: 80
  - name: https
    nodePort: 30443
    port: 443
    protocol: TCP
    targetPort: 443
  selector:
    app: istio-ingress
    istio: ingress
  sessionAffinity: None
  type: NodePort
EOF

# sudo mount bpffs /sys/fs/bpf -t bpf

