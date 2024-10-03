#!/bin/bash
set -euo pipefail

echo "running ansible templating..."
#for more verbose ansible output add: -vvvvv
export _MODULE_DIR=$(pwd)
echo "ansible-playbook $_WORKING_DIR/modules/render/ansible/site.yml -i hosts -e \"template_output_dir=$TEMPLATE_DIR\" -e \"template_input_dir=$_MODULE_DIR/k8s/templates\" -e @$_config -e \"playbook_operations=render\" -D"
ansible-playbook $_WORKING_DIR/modules/render/ansible/site.yml -i hosts -e "template_output_dir=$TEMPLATE_DIR" -e "template_input_dir=$_MODULE_DIR/k8s/templates" -e @$_config -e "playbook_operations=render" -D
sleep 1

FILES_TEMPLATE_DIR=$_WORKING_DIR/$_module/k8s/templates/scripts
if [ -d $FILES_TEMPLATE_DIR ]; then
  echo "Adding scripts to configmap...\n"
  echo "files directory: $FILES_TEMPLATE_DIR"
  config_files="$FILES_TEMPLATE_DIR/*"
  echo "files should be in: $config_files"
  for fname in $config_files
  do
    echo "processing: $fname"
    ansible-playbook $_WORKING_DIR/modules/render/ansible/site.yml -i hosts -e "template_output_dir=$TEMPLATE_DIR" -e "template_input_dir=$fname" -e @$_config -e "playbook_operations=render" -D
    config_maps="$fname/*.j2"
    script_files="$fname/*.sh"
    for config_map in $config_maps
    do
      echo "  templating: $config_map"
        for sname in $script_files
        do
          _FILE=$(basename "$sname")
          _CM_FILE=$(basename "$config_map" | sed 's/.j2//')
          echo "    replacing $_FILE: $_CM_FILE"
          echo "  $_FILE: |" >> $TEMPLATE_DIR/$_CM_FILE
          echo "$(echo -e -n "$(cat $sname | sed 's/^/    /')")" >> $TEMPLATE_DIR/$_CM_FILE
        done
    done
  done
  sleep 1
fi