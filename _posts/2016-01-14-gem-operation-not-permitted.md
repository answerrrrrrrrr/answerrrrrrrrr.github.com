---
layout: post
title: "GEM: Operation not permitted (10.11)"
description: "Mac"
category: 
tags: [gem, ruby]
---
{% include JB/setup %}


###ERROR:  While executing gem ... (Errno::EPERM)
###Operation not permitted - /usr/bin/xcodeproj

http://blog.csdn.net/youtk21ai/article/details/48896043

`mkdir -p $HOME/.gem/air9_gem_ruby`

`export GEM_HOME=$HOME/.gem/air9_gem_ruby`

`gem install cocoapods`

`export PATH=$PATH:$HOME/.gem/air9_gem_ruby`
