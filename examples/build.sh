#!/bin/bash

module=${module:-simpleApiServer}
language=${language:-java}
is_dockerized=${is_dockerized:-false}
is_publish=${is_publish:-true}
is_clear_cache=${is_clear_cache:-false}
is_clean=${is_clean:-false}
#cd "modules/$1"

export _requested_help="false"
export _extra_args=""

while [ $# -gt 0 ]; do
  if [[ $1 == *"--"* ]]; then
    param="${1/--/}"
    declare $param="$2"
    shift
  elif [[ $1 == "-clean" ]]; then
    param="is_clean"
    declare $param="true"
  elif [[ $1 == "-docker" ]]; then
    param="is_dockerized"
    declare $param="true"
  elif [[ $1 == "-skipPublish" ]]; then
    param="is_publish"
    declare $param="false"
  elif [[ $1 == "-clearCache" ]]; then
    param="is_clear_cache"
    declare $param="true"
  elif [[ $1 == "?" ]]; then
    export helped=true
    echo "Usage:"
    echo -e "  --module [relative\\path\\\to\\module]\n\t  the path to the module in the modules directory of the language type to be deployed\n\t example: --module simpleApiServer"
    echo -e "  --language [relative\\path\\\to\\\language\\\type]\n\t  the path to the type of language being built, defaults to java.\n\t example: --language java"
    echo -e "  -clean\n\t  clean, defaults to false\n\t clean the build before the build"
    echo -e "  -docker\n\t  use dockerized build, defaults to false (cmd line gradlew build)\n\t dockerized builds may not be supported by all language types."
    echo -e "  -clearCache\n\t  clears all docker image cache before building, this impacts all images not just the module being built."
    echo -e "  -skipPublish\n\t skip publishing image, defaults to false, as in docker image will be built and published. NOTE: a docker image, if available, will always be built, this just skips pushing it to a repo."
    export _requested_help="true"
    exit 0
  else
    export _extra_args=$1
  fi
  shift
done
export module=${module}
export is_dockerized=${is_dockerized}
export is_publish=${is_publish}
export is_clear_cache=${is_clear_cache}
export is_clean=${is_clean}
export _image_name=$(echo $module | tr '[:upper:]' '[:lower:]')
if [ "$is_clear_cache" == "true" ]; then
  echo "clearing all image cache, this impacts all images, not just the one for this module."
  docker system prune --volumes -a -f
fi
echo "building: ${language}/modules/${module}"
./${language}/build.sh "${_extra_args}"