---
title: Permission denied (publickey)
date: 2016-06-16 08:21:06
category: git
tags: [git, github, ssh]
---

今天把学习 flask 的本地库上传到 github 时报错

```
$ git push -u origin master
Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

在 [stackoverflow](http://stackoverflow.com/questions/26953071/github-authentication-failed-github-does-not-provide-shell-access) 找到解决方案

```
git remote set-url origin git@github.com:lut/EvolutionApp.git
git remote show origin
```

简单记录一下...