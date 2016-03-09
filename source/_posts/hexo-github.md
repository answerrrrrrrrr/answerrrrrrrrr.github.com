---
title: hexo github
date: 2016-03-09 19:08:03
tags: [hexo, git, github]
category: hexo
---

# hexo & git

一开始没有搞懂`.deploy_git`和`.git`的区别   
后来发现`hexo deploy`到github上的内容只有纯粹的网页   
才大致明白了hexo的工作流程

首先   
hexo并没有生成页面文件   
项目目录中除了配置文件以外就只有`hex new`出来的一些`.md`而已   
`hexo generate`之后才会在`public`目录下生成一系列html，css等页面文件   

`hexo deploy`之后   
hexo才会将所有页面文件push到项目的`master`分支上   
网站因而得以运作   

但是这样一来   
只有页面文件被放到了远程库   
为了将配置文件和`.md`也放到Github    
可以新建一个`hexo`分支来存放

```
git checkout -b hexo
git push origin hexo:hexo

```
这样一来   
对hexo所做的修改也可以托管在Github上了

以后只需在`hexo g`生成页面后   
先用`hexo d`发布到网站（即`master`分支）上   
然后`git push origin hexo:hexo`备份所有改动到`hexo`分支   

# push conflict

不过在实际的第二次push时   
出现了冲突

```
git push origin hexo:hexo
To git@github.com:answerrrrrrrrr/answerrrrrrrrr.github.com.git
 ! [rejected]        hexo -> hexo (non-fast-forward)
error: failed to push some refs to 'git@github.com:answerrrrrrrrr/answerrrrrrrrr.github.com.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

参考[廖雪峰的文章](http://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000/0013760174128707b935b0be6fc4fc6ace66c4f15618f8d000)得以解决

```
$ git pull
There is no tracking information for the current branch.
Please specify which branch you want to merge with.
See git-pull(1) for details

    git pull <remote> <branch>

If you wish to set tracking information for this branch you can do so with:

    git branch --set-upstream-to=origin/<branch> hexo

$ git branch --set-upstream hexo origin/hexo
The --set-upstream flag is deprecated and will be removed. Consider using --track or --set-upstream-to
Branch hexo set up to track remote branch hexo from origin.

$ git pull
Auto-merging index.html
CONFLICT (add/add): Merge conflict in index.html
Automatic merge failed; fix conflicts and then commit the result.

$ git status
On branch hexo
Your branch and 'origin/hexo' have diverged,
and have 1 and 1 different commit each, respectively.
  (use "git pull" to merge the remote branch into yours)
You have unmerged paths.
  (fix conflicts and run "git commit")

Unmerged paths:
  (use "git add <file>..." to mark resolution)

	both added:      index.html

no changes added to commit (use "git add" and/or "git commit -a")

$ subl index.html
$ git add .
$ git commit -m 'index'
	[hexo b7ed9be] index
$ git push origin hexo:hexo

```