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
export _current_dir=$(pwd)
echo "gradle build of: ${module}"
cd java
if [ "$is_clean" == "true" ]; then
  ./gradlew ${module}:clean
fi
#./gradlew ${module}:copyAllDependencies
./gradlew ${module}:build
docker build --build-arg SIGNING_KEY_ID --build-arg SIGNING_KEY_PASSWORD --build-arg PUBLIC_KEY_ID --build-arg MODULE=${module} --target=image -t localhost:32000/example-java-${_image_name}:local -f ./docker/gradle/Dockerfile . --progress=plain
cd $_current_dir
if [ "$is_publish" == "true" ]; then
  docker push localhost:32000/example-java-${_image_name}:local
  microk8s ctr images ls name~='localhost:32000' | awk {'print $1'} | grep -E '@sha256' | xargs -I% microk8s ctr images rm %
fi
echo "deleting dangling images from docker"
docker rmi $(docker images -f "dangling=true" -q)