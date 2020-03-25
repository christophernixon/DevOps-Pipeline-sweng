#!/bin/bash

# Setting up colored outputs
mag=$'\e[1;35m'
end=$'\e[0m'
log_info () {
  printf "${mag}*****\n${end}"
  printf "${mag}$1${end}"
  printf "${mag}*****\n${end}"
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
ibmcloud login -a https://api.eu-gb.bluemix.net --apikey $DEVOPS_IBM_KEY
if [ $? -ne 0 ]; then
  log_info "Failed to authenticate to IBM Cloud\n"
  exit 1
fi
# Making sure we are logged into the UK registry
ibmcloud cr login
ibmcloud cr region-set uk
# Pull latest image
docker pull $cr_endpoint_dev/$cr_namespace_dev/$cr_repository_dev:latest
# Re-tag image
docker tag $cr_endpoint_dev/$cr_namespace_dev/$cr_repository_dev:latest $cr_endpoint/$cr_namespace/$cr_repository:latest
log_info "Pushing re-tagged image to production environment."
# Logging into the production IBM Cloud environment.
ibmcloud login -a https://api.eu-gb.bluemix.net --apikey $DEVOPS_IBM_PROD_KEY
if [ $? -ne 0 ]; then
  log_info "Failed to authenticate to IBM Cloud\n"
  exit 1
fi
# Making sure we are logged into the Dallas registry
ibmcloud cr login
ibmcloud cr region-set us-south
docker push $cr_endpoint/$cr_namespace/$cr_repository:latest
log_info "Making sure image was pushed to production environment."
ibmcloud cr images