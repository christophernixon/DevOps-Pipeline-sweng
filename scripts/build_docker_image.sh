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
printf "${mag}**********************Variables**********************\n${end}"
printf "${mag}Container Registry Namespace: $cr_namespace\n${end}"
printf "${mag}Container Registry API endpoint: $cr_endpoint\n${end}"

# Setting timestamp to be used in custom image tag
export DEPLOY_TIMESTAMP=`date +'%Y%m%d-%H%M%S'`
# Build the docker image, tag it with a custom tag and push it to the given CR namespace
log_info "Building image, tagging as $DEPLOY_TIMESTAMP-$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH and latest\n"
docker build --tag $cr_endpoint/$cr_namespace/$cr_namespace:$DEPLOY_TIMESTAMP-$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH .
docker tag $cr_endpoint/$cr_namespace/$cr_namespace:$DEPLOY_TIMESTAMP-$TRAVIS_BUILD_NUMBER-$TRAVIS_BRANCH $cr_endpoint/$cr_namespace/$cr_namespace:latest
log_info "Displaying docker images\n"
docker images