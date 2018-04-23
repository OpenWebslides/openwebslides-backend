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

# Command line argument parser
case "$1" in
  "--production")
    deploy_prod
    ;;
  "--dev")
    deploy_dev
    ;;
  *)
    echo "$0 --production | --dev"
    exit 1
esac

function update_frontend() {
  # Update frontend module
  git submodule init
  git submodule update
  (cd web && git pull)
}

function deploy_prod() {
  update_frontend

  docker build -t openwebslides/openwebslides:latest
  docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
}

function deploy_dev() {
  update_frontend

  docker build -t openwebslides/openwebslides:latest
  docker-compose up -d
}
