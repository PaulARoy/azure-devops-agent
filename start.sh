#!/bin/bash
################################################################################
##  File:  start.sh
##  Desc:  This file starts the agent
##  Author: Microsoft & Roberto Prevato
################################################################################
set -e

print_header() {
  lightcyan='\033[1;36m'
  nocolor='\033[0m'
  echo -e "${lightcyan}$1${nocolor}"
}

if [ -z "$AZP_URL" ]; then
  echo 1>&2 "error: missing AZP_URL environment variable"
  exit 1
fi

if [ -z "$AZP_TOKEN_FILE" ]; then
  if [ -z "$AZP_TOKEN" ]; then
    echo 1>&2 "error: missing AZP_TOKEN environment variable"
    exit 1
  fi

  AZP_TOKEN_FILE=/azp/.token
  echo -n $AZP_TOKEN > "$AZP_TOKEN_FILE"
fi

unset AZP_TOKEN

# Let the user decide whether to update the agent or not
FORCEUPDATE=0
if [ -z "$AZP_UPDATE" ]; then
    print_header "Reusing agent files, if present"
else
    FORCEUPDATE=$AZP_UPDATE
fi

if [ -n "$AZP_WORK" ]; then
  mkdir -p "$AZP_WORK"
fi

if [ $FORCEUPDATE == "1" ]; then
  print_header 'Forcing agent update: deleting /azp/agent folder'
  print_header 'Note: if your AZP_WORK variable is inside /azp/agent; installed tools will be deleted, too'

  rm -rf /azp/agent
  mkdir /azp/agent
fi

if [ ! -e /azp/agent ]; then
  mkdir /azp/agent
fi
cd /azp/agent

export AGENT_ALLOW_RUNASROOT="1"

cleanup() {
  if [ -e config.sh ]; then
    print_header "Cleanup. Removing Azure Pipelines agent..."

    # If the agent has some running jobs, the configuration removal process will fail.
    # So, give it some time to finish the job.
    while true; do
      ./config.sh remove --unattended --auth PAT --token $(cat "$AZP_TOKEN_FILE") && break

      echo "Retrying in 30 seconds..."
      sleep 30
    done
  fi
}

# Let the agent ignore the token env variables
export VSO_AGENT_IGNORE=AZP_TOKEN,AZP_TOKEN_FILE

print_header "1. Determining matching Azure Pipelines agent..."

# Is there already a client here? Maybe we don't need to download 88MB...
if [ -e config.sh ]; then
    print_header "Azure Pipelines files are already installed"
else
  AZP_AGENT_PACKAGES=$(curl -LsS \
      -u user:$(cat "$AZP_TOKEN_FILE") \
      -H 'Accept:application/json;' \
      "$AZP_URL/_apis/distributedtask/packages/agent?platform=$TARGETARCH&top=1")

  AZP_AGENT_PACKAGE_LATEST_URL=$(echo "$AZP_AGENT_PACKAGES" | jq -r '.value[0].downloadUrl')

  if [ -z "$AZP_AGENT_PACKAGE_LATEST_URL" -o "$AZP_AGENT_PACKAGE_LATEST_URL" == "null" ]; then
    echo 1>&2 "error: could not determine a matching Azure Pipelines agent"
    echo 1>&2 "check that account '$AZP_URL' is correct and the token is valid for that account"
    exit 1
  fi

  print_header "2. Downloading and extracting Azure Pipelines agent..."

  curl -LsS $AZP_AGENT_PACKAGE_LATEST_URL | tar -xz & wait $!
fi

source ./env.sh

print_header "3. Configuring Azure Pipelines agent..."

STARTED_FILE=/azp/.started

# NB: a trick to avoid confusing messages: the remove command would 
# not block code execution, even if there is no agent to be removed.
# This way we support restarting the same Docker container; without downloading a package every time.
if [ -e $STARTED_FILE ]; then
  print_header "Removing the previous agent..."
  cleanup
fi

touch $STARTED_FILE

./config.sh --unattended \
  --agent "${AZP_AGENT_NAME:-$(hostname)}" \
  --url "$AZP_URL" \
  --auth PAT \
  --token $(cat "$AZP_TOKEN_FILE") \
  --pool "${AZP_POOL:-Default}" \
  --work "${AZP_WORK:-_work}" \
  --replace \
  --acceptTeeEula & wait $!

print_header "4. Running Azure Pipelines agent..."

trap 'cleanup; exit 0' EXIT
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

chmod +x ./run-docker.sh

# To be aware of TERM and INT signals call run.sh
# Running it with the --once flag at the end will shut down the agent after the build is executed
./run-docker.sh "$@" & wait $!