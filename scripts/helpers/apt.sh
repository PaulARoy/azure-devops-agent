#!/bin/bash
################################################################################
##  File:  apt.sh
##  Team:  CI-Platform
##  Desc:  This script contains helper functions for using dpkg and apt
##  Author: Roberto Prevato (https://github.com/RobertoPrevato/AzureDevOps-agents)
################################################################################

## Use dpkg to figure out if a package has already been installed
## Example use:
## if ! IsInstalled packageName; then
##     echo "packageName is not installed!"
## fi
function IsInstalled {
    dpkg -S $1 &> /dev/null
}

# Configure apt to always assume Y
echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

# Use apt-fast for parallel downloads
apt-get install aria2
add-apt-repository -y ppa:apt-fast/stable
apt-get update
apt-get -y install apt-fast