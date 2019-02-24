#!/bin/bash

echo "Installing auxiliary utils..."
apt-get update && apt-get install -y apt-transport-https curl

echo "Adding the Kubernetes's repo key..."
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

echo "Installing the Kubernetes components..."
apt-get update
apt-get install -y kubelet kubeadm kubectl || { echo "Can't install the Kubernetes components! Exiting..."; exit 1; }

echo "Disabling swap in order to run kubelet..."
swapoff -a && sed -i '/ swap / s/^/#/' /etc/fstab || { echo "Can't disable swap! Exiting..."; exit 1; }
