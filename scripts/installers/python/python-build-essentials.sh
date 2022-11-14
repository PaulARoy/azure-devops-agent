#!/bin/bash
################################################################################
##  File:  python-build-essentials.sh
##  Team:  CI-Platform
##  Desc:  Installs required packages for python
##  Author: Roberto Prevato & Paul Roy
################################################################################

# Source the helpers for use with the script
source $HELPER_SCRIPTS/document.sh
source $HELPER_SCRIPTS/apt.sh

echo "Install make"
apt-get install -y --no-install-recommends make

echo "Install libssl-dev"
apt-get install -y --no-install-recommends libssl-dev

echo "Install zlib1g-dev"
apt-get install -y --no-install-recommends zlib1g-dev

echo "Install libbz2-dev"
apt-get install -y --no-install-recommends libbz2-dev

echo "Install libsqlite3-dev"
apt-get install -y --no-install-recommends libsqlite3-dev

echo "Install unixodbc-dev"
apt-get install -y --no-install-recommends unixodbc-dev

echo "Install libncurses5-dev"
apt-get install -y --no-install-recommends libncurses5-dev

echo "Install libgdbm-dev"
apt-get install -y --no-install-recommends libgdbm-dev

echo "Install libnss3-dev"
apt-get install -y --no-install-recommends libnss3-dev

echo "Install libreadline-dev"
apt-get install -y --no-install-recommends libreadline-dev

echo "Install libffi-dev"
apt-get install -y --no-install-recommends libffi-dev

# Document what was added to the image
echo "Lastly, documenting what we added to the metadata file"
DocumentInstalledItem "Basic CLI:"
DocumentInstalledItemIndent "make"
DocumentInstalledItemIndent "libssl-dev"
DocumentInstalledItemIndent "zlib1g-dev"
DocumentInstalledItemIndent "libbz2-dev"
DocumentInstalledItemIndent "libsqlite3-dev"
DocumentInstalledItemIndent "unixodbc-dev"
DocumentInstalledItemIndent "libncurses5-dev"
DocumentInstalledItemIndent "libgdbm-dev"
DocumentInstalledItemIndent "libnss3-dev"
DocumentInstalledItemIndent "libreadline-dev"
DocumentInstalledItemIndent "libffi-dev"