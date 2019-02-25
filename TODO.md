# Tasks to perform

1. ~~Install K8s using kubeadm with 2 nodes~~
2. create simple pod(candidate chooses an application that should be something with http access) label it
3. using replicaset adopt pod created in item2 and scale it to 2 (make sure the second application pod is in node 2)
4. install ingress(nginx) to be able to have an external access/balancing to the application.
5. create another simple pod and try to connect from it to the application created before and capture this traffic.
