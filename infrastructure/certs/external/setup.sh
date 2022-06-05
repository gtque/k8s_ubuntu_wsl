#!/bin/bash
echo "applying external secret managers..."
kubectl apply -f /usr/local/bin/k8s_ubuntu_wsl/infrastructure/certs/external/k8s

#the bellow could be simplified to check for all the certs in the same loop but
#i was lazy and just copied and pasted the code for now, because I just want it to work first.
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
