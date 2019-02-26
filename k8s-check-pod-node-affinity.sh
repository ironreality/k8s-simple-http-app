#!/bin/bash

podlabel=${1:-helloworld-http}

echo
echo "Checking the placement for pods with with label: ${podlabel} ..."
echo

echo -e "POD NAME\t\t\t\tNODE NAME"
kubectl get pods  -l app="${podlabel}" -o go-template='{{range .items}}{{.metadata.name}}{{"\t"}}{{.spec.nodeName}}{{"\n"}}{{end}}'
