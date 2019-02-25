#!/bin/bash

token_path=/vagrant/k8s_token
discovery_token_path=/vagrant/k8s_discovery_token
master_ipaddr=172.28.128.2

echo "'Warming up' the virtualbox internal network..."
ping -q -c 10 "${master_ipaddr}"

echo "Joining the cluster..."
kubeadm join ${master_ipaddr}:6443 --token $(cat "${token_path}") --discovery-token-ca-cert-hash sha256:$(cat ${discovery_token_path})
