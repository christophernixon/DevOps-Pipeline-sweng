#!/bin/bash

# Setting up colored outputs
mag=$'\e[1;35m'
end=$'\e[0m'
log_info () {
  printf "${mag}*****\n${end}"
  printf "${mag}$1${end}"
  printf "${mag}*****\n${end}"
}

cr_namespace=$1
cr_endpoint="uk.icr.io"
cr_repository="sweng-devops"
printf "${mag}**********************Variables**********************\n${end}"
printf "${mag}Container Registry Namespace: $cr_namespace\n${end}"
printf "${mag}Container Registry Repository: $cr_repository\n${end}"
printf "${mag}Container Registry API endpoint: $cr_endpoint\n${end}"

##################################################################
# Run retention policy to ensure storage limits aren't exceeded. #
##################################################################

log_info "Running retention policy to keep only most-recent image in CR."
ibmcloud cr retention-run -f --images 30 $cr_namespace

#######################################################
# Build the docker image and tag it with a custom tag #
#######################################################

log_info "Building image, tagging as $TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH and latest\n"
docker build --tag $cr_endpoint/$cr_namespace/$cr_repository:$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH .
docker tag $cr_endpoint/$cr_namespace/$cr_repository:$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH $cr_endpoint/$cr_namespace/$cr_repository:latest
log_info "Displaying docker images\n"
docker images

###############################################
# Push docker image to IBM Container Registry #
###############################################

log_info "Pushing image to container registry\n"
docker push $cr_endpoint/$cr_namespace/$cr_repository:$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH
if [ $? -ne 0 ]; then
  log_info "Failed to push image to IBM Cloud container registry, quota may be exceeded.\n"
  ibmcloud cr quota
  ibmcloud cr images
  exit 1
else
  docker push $cr_endpoint/$cr_namespace/$cr_repository:latest
fi