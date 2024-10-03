#!/bin/bash
_VERSION="0.0.1-SNAPSHOT"
_EXTRA_ARGS=""
if [[ -z "$1" ]]; then
  echo "no extra docker build args specified"
else
  _EXTRA_ARGS=$1
  echo "using extra args: $_EXTRA_ARGS"
fi
#docker build --build-arg SIGNING_KEY_ID --build-arg SIGNING_KEY_PASSWORD --build-arg PUBLIC_KEY_ID --build-arg MODULE=server --target=package -f ./docker/gradle/Dockerfile . --progress=plain
./gradlew simpleApiServer:copyAllDependencies
./gradlew simpleApiServer:build
docker build --build-arg SIGNING_KEY_ID --build-arg SIGNING_KEY_PASSWORD --build-arg PUBLIC_KEY_ID --build-arg MODULE=simpleApiServer --target=image -t localhost:32000/example-server:local -f ./docker/gradle/Dockerfile . --progress=plain
docker push localhost:32000/example-server:local
docker rmi $(docker images -f "dangling=true" -q)
docker system prune --volumes -a -f
microk8s ctr images ls name~='localhost:32000' | awk {'print $1'} | grep -E '@sha256' | xargs -I% microk8s ctr images rm %
