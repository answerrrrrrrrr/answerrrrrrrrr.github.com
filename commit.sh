#!/bin/sh

hexo g

hexo d

git add .

git commit -m 'hexo commit'

git push origin hexo:hexo
