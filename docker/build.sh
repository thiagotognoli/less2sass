#!/bin/bash

scriptPath="$(sourcePath=`readlink -f "$0"` && echo "${sourcePath%/*}")"
basePath="$(cd $scriptPath/.. && pwd)"
. "$basePath/.env"

cd "$basePath"

docker build \
    --build-arg ARG_WORKDIR="$WORKDIR" \
    --build-arg BA_UID="$(id -u)" \
    --build-arg BA_GID="$(id -g)" \
    --build-arg BA_USER_NAME="less2sass" \
    -t less2sass .