#!/bin/bash

#gem install less_to_sass
#sudo npm install -g less@2.7.1

DATE_INI=$(date '+%Y/%m/%d-%H:%M:%S')

#envPath="$(sourcePath=`readlink -f ${BASH_SOURCE[0]}` && echo "${sourcePath%/*}")"
scriptPath="$(sourcePath=`readlink -f "$0"` && echo "${sourcePath%/*}")"
basePath="$(cd $scriptPath/.. && pwd)"

outDir="$basePath/data/out/all"

[ -e "$outDir" ] && rm -rf "$outDir"
mkdir -p "$outDir"

cd "$basePath/data/in"
export HOME="$basePath/data/in"

while read file; do
    echo $file

    #filename=$(basename -- "$file")
    filename=${file#"./"}
    extension="${filename##*.}"
    filename="${filename%.*}"
    #postcss "$file" --use postcss-less2scss -o "$filename.scss"

    #echo "$filename"
    fileLessPlain=$(echo "$filename.$extension" | tr "/" "_")
    fileScssPlain=$(echo "$filename.scss" | tr "/" "_")

    #echo "$outDir/$fileLessPlain"
    #echo "$outDir/$fileScssPlain"

    cp "$file" "$outDir/$fileLessPlain"
    less2sass "$file" "$outDir/$fileScssPlain"
done < <(find . -name "*.less")