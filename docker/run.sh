#!/bin/bash

scriptPath="$(sourcePath=`readlink -f "$0"` && echo "${sourcePath%/*}")"
basePath="$(cd $scriptPath/.. && pwd)"

cd "$basePath"

. "$basePath/.env"

[ -e "$basePath/data/out" ] && rm -rf "$basePath/data/out"
mkdir -p "$basePath/data/in"
mkdir -p "$basePath/data/out"

docker run \
    --rm \
    -it \
    --name less2sass \
    -v "$basePath/data/in":$WORKDIR/data/in \
    -v "$basePath/data/out":$WORKDIR/data/out \
    less2sass