#!/bin/bash
# Usage : chmod +x ./scripts/* && ./scripts/deploy.sh <Container Registry Namespace>

# Setting variables for output coloring
mag=$'\e[1;35m'
end=$'\e[0m'

cr_namespace=$1
run_locally=$2
cr_endpoint="uk.icr.io"
cluster_name="develop_cluster"
deployment_name="sweng-devops-develop-deployment"
printf "${mag}**********************Variables**********************\n${end}"
printf "${mag}Container Registry Namespace: $cr_namespace\n${end}"
printf "${mag}Container Registry API endpoint: $cr_endpoint\n${end}"
printf "${mag}Cluster name: $cluster_name\n${end}"
printf "${mag}Deployment name: $deployment_name\n${end}"

# Download and install the IBM cloud CLI tools.
printf "${mag}*****\nInstalling IBM Cloud CLI\n*****\n${end}"
curl -sL https://ibm.biz/idt-installer | bash

# Logging into the IBM Cloud environment using env variable of API key
printf "${mag}*****\nLogging into IBM Cloud using apikey\n*****\n${end}"
ibmcloud login -a https://api.eu-gb.bluemix.net --apikey $DEVOPS_IBM_KEY
if [ $? -ne 0 ]; then
  printf "${mag}*****\nFailed to authenticate to IBM Cloud\n*****\n${end}"
  exit 1
fi

# Logging into the IBM Cloud container registry
printf "${mag}*****\nLogging into IBM Cloud container registry\n*****\n${end}"
ibmcloud cr login
if [ $? -ne 0 ]; then
  printf "${mag}*****\nFailed to authenticate to IBM Cloud container registry\n*****\n${end}"
  exit 1
fi

# Setting timestamp to be used in custom image tag
DEPLOY_TIMESTAMP=`date +'%Y%m%d-%H%M%S'`

# Build the docker image, tag it with a custom tag and push it to the given CR namespace
printf "${mag}*****\nBuilding image, tagging as $DEPLOY_TIMESTAMP-$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH and latest\n*****\n${end}"
docker build --tag $cr_endpoint/$cr_namespace/$cr_namespace:$DEPLOY_TIMESTAMP-$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH .
docker tag $cr_endpoint/$cr_namespace/$cr_namespace:$DEPLOY_TIMESTAMP-$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH $cr_endpoint/$cr_namespace/$cr_namespace:latest

# Push built image to Container Registry
printf "${mag}*****\nPushing image to container registry\n*****\n${end}"
docker push $cr_endpoint/$cr_namespace/$cr_namespace:$DEPLOY_TIMESTAMP-$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH
if [ $? -ne 0 ]; then
  printf "${mag}*****\nFailed to push image to IBM Cloud container registry, quota may be exceeded.\n*****\n${end}"
  ibmcloud cr quota
  exit 1
else
  docker push $cr_endpoint/$cr_namespace/$cr_namespace:latest
fi

#############################################
# Deploy to pre-existing kubernetes cluster #
#############################################

if [ $run_locally == 'run-locally' ]; then
    printf "${mag}*****\nInstalling kubectl using Homebrew.\n*****\n${end}"
    brew install kubectl
    brew upgrade kubernetes-cli
else
    printf "${mag}*****\nInstalling kubectl\n*****\n${end}"
    curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
fi

# Make sure that ibmcloud kubernetes-service is up to date
ibmcloud plugin update kubernetes-service
export IKS_BETA_VERSION=1

# Configure our pre-existing cluster.
printf "${mag}*****\nConfiguring cluster\n*****\n${end}"
ibmcloud ks cluster config --cluster $cluster_name

# Remove previous deployment and create new deployment
printf "${mag}*****\nCreating deployment on cluster pointing to image $cr_endpoint/$cr_namespace/$cr_namespace:latest\n*****\n${end}"
kubectl delete deployment $deployment_name
kubectl create deployment $deployment_name --image=$cr_endpoint/$cr_namespace/$cr_namespace:latest

# Expose the deployment on port 3000
printf "${mag}*****\nExposing the deployment on port 3000\n*****\n${end}"
kubectl expose deployment/$deployment_name --type="NodePort" --port 3000

# Install jq for processing json from ibmcloud cli
printf "${mag}*****\nInstalling jq\n*****\n${end}"
if [ "$run_locally" == "run-locally" ]; then
    brew install jq
else
    sudo apt-get install jq
fi

# Extract the public IP for the cluster
public_ip=$(ibmcloud ks workers $cluster_name -json | jq -r '.[0].publicIP')
# Extract the NodePort of the kubernetes service
nodeport=$(kubectl get service $deployment_name -o json | jq -r '.spec.ports[0].nodePort')

printf "${mag}*****\nThe application can now be viewed at http://$public_ip:$nodeport/\n*****\n${end}"