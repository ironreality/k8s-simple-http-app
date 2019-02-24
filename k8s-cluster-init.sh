#!/bin/bash

token_path=/vagrant/k8s_token
discovery_token_path=/vagrant/k8s_discovery_token

echo "Initializing k8s cluster with kubeadm..."
ipaddr=$(ifconfig eth1 | grep -i Mask | awk '{print $2}'| cut -f2 -d:)
nodename=$(hostname -s)

# --ignore-preflight-errors=SystemVerification - ignore 'Docker 18.09 is non-validated' error
# --pod-network-cidr=10.244.0.0/16 - required for further Flannel installation
kubeadm init --ignore-preflight-errors=SystemVerification --apiserver-advertise-address="${ipaddr}" --node-name "${nodename}" --pod-network-cidr=10.244.0.0/16 || { echo "Can't initialize the Kubernetes cluster! Exiting..."; exit 1; }

echo "Creating kubectl config for user: $(id) ..."
mkdir -p $HOME/.kube && cp -i /etc/kubernetes/admin.conf $HOME/.kube/config || { echo "Can't copy the kubectl config! Exiting..."; exit 1; }

#echo "Allowing pods running on master..."
#kubectl taint nodes --all node-role.kubernetes.io/master-

echo "Installing Flannel pod network..."
cat >> /etc/sysctl.conf<<EOF
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl -p
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml || { echo "Can't install Flannel network! Exiting..."; exit 1; }

echo "Saving the cluster join token to ${token_path}..."
kubeadm token list  | awk '/^[^TOKEN]/{ print $1 }' > "${token_path}" || { echo "Can't save the join token! Exiting..."; exit 1; }

echo "Generating discovery token hash and saving it to ${discovery_token_path}..."
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | \
  openssl rsa -pubin -outform der 2>/dev/null | \
  openssl dgst -sha256 -hex | sed 's/^.* //' > "${discovery_token_path}" || { echo "Can't generatediscovery token hash! Exiting..."; exit 1; } 