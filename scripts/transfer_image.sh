#!/bin/bash

# Setting up colored outputs
mag=$'\e[1;35m'
red=$'\e[1;31m'
end=$'\e[0m'
logging_color=$mag
log_info () {
  printf "${logging_color}*****\n${end}"
  printf "${logging_color}$1${end}"
  printf "${logging_color}*****\n${end}"
}

cr_endpoint="us.icr.io"
cr_namespace="sweng-devops"
cr_repository="sweng-devops"
cr_endpoint_dev="uk.icr.io"
cr_namespace_dev="sweng-devops"
cr_repository_dev="sweng-devops"
printf "${mag}**********************Variables**********************\n${end}"
printf "${mag}Container Registry API endpoint: $cr_endpoint\n${end}"
printf "${mag}Container Registry Namespace: $cr_namespace\n${end}"
printf "${mag}Container Registry Repository: $cr_repository\n${end}"
printf "${mag}Container Registry Dev API endpoint: $cr_endpoint_dev\n${end}"
printf "${mag}Container Registry Dev Namespace: $cr_namespace_dev\n${end}"
printf "${mag}Container Registry Dev Repository: $cr_repository_dev\n${end}"

######################################
# Pulling Image from Dev environment #
######################################
log_info "Pulling and re-tagging latest image from develop environment."
# Logging into the develop IBM Cloud environment.
ibmcloud login -a https://api.eu-gb.bluemix.net --apikey $DEVOPS_IBM_DEV_KEY
if [ $? -ne 0 ]; then
  logging_color=$red
  log_info "Failed to authenticate to IBM Cloud\n"
  exit 1
fi
# Making sure we are logged into the UK registry
ibmcloud cr region-set uk
ibmcloud cr login

##################################################################
# Run retention policy to ensure storage limits aren't exceeded. #
##################################################################

log_info "Running retention policy to keep only most-recent image in CR."
ibmcloud cr retention-run -f --images 30 $cr_namespace

# Pull latest image
docker pull $cr_endpoint_dev/$cr_namespace_dev/$cr_repository_dev:latest
if [ $? -ne 0 ]; then
  logging_color=$red
  log_info "Failed to pull image from IBM develop container registry, quota may be exceeded.\n"
  ibmcloud cr quota
  ibmcloud cr images
  exit 1
fi
# Re-tag image
docker tag $cr_endpoint_dev/$cr_namespace_dev/$cr_repository_dev:latest $cr_endpoint/$cr_namespace/$cr_repository:latest
docker tag $cr_endpoint/$cr_namespace/$cr_repository:latest $cr_endpoint/$cr_namespace/$cr_repository:$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH
log_info "Showing docker images"
docker images
log_info "Pushing re-tagged image to production environment."
# Logging into the production IBM Cloud environment.
ibmcloud login -a https://api.eu-gb.bluemix.net --apikey $DEVOPS_IBM_PROD_KEY
if [ $? -ne 0 ]; then
  logging_color=$red
  log_info "Failed to authenticate to IBM Cloud\n"
  exit 1
fi
# Making sure we are logged into the Dallas registry
ibmcloud cr region-set us-south
ibmcloud cr login
docker push $cr_endpoint/$cr_namespace/$cr_repository:latest
if [ $? -ne 0 ]; then
  logging_color=$red
  log_info "Failed to push image to IBM production container registry, quota may be exceeded.\n"
  ibmcloud cr quota
  ibmcloud cr images
  exit 1
else
  docker push $cr_endpoint/$cr_namespace/$cr_repository:$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH  
fi
log_info "Making sure image was pushed to production environment."
ibmcloud cr images