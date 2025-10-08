#!/bin/bash
echo "setting up the cert-manager and replicator"
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.19.0/cert-manager.yaml
sleep 15
kubectl apply -f https://raw.githubusercontent.com/mittwald/kubernetes-replicator/master/deploy/rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/mittwald/kubernetes-replicator/master/deploy/deployment.yaml
echo "waiting for the cert-manager to be running"
p=0
export timedOut="false"
export notRunning="true"
while [[ $notRunning == "true" ]]
do
  kubectl -n cert-manager get pods
  export pending=$(kubectl -n cert-manager get pods | grep -E 'Pending|ContainerCreating|Failed|Crash|0/1')
  echo "pending: $pending"
  export running=$(kubectl -n cert-manager get pods | grep -E 'Running')
  if [[ -z "$running" ]]; then
    echo "cert manager not running yet"
  else
    if [[ -z "$pending" ]]; then
      echo "cert manager appears to be up and running"
      export notRunning="false"
    else
      echo "some of the pods are running, but some are not"
    fi
  fi
  ((p++))
  if [[ $p -gt 8 ]]; then
    echo "timed out waiting for cert-manager to start"
    export notRunning="false"
    export timedOut="true"
  else
    if [[ $notRunning == "true" ]]; then
      echo "sleeping a bit before checking again."
      sleep 15
    fi
  fi
done
if [[ $timedOut == "true" ]]; then
  echo "something went wrong, the cert-manager never started, so I am bailing on the rest right now."
  exit 1
fi
echo "cert manager and replicator installed."
