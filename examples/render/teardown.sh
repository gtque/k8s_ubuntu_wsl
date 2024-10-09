#!/bin/bash
_pv=$(kubectl -n eangeli get pvc minecraft-jujutsu1 -o yaml | yq e '.spec.volumeName' -)
echo "deleting the job"
kubectl -n eangeli delete deployment minecraft-jujutsu1
echo "pod deleted, deleting the pvc"
kubectl -n eangeli delete pvc minecraft-jujutsu1
echo "pvc deleted, will try to delete the private volume: $_pv"
kubectl delete pv $_pv --grace-period=0 --force &
echo "force finalizers to null..."
kubectl patch pv $_pv -p '{"metadata":{"finalizers":null}}'
echo "everything should be deleted..."
kubectl -n eangeli get pod
kubectl -n eangeli get pvc
kubectl get pv
