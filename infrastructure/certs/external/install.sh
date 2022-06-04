#!/bin/bash
echo "adding external secrets repo"
helm repo add external-secrets https://external-secrets.github.io/kubernetes-external-secrets/
echo "installing external-secrets"
helm install [RELEASE_NAME] external-secrets/kubernetes-external-secrets