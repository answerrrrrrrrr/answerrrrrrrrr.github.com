#!/bin/sh

filename=$@
file=./source/_posts/$filename.md


if [ ! -e '$file' ]
then 
    hexo new $filename
fi 

open -a /Applications/MacDown.app $file
