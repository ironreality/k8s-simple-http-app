#!/bin/bash
# The script deploys a tcpdump-stuffed pod into k8s

k8s_config_dir=/vagrant/k8s-configs

echo "Deploying a sniffer pod into host network..."
kubectl apply -f ${k8s_config_dir}/sniffer.yml
echo

echo "Now you can ssh into sniffer-pod pod and read all network traffic with commands:"
echo "# kubectl exec -it sniffer-pod sh"
echo "$ tcpdump -r /data/dump*"
echo
