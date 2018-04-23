#!/usr/bin/env bash
#
# deploy.sh - Deploy the platform
#

# Interactive error handler
trap _error_handler ERR
function _error_handler() {
  echo -e "\e[1;31m=> Previous command exited unsuccessfully. Press any key to continue.\e[0m"
  read -n 1
}

[[ $1 == "--certificates" ]] && CERTS=1

# Update frontend module
git submodule init
git submodule update
(cd web && git pull)

# Build app image
docker build -t openwebslides/openwebslides:latest

# Deploy containers
if [[ ${CERTS} -eq 1 ]]; then
  docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
else
  docker-compose up -d
fi
