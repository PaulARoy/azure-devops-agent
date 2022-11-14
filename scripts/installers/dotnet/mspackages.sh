#!/bin/bash
################################################################################
##  File:  mspackages.sh
##  Desc:  Installs MS Packages
##  Author: Roberto Prevato
################################################################################

wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

dpkg -i packages-microsoft-prod.deb

apt-get update