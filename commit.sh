#!/bin/sh

commit_log=$@   # all the args

hexo g

echo
hexo d

echo
git add -A

echo
git commit -m "$commit_log"

echo
git push origin hexo:hexo
