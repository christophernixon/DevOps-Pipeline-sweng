#!/bin/bash
# Usage : chmod +x ./scripts/* && ./scripts/execute.sh <Container Registry Namespace>

cr_namespace=$1
cr_endpoint="uk.icr.io"
echo "Container Registry Namespace: $cr_namespace"
echo "Container Registry API endpoint: $cr_endpoint"

# Download and install the IBM cloud CLI tools.
echo "Installing IBM Cloud CLI"
curl -sL https://ibm.biz/idt-installer | bash

# Logging into the IBM Cloud environment using env variable of API key
echo "Logging into IBM Cloud using apikey"
ibmcloud login -a https://api.eu-gb.bluemix.net --apikey $DEVOPS_IBM_KEY
if [ $? -ne 0 ]; then
  echo "Failed to authenticate to IBM Cloud"
  exit 1
fi

# Logging into the IBM Cloud container registry
echo "Logging into IBM Cloud container registry"
ibmcloud cr login
if [ $? -ne 0 ]; then
  echo "Failed to authenticate to IBM Cloud container registry"
  exit 1
fi

# Setting timestamp to be used in custom image tag
DEPLOY_TIMESTAMP=`date +'%Y%m%d-%H%M%S'`

# Build the docker image, tag it with a custom tag and push it to the given CR namespace
echo "Building image, tagging as $DEPLOY_TIMESTAMP-$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH and latest"
docker build --tag $cr_endpoint/$cr_namespace/develop:$DEPLOY_TIMESTAMP-$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH .
docker tag $cr_endpoint/$cr_namespace/develop:$DEPLOY_TIMESTAMP-$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH $cr_endpoint/$cr_namespace/develop:latest

# Push built image to Container Registry
echo "Pushing image to container registry"
docker push $cr_endpoint/$cr_namespace/develop:$DEPLOY_TIMESTAMP-$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH
docker push $cr_endpoint/$cr_namespace/develop:latest