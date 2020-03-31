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

run_locally="false"
environment=$1
printf "${mag}**********************Variables**********************\n${end}"
printf "${mag}Running script locally: $run_locally\n${end}"
printf "${mag}Logging into environment: $environment\n${end}"

# Download and install the IBM cloud CLI tools.
log_info "Installing IBM Cloud CLI\n"
curl -sL https://ibm.biz/idt-installer | bash

# Choosing which api key to use depending on whether develop or prod environment is being used.
if [ "$environment" == "develop" ]; then
  API_KEY=$DEVOPS_IBM_DEV_KEY
  REGION="eu-de"
elif [ "$environment" == "production" ]; then
  API_KEY=$DEVOPS_IBM_PROD_KEY
  REGION="us-south"
else
  logging_color=$red
  log_info "Unable to identify targeted environment. Given environment: $environment\n"
  exit 1
fi

# Logging into the IBM Cloud environment using env variable of API key
log_info "Logging into IBM Cloud using apikey\n"
ibmcloud login --apikey $API_KEY -r $REGION 
if [ $? -ne 0 ]; then
  logging_color=$red
  log_info "Failed to authenticate to IBM Cloud\n"
  exit 1
fi

# Logging into the IBM Cloud container registry
log_info "Logging into IBM Cloud container registry\n"
ibmcloud cr login
if [ $? -ne 0 ]; then
  logging_color=$red
  log_info "Failed to authenticate to IBM Cloud container registry\n"
  exit 1
fi