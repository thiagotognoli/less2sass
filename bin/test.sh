#!/bin/bash

#gem install less_to_sass
#sudo npm install -g less@2.7.1

#envPath="$(sourcePath=`readlink -f ${BASH_SOURCE[0]}` && echo "${sourcePath%/*}")"
scriptPath="$(sourcePath=`readlink -f "$0"` && echo "${sourcePath%/*}")"
cd "$scriptPath/.."
bundle exec rspec spec/compare_spec.rb