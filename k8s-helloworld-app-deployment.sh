#!/bin/bash
# The script deploys a simple web application along with needed services and a Nginx-based ingress

k8s_config_dir=/vagrant/k8s-configs

echo "Creating simple HTTP web application..."
kubectl apply -f ${k8s_config_dir}/helloworld.yml

echo "Deploying Nginx ingress controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml && \
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/baremetal/service-nodeport.yaml|| { echo "Can't deploy Nginx ingress controller! Exiting..."; exit 1; }

echo "Creating the ingress for the simple HTTP app..."
kubectl apply -f ${k8s_config_dir}/ingress.yml

sleep 5
echo
echo "Determining the NodePort's port..."
ipaddr=$(ifconfig eth1 | grep -i Mask | awk '{print $2}'| cut -f2 -d:)
port=$(kubectl get services -n ingress-nginx -o go-template='{{range .items}}{{range.spec.ports}}{{ if eq .name "https" }}{{.nodePort}}{{"\n"}}{{end}}{{end}}{{end}}')
if [[ ! -z ${port} ]]; then
  echo "The service's HTTPS port is: ${port}"
  echo "Now you can access the app's pods with such query:"
  echo "curl -k https://${ipaddr}:${port}/"
else
  echo "Can't find the service's port! Something went wrong..."
fi
