#!/bin/bash

module=${module:-infrastructure}
example=${example:-k8s}
config=${config:-config/local-dev/config-examples.yml}
is_debug=${is_debug:-true}

export SKIP_TEMPLATE=false
export SKIP_STANDARD=false

export _requested_help="false"
while [ $# -gt 0 ]; do
  if [[ $1 == *"--"* ]]; then
    param="${1/--/}"
    declare $param="$2"
    shift
  elif [[ $1 == "-debug" ]]; then
    param="is_debug"
    declare $param="true"
  elif [[ $1 == "-live" ]]; then
    param="is_debug"
    declare $param="false"
  elif [[ $1 == "?" ]]; then
    export helped=true
    echo "Usage:"
    echo -e "  -debug\n\t  run as local debug deployment/teardown, preserves rendered templates, this is the default mode"
    echo -e "  -live\n\t  run as live deployment/teardown, including auto clean up of rendered templates."
    echo -e "  --module [relative\\path\\\to\\module]\n\t  the path to the module to be deployed\n\t example: --module infrastructure\n\t example: --module simpleApiServer"
    echo -e "  --example [example\\type]\n\t  the path to the example type, java|k8s|go etc...\n\t example: --example k8s\n\t example: --example java"
    echo -e "  --config [relative\\path\\\to\\\config.yml]\n\t  the path to the config.yml file to use for the deployment."
    export _requested_help="true"
  fi
  shift
done
if [ "$config" == "" ]; then
  echo "config not set"
  if [ "$is_debug" == "true" ]; then
    echo "debug true, defaulting to local-dev/config.yml"
    config="$_WORKING_DIR/local-dev/config.yml"
  else
    config="false"
  fi
else
  config="$_WORKING_DIR/$config"
fi

export _module=$example/modules/$module
export _config=$config
export _is_debug=$is_debug
