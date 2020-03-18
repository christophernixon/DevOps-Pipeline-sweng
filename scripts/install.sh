#!/bin/bash

# Setting up colored outputs
mag=$'\e[1;35m'
end=$'\e[0m'
log_info () {
  printf "${mag}*****\n${end}"
  printf "${mag}$1${end}"
  printf "${mag}*****\n${end}"
}

run_locally=$1
printf "${mag}**********************Variables**********************\n${end}"
printf "${mag}Running script locally: $run_locally\n${end}"

# Download and install the IBM cloud CLI tools.
log_info "Installing IBM Cloud CLI\n"
curl -sL https://ibm.biz/idt-installer | bash

# Download and install kubectl
if [ "$run_locally" == "run-locally" ]; then
 log_info "Installing kubectl using Homebrew.\n"
  brew install kubectl
  brew upgrade kubernetes-cli
else
  log_info "Installing kubectl\n"
  curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
  chmod +x ./kubectl
  sudo mv ./kubectl /usr/local/bin/kubectl
fi

# Install jq for processing json from ibmcloud cli
log_info "Installing jq\n"
if [ "$run_locally" == "run-locally" ]; then
    brew install jq
else
    sudo apt-get install jq
fi

# Logging into the IBM Cloud environment using env variable of API key
log_info "Logging into IBM Cloud using apikey\n"
ibmcloud login -a https://api.eu-gb.bluemix.net --apikey $DEVOPS_IBM_KEY
if [ $? -ne 0 ]; then
  log_info "Failed to authenticate to IBM Cloud\n"
  exit 1
fi

# Logging into the IBM Cloud container registry
log_info "Logging into IBM Cloud container registry\n"
ibmcloud cr login
if [ $? -ne 0 ]; then
  log_info "Failed to authenticate to IBM Cloud container registry\n"
  exit 1
fi

# Make sure that ibmcloud kubernetes-service is up to date
ibmcloud plugin update kubernetes-service