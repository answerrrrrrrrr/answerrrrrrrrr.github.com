#!/bin/sh

commit_log=$@

hexo g

echo
hexo d

echo
git add .

echo
git commit -m $commit_log

echo
git push origin hexo:hexo
