# Test K8s project

## Prerequisites

To spin up the k8s cluster the next tools have to be installed:
  * Hashicorp's [Vagrant](https://www.vagrantup.com/), version >= 2.2 - to create & provision the nodes as virtual machines
  * Oracle's VirtualBox, version 5.1 as the Vagrant's provider - to run the virtual mashines


## Network topology

The cluster is being launched in a private (host-only) Virtualbox network. It's eth1 interface on the cluster's vms.

### IP addresses

* master - 172.28.128.2
* node1 - 172.28.128.3

## Usage

Launch the k8s cluster
```
vagrant up
```

SSHing into the cluster's node
```
vagrant ssh [master|node1]
```

Get list of the cluster's hosts:
```
vagrant ssh master
sudo su -
kubectl get nodes
```
