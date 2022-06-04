#!/bin/bash
echo "applying the issuer and the cert..."
kubectl apply -f /usr/local/bin/wsl-local-k8s/infrastructure/certs/selfsigned/k8s

export found="false"
i=0
while [[ $found == "false" ]]
do
  export found="true"
  kubectl -n cert-manager get secret local-dev-tls >/dev/null 2>&1 || { \
      echo "no secret yet" & export found="false" ; }
  ((i++))
  if [[ $i -gt 8 ]]; then
    echo "timed out waiting for secret"
    export found="true"
    export timedOut="true"
  fi
  if [[ $found == "false" ]]; then
    echo "sleeping for a bit"
    sleep 15
  else
    echo "I was true...$found"
  fi
done
if [[ $timedOut == "true" ]]; then
  echo "something went wrong, the secret never showed up, so I am bailing on the rest right now."
  exit 1
fi
echo "patching the secret so it can be replicated"
cat <<EOF > local-secret-replicate.yaml
apiVersion: v1
kind: Secret
metadata:
  annotations:
    replicator.v1.mittwald.de/replication-allowed: "true"
    replicator.v1.mittwald.de/replication-allowed-namespaces: ingress,infrastructure,sso.*,dev.*,qa.*
EOF
kubectl -n cert-manager patch secret local-dev-tls --patch "$(cat local-secret-replicate.yaml)"
rm local-secret-replicate.yaml
