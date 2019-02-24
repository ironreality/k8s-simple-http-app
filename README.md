# Test K8s project

## Prerequisites

1. Kubernetes installed via kubeadm.
2. The cluster consists from two nodes.
3. A simple HTTP app deployed into the cluster as a replica set with two pods.
4. Nginx is used as ingress to access the app.
5. We have possibility to capture the app's traffic from a separate pod.

## Implementation

1. To spin up the needed k8s nodes the next tools are used:
  * Hashicorp's [Vagrant](https://www.vagrantup.com/) - to create & provision the nodes as virtual machines
  * [Bento's](https://github.com/chef/bento) projec't vm templates
  * Oracle's VirtualBox as the Vagrant's provider - to run the virtual mashines
