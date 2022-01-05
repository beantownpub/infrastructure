#!/bin/bash

LOG=/home/ec2-user/bootstrap_log.txt
printf "Current Dir: %s\n" "$(pwd)" >> /home/ec2-user/bootstrap_log.txt
printf "Current User: %s\n" "$(whoami)" >> /home/ec2-user/bootstrap_log.txt
printf "Log Dir: %s\n" "$${LOG}" >> /home/ec2-user/bootstrap_log.txt

sudo yum update -y || printf "Error updating Yum\n" >> /home/ec2-user/bootstrap_log.txt
sudo yum install -y bind-utils git iproute-tc jq nmap || printf "Error install packages\n" >> /home/ec2-user/bootstrap_log.txt

printf "\nInstalling Cilium CLI\n" >> /home/ec2-user/bootstrap_log.txt

curl -s -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz{,.sha256sum} && \
    sha256sum --check cilium-linux-amd64.tar.gz.sha256sum && \
    sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin && \
    rm cilium-linux-amd64.tar.gz{,.sha256sum}

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.12.1 sh -

sudo mv istio-1.12.1/bin/istioctl /usr/local/bin/ && rm -rf istio-1.12.1

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

PUB_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

echo "IP: $${PUB_IP}" >> /home/ec2-user/bootstrap_log.txt

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
  - "k8s.prod.beantownpub.com"
  - "k8s.dev.beantownpub.com"
  - $${PUB_IP}
apiVersion: kubeadm.k8s.io/v1beta3
certificatesDir: /etc/kubernetes/pki
clusterName: prod-use1-cluster
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
    --config /home/ec2-user/manifests/cluster-config.yaml || printf "Error installializing cluster\n" >> /home/ec2-user/bootstrap_log.txt

mkdir /home/ec2-user/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/ec2-user/.kube/config
sudo chown 1000:1000 /home/ec2-user/.kube/config

echo "export ISTIO_VERSION=${istio_version}" >> /home/ec2-user/.bashrc
echo "export CILIUM_VERSION=${cilium_version}" >> /home/ec2-user/.bashrc

echo '''
alias h="helm"
alias i="istioctl"
alias k="kubectl"
alias kd="kubectl delete"
alias kg="kubectl get"
alias kgd="kubectl get deployments"
alias kgdr="kubectl get dr"
alias kgp="kubectl get pods"
alias kgs="kubectl get svc"
alias kgv="kubectl get vs"
''' >> /home/ec2-user/.bashrc || printf "Error adding aliases\n"

# sudo mount bpffs /sys/fs/bpf -t bpf

sleep 90

helm repo add cilium https://helm.cilium.io/ && \
    helm repo update && \
    helm upgrade --install cilium cilium/cilium --version 1.10.5 \
        --namespace kube-system \
        --reuse-values \
        --set hubble.relay.enabled=true \
        --set hubble.ui.enabled=true \
        --set ipam.operator.clusterPoolIPv4PodCIDR="10.7.0.0/16" \
        --set debug.enabled=true || printf "Error installing Cilium\n" >> /home/ec2-user/bootstrap_log.txt && helm repo add cilium https://helm.cilium.io/ && helm repo update && helm upgrade --install cilium cilium/cilium --version 1.10.5 --namespace kube-system --reuse-values --set hubble.relay.enabled=true --set hubble.ui.enabled=true --set ipam.operator.clusterPoolIPv4PodCIDR="10.7.0.0/16" --set debug.enabled=true


sleep 15


cat <<EOF | tee /home/ec2-user/manifests/istio-ingress-service.yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: istio-ingress
    istio: ingress
  name: istio-ingress
  namespace: istio-ingress
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

cat <<EOF | tee /home/ec2-user/manifests/gateway.yaml
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: web-gateway
  namespace: istio-ingress
spec:
  selector:
    app: istio-ingress
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*.beantownpub.com"
    - "*.dev.beantownpub.com"
    - "thehubpub.com"
    - "www.thehubpub.com"
    - "drdavisicecream.com"
    - "www.drdavisicecream.com"
    - "wavelengths-brookline.com"
    - "www.wavelengths-brookline.com"
    - "*.jalgraves.com"
EOF

helm repo add istio https://istio-release.storage.googleapis.com/charts && \
    helm repo update && \
helm upgrade --install istio-base istio/base --version ${istio_version} \
    --namespace istio-system \
	--create-namespace

helm repo add istio https://istio-release.storage.googleapis.com/charts && \
    helm repo update && \
sudo helm upgrade --install istiod istio/istiod --version ${istio_version} \
    --namespace istio-system

kubectl create namespace istio-ingress && \
    kubectl label namespace istio-ingress istio-injection=enabled

helm repo add istio https://istio-release.storage.googleapis.com/charts && \
    helm repo update && \
    helm install istio-ingress istio/gateway --version ${istio_version} \
        --namespace istio-ingress \
        --set service.type=None || printf "Error installing Istion ingress\n" >> /home/ec2-user/bootstrap_log.txt

sleep 10

kubectl apply -f /home/ec2-user/maninfests/istio-ingress-service.yaml -n istio-ingress && \
    kubectl apply -f /home/ec2-user/maninfests/gateway.yaml -n istio-ingress

kubectl create namespace prod database && \
    kubectl label namespace prod istio-injection=enabled

helm upgrade --install istio-base istio/base --version 1.12.1 \
    --namespace istio-system \
	--create-namespace

# sudo helm upgrade --install istiod istio/istiod --version 1.12.1 --namespace istio-system

helm repo add istio https://istio-release.storage.googleapis.com/charts && \
    helm repo update && \
    helm install istio-ingress istio/gateway --version 1.12.1 --namespace istio-ingress --set service.type=None
