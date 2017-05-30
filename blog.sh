#!/bin/sh

arg=$@
post=$arg.md

cd ~/Documents/GitHub/answerrrrrrrrr.github.com/source/_posts/

if [ ! -e "$post" ]   # NOT '$file'
then
    hexo new $arg
fi

vim $post
