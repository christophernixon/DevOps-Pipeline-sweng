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

cr_namespace=$1
run_locally=$2
cr_endpoint="uk.icr.io"
cluster_name="develop_cluster"
deployment_name="sweng-devops-develop-deployment"
printf "${mag}**********************Variables**********************\n${end}"
printf "${mag}Container Registry Namespace: $cr_namespace\n${end}"
printf "${mag}Container Registry API endpoint: $cr_endpoint\n${end}"
printf "${mag}Cluster name: $cluster_name\n${end}"
printf "${mag}Deployment name: $deployment_name\n\n${end}"

###############################################################
# Push docker image from bake stage to IBM Container Registry #
###############################################################

log_info "Pushing image to container registry\n"
docker push $cr_endpoint/$cr_namespace/$cr_namespace:$DEPLOY_TIMESTAMP-$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH
if [ $? -ne 0 ]; then
  log_info "Failed to push image to IBM Cloud container registry, quota may be exceeded.\n"
  ibmcloud cr quota
  exit 1
else
  docker push $cr_endpoint/$cr_namespace/$cr_namespace:latest
fi

#############################################
# Deploy to pre-existing kubernetes cluster #
#############################################

# Configure our pre-existing cluster.
log_info "Configuring cluster\n"
ibmcloud ks cluster config --cluster $cluster_name

# Remove previous deployment and create new deployment
log_info "Creating deployment on cluster pointing to image $cr_endpoint/$cr_namespace/$cr_namespace:latest\n"
kubectl delete deployment $deployment_name
kubectl create deployment $deployment_name --image=$cr_endpoint/$cr_namespace/$cr_namespace:latest

# Expose the deployment on port 3000
log_info "Exposing the deployment on port 3000\n"
kubectl expose deployment/$deployment_name --type="NodePort" --port 3000

# Extract the public IP for the cluster
public_ip=$(ibmcloud ks workers $cluster_name -json | jq -r '.[0].publicIP')
# Extract the NodePort of the kubernetes service
nodeport=$(kubectl get service $deployment_name -o json | jq -r '.spec.ports[0].nodePort')

log_info "The application can now be viewed at http://$public_ip:$nodeport/\n"