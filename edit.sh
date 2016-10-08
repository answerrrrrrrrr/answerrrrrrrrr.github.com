#!/bin/sh

filename=$@
file=./source/_posts/$filename.md


if [ ! -e "$file" ]   # NOT '$file'
then
    hexo new $filename
fi

open -a /Applications/MWeb.app $file
