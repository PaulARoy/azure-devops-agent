#!/bin/bash
################################################################################
##  File:  repos.sh
##  Team:  CI-Platform
##  Desc:  Installs official Microsoft package repos for the distribution
##  Author: Roberto Prevato (https://github.com/RobertoPrevato/AzureDevOps-agents)
################################################################################

LSB_RELEASE=$(lsb_release -rs)

# Install Microsoft repository
wget https://packages.microsoft.com/config/ubuntu/$LSB_RELEASE/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
apt-get update

# Install Microsoft GPG public key
curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -