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

# Build the docker image, tag it with a custom tag and push it to the given CR namespace
log_info "Building image, tagging as $TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH and latest\n"
docker build --tag $cr_endpoint/$cr_namespace/$cr_repository:$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH .
docker tag $cr_endpoint/$cr_namespace/$cr_repository:$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH $cr_endpoint/$cr_namespace/$cr_repository:latest
log_info "Displaying docker images\n"
docker images

################################################
# Push docker image  to IBM Container Registry #
################################################

log_info "Pushing image to container registry\n"
docker push $cr_endpoint/$cr_namespace/$cr_repository:$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH
if [ $? -ne 0 ]; then
  log_info "Failed to push image to IBM Cloud container registry, quota may be exceeded.\n"
  exit 1
else
  docker push $cr_endpoint/$cr_namespace/$cr_repository:latest
fi
