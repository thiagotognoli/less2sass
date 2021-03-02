#!/bin/bash

scriptPath="$(sourcePath=`readlink -f "$0"` && echo "${sourcePath%/*}")"
cd "$scriptPath/.."

[ -e ./data/in ] && rm -rf ./data/in/* ./data/in/.*
mkdir -p ./data/in

cp -R ../adp-next-v0/node_modules/. ./data/in/.