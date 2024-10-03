#!/bin/bash
kubectl -n projectcontour delete Gateway contour
kubectl delete GatewayClass contour
kubectl delete -f https://projectcontour.io/quickstart/contour-gateway-provisioner.yaml
