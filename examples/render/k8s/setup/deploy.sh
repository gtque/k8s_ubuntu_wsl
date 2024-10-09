#!/bin/bash
set -euo pipefail

printf "Dry running install...\n"
kubectl --v=0 --validate=true --dry-run=client create -f $TEMPLATE_DIR
sleep 1

printf "Dry run succeeded.\nInstalling manifests...\n"
kubectl --v=0 apply -f $TEMPLATE_DIR
sleep 1