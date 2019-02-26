# Test K8s project

## Prerequisites

To spin up the k8s cluster the next tools have to be installed:
  * Hashicorp's [Vagrant](https://www.vagrantup.com/), version >= 2.2 - to create & provision the nodes as virtual machines.
  * Oracle's VirtualBox, version 5.1 as the Vagrant's provider - to run the virtual mashines.


## Testing platform
  * a PC workstation with 4xCPU / 8 GB RAM / 256 GB SSD


## Network topology

The cluster is being launched in a private (host-only) Virtualbox network. It's eth1 interface on the cluster's vms.

### IP addresses

* master - 172.28.128.2
* node1 - 172.28.128.3

## Workflow

Launch the k8s cluster - it takes up to 10 minutes on the testing platform:
```
vagrant up
```

SSHing into the cluster's master node:
```
$ vagrant ssh master
vagrant@master:~$ sudo su -
root@master:~# 
```
Getting the list of the cluster's nodes:
```
root@master:~# kubectl get nodes
NAME     STATUS   ROLES    AGE   VERSION
master   Ready    master   21m   v1.13.3
node1    Ready    <none>   18m   v1.13.3
```

**Deploying the helloworld-http app's stack (service+deployment+ingress controller+ingress)** - it takes to 5 minutes till the all pods start:

```
root@master:~# /vagrant/k8s-helloworld-app-deployment.sh 
Creating simple HTTP web application...
...
Deploying Nginx ingress controller...
...
Creating the ingress for the simple HTTP app...
..
Determining the NodePort's port...
The service's HTTPS port is: 32377
Now you can access the app's pods with such query:
curl -k https://172.28.128.2:32377/
```

Checing the pods placement:
```
root@master:~# /vagrant/k8s-check-pod-node-affinity.sh 

Checking the placement for pods with with label: helloworld-http ...

POD NAME                                NODE NAME
helloworld-http-6d6ff59b6d-cg76w        master
helloworld-http-6d6ff59b6d-vp799        node2
```

Checking the load balancing works correctly:
```
vagrant@master:~$ exit
$ curl -k https://172.28.128.2:32377/
<html><head><title>HTTP Hello World</title></head><body><h1>Hello from helloworld-http-6d6ff59b6d-vp799</h1></body></html

$ curl -k https://172.28.128.3:32377/
<html><head><title>HTTP Hello World</title></head><body><h1>Hello from helloworld-http-6d6ff59b6d-cg76w</h1></body></html
```

