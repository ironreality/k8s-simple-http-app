#!/bin/bash
# The script outputs current pod-node placement.
# By default it filters the pods labeled "app=helloworld-http"

podname=$1

if [[ -z ${podname} ]]; then
  echo "Usage: k8s-sniff-pod.sh [POD_NAME]"
  exit
fi

echo
echo "Trying to connect to the network namespace of ${podname} pod..."
echo

container_id=$(kubectl get pods "${podname}" -o jsonpath='{.status.containerStatuses[0].containerID}' | cut -c 10-21) || { echo "Can't find pod with name: ${podname}! Exiting..."; exit 1; }

container_pid=$(docker inspect --format '{{ .State.Pid }}' ${container_id}) || { echo "Can't find the pod's container on this node! Exiting..."; exit 1; }

echo "Sniffing traffic for pod: ${podname} with tcpdump..."
nsenter -t ${container_pid} -n tcpdump -nn -i any

