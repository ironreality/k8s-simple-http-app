# Test K8s project

## Prerequisites

1. Kubernetes installed via kubeadm.
2. The cluster consists from two nodes.
3. A simple HTTP app deployed into the cluster as a replica set with two pods.
4. Nginx is used as ingress to access the app.
5. We have possibility to capture the app's traffic from a separate pod.
