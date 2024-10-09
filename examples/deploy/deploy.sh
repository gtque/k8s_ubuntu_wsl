#!/bin/bash
set -euo pipefail

trap resetLocal EXIT

function resetLocal {
  if [ "$_is_debug" == true ]; then
    echo "running as debug, not deleting $TEMPLATE_DIR"
  else
    echo "deleting $TEMPLATE_DIR"
    rm -rf $TEMPLATE_DIR
  fi
}

export _WORKING_DIR=$(pwd)

source ./deploy/parse_parameters.sh

if [ "$_requested_help" == "true" ]; then
  if [ "$_is_debug" == true ]; then
    echo "config: $_config"
    echo "module: $_module"
  fi
  exit 0
fi

if [ "$_config" == "false" ]; then
  echo "--config must be specified, otherwise there is nothing to use for rendering."
  exit 1
fi

echo "ansible config:"
cat $_config


echo "switching to module: $_module"
cd $_module

printf "Creating temporary directory.\n"
if [ "$_is_debug" == true ]; then
  TEMPLATE_DIR=$(pwd)/k8s/rendered
  if [ -d $TEMPLATE_DIR ]; then
    echo "rendered folder already exists, clearing directory."
    rm -rf $TEMPLATE_DIR
  fi
  mkdir $TEMPLATE_DIR
else
  export TEMPLATE_DIR=$(mktemp -d)
fi

if [ -f ./$deploy_action/pre.sh ]; then
  echo "processing ./$deploy_action/pre.sh"
  source ./$deploy_action/pre.sh
else
  echo "no ./$deploy_action/pre.sh"
fi

if [ "$SKIP_TEMPLATE" == "false" ]; then
  echo "rendering templates"
  source $_WORKING_DIR/render/${deploy_action}.sh
else
  echo "skipping template rendering"
fi

#exit 0

if [ -f ./$deploy_action/afterrender.sh ]; then
  echo "processing ./$deploy_action/afterrender.sh"
  source ./$deploy_action/posttemplate.sh
else
  echo "no ./$deploy_action/afterrender.sh"
fi

if [ "$SKIP_STANDARD" == "false" ]; then
  echo "running standard setup."
  source $_WORKING_DIR/render/k8s/${deploy_action}/deploy.sh
else
  echo "skipping standard $deploy_action"
fi

if [ -f ./$deploy_action/post.sh ]; then
  echo "processing ./$deploy_action/post.sh"
  source ./$deploy_action/post.sh
else
  echo "no ./$deploy_action/post.sh"
fi
