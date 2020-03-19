#!/bin/bash
# Usage : chmod +x ./scripts/* && ./scripts/deploy.sh <Container Registry Namespace>

# Setting up colored outputs
mag=$'\e[1;35m'
end=$'\e[0m'
log_info () {
  printf "${mag}*****\n${end}"
  printf "${mag}$1${end}"
  printf "${mag}*****\n${end}"
}

environment=$1
# Setting variables based on targeted deployment environment
if [ "$environment" == "develop" ]; then
  cr_namespace="sweng-devops"
  cr_repository="sweng-devops"
  cr_endpoint="uk.icr.io"
  cluster_name="develop_cluster"
  deployment_name="sweng-devops-develop-deployment"
elif [ "$environment" == "production" ]; then
  cr_namespace="sweng-devops-prod"
  cr_repository="sweng-devops"
  cr_endpoint="uk.icr.io"
  cluster_name="prod_cluster"
  deployment_name="sweng-devops-prod-deployment"
else
  log_info "Unable to identify targeted environment. Given environment: $environment\n"
  exit 1
fi

cr_namespace="sweng-devops"
cr_endpoint="uk.icr.io"
cluster_name="develop_cluster"
deployment_name="sweng-devops-develop-deployment"
printf "${mag}**********************Variables**********************\n${end}"
printf "${mag}Deploying to $environment environment.\n${end}"
printf "${mag}Container Registry Namespace: $cr_namespace\n${end}"
printf "${mag}Container Registry Repository: $cr_repository\n${end}"
printf "${mag}Container Registry API endpoint: $cr_endpoint\n${end}"
printf "${mag}Cluster name: $cluster_name\n${end}"
printf "${mag}Deployment name: $deployment_name\n\n${end}"

#############################################
# Deploy to pre-existing kubernetes cluster #
#############################################

# Configure our pre-existing cluster.
log_info "Configuring cluster\n"
ibmcloud ks cluster config --cluster $cluster_name

# Remove previous deployment and create new deployment
log_info "Creating deployment on cluster pointing to image $cr_endpoint/$cr_namespace/$cr_repository:latest\n"
kubectl delete deployment $deployment_name
kubectl create deployment $deployment_name --image=$cr_endpoint/$cr_namespace/$cr_repository:latest

# Expose the deployment on port 3000
log_info "Exposing the deployment on port 3000\n"
kubectl expose deployment/$deployment_name --type="NodePort" --port 80

# Extract the public IP for the cluster
public_ip=$(ibmcloud ks workers --cluster $cluster_name --json -s | jq -r '.[0].publicIP')
# Extract the NodePort of the kubernetes service
nodeport=$(kubectl get service $deployment_name -o json | jq -r '.spec.ports[0].nodePort')

log_info "The application can now be viewed at http://$public_ip:$nodeport/\n"