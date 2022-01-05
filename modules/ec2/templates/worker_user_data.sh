#!/bin/bash

echo "AWS user_data - Control IP ${control_ip}" > user_data_debug.txt

sudo yum update -y || printf "Error updating Yum\n" >> user_data_debug.txt
sudo yum install -y iproute-tc bind-utils jq nmap || printf "Error install packages\n" >> user_data_debug.txt

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

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

sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet

cat <<EOF | tee cluster-join.yaml
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: JoinConfiguration
discovery:
  bootstrapToken:
    token: ${k8s_token}
    apiServerEndpoint: "${control_ip}:6443"
    unsafeSkipCAVerification: true
nodeRegistration: {}
EOF

sudo kubeadm join \
    --config cluster-join.yaml
