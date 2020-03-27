#!/bin/bash

# Setting up colored outputs
mag=$'\e[1;35m'
grn=$'\e[1;32m'
blu=$'\e[1;34m'
red=$'\e[1;31m'
end=$'\e[0m'

logging_color=$mag
log_info () {
  printf "${logging_color}*****\n${end}"
  printf "${logging_color}$1${end}"
  printf "${logging_color}*****\n${end}"
}

environment=$1
# Setting variables based on targeted deployment environment
if [ "$environment" == "develop" ]; then
  cr_region="de.icr.io"
  cr_namespace="sweng-devops"
  cr_repository="sweng-devops"
  cluster_name="develop_cluster"
  deployment_name="sweng-devops"
elif [ "$environment" == "production" ]; then
  cr_region="us.icr.io"
  cr_namespace="sweng-devops"
  cr_repository="sweng-devops"
  cluster_name="prod_cluster"
  deployment_name="sweng-devops"
else
  logging_color=$red
  log_info "Unable to identify targeted environment. Given environment: $environment\n"
  exit 1
fi

printf "${mag}**********************Variables**********************\n${end}"
printf "${mag}Deploying to $environment environment.\n${end}"
printf "${mag}Container Registry Namespace: $cr_namespace\n${end}"
printf "${mag}Container Registry Repository: $cr_repository\n${end}"
printf "${mag}Container Registry Region: $cr_region\n${end}"
printf "${mag}Cluster name: $cluster_name\n${end}"
printf "${mag}Deployment name: $deployment_name\n\n${end}"

#############################################
# Deploy to pre-existing kubernetes cluster #
#############################################

# Configure our pre-existing cluster.
log_info "Configuring cluster\n"
ibmcloud ks cluster config --cluster $cluster_name

# Discover whether current deployment is blue or green
current_deployment=$(kubectl get service sweng-devops -o json | jq -r '.spec.selector.deployment')
if [ "$current_deployment" == "blue" ]; then
  printf "${blu}Current deployment is $current_deployment.\n${end}"
  # Create green deployment, using image just built in 'bake' stage.
  DEPLOYMENT=green REGION=$cr_region NAMESPACE=$cr_namespace REPOSITORY=$cr_repository IMAGE_TAG=$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH \
  envsubst < deployment.yml | kubectl apply -f -
  # Wait for this deployment to be ready.
  kubectl rollout status deployment sweng-devops-green
  # Switch from serving blue deployment to green
  # Actually updating the selector on the service exposing the deployment.
  DEPLOYMENT=green \
  envsubst < service.yml | kubectl apply -f -
  logging_color=$grn
  log_info "Created green deployment.\n"

elif [ "$current_deployment" == "green" ]; then
  printf "${grn}Current deployment is $current_deployment.\n${end}"
  # The same as above, but swapping green for blue
  DEPLOYMENT=blue REGION=$cr_region NAMESPACE=$cr_namespace REPOSITORY=$cr_repository IMAGE_TAG=$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH \
  envsubst < deployment.yml | kubectl apply -f -
  kubectl rollout status deployment sweng-devops-blue
  DEPLOYMENT=blue \
  envsubst < service.yml | kubectl apply -f -
  logging_color=$blu
  log_info "Created blue deployment.\n"

else
  logging_color=$red
  log_info "Current deployment color is invalid, current deployment: $current_deployment.\n"
  exit 1
fi

# Extract the public IP for the cluster
public_ip=$(ibmcloud ks workers --cluster $cluster_name --json -s | jq -r '.[0].publicIP')
# Extract the NodePort of the kubernetes service
nodeport=$(kubectl get service $deployment_name -o json | jq -r '.spec.ports[0].nodePort')

log_info "The application can now be viewed at http://$public_ip:$nodeport/\n"
