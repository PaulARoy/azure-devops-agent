#!/bin/bash
################################################################################
##  File:  preparemetadata.sh
##  Team:  CI-Platform
##  Desc:  This script adds a image title information to the metadata
##         document
##  Author: Roberto Prevato (https://github.com/RobertoPrevato/AzureDevOps-agents)
################################################################################

source $HELPER_SCRIPTS/document.sh

AddTitle "Self-hosted Ubuntu 20.04 Image ($(lsb_release -ds))"
WriteItem "The following software is installed on machines in the Self-hosted Ubuntu 20.04 pool"
WriteItem "***"