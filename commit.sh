#!/bin/sh

hexo g

echo
hexo d

echo
git add .

echo
git commit -m 'hexo commit'

echo
git push origin hexo:hexo
