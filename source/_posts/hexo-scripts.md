---
title: hexo-scripts
date: 2016-03-09 21:00:31
tags: [hexo, git, sh]
category: scripts
---

偷师自[http://www.xuxu1988.com/2015/05/16/config-my-hexo/](http://www.xuxu1988.com/2015/05/16/config-my-hexo/)

# ./commit.sh COMMIT_LOG
```sh
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

```

# ./edit.sh FILENAME
```sh
#!/bin/sh

filename=$@
file=./source/_posts/$filename.md


if [ ! -e '$file' ]
then 
    hexo new $filename
fi 

open -a /Applications/MacDown.app $file

```