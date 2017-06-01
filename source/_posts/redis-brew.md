---
title: Mac 下使用 homebrew 安装 redis
date: 2016-09-12 11:44:37
category: Mac
tags: [redis, brew, Mac]
---

```
$ brew install redis
==> Downloading https://homebrew.bintray.com/bottles/redis-3.2.3.el_capitan.bottle.tar.gz
######################################################################## 100.0%
==> Pouring redis-3.2.3.el_capitan.bottle.tar.gz
==> Caveats
To have launchd start redis now and restart at login:
  brew services start redis
Or, if you don't want/need a background service you can just run:
  redis-server /usr/local/etc/redis.conf
==> Summary
🍺  /usr/local/Cellar/redis/3.2.3: 10 files, 1.7M
```
这样就安装好了，很是方便   
不过暂时有一个问题：每次都要手动打开`redis-server`后才能`redis-cli`，否则提示`not connected`   


```
$ redis-cli
Could not connect to Redis at 127.0.0.1:6379: Connection refused
Could not connect to Redis at 127.0.0.1:6379: Connection refused
not connected>
```

其实`brew`很贴心，之前安装完已经提醒过可以`brew services start redis`来自动启动，另外还可以使用`brew info`来看看提示信息

```
...
$ brew info redis
redis: stable 3.2.3 (bottled), HEAD
Persistent key-value database, with built-in net interface
http://redis.io/
/usr/local/Cellar/redis/3.2.3 (10 files, 1.7M) *
  Poured from bottle on 2016-09-18 at 09:51:13
From: https://github.com/Homebrew/homebrew-core/blob/master/Formula/redis.rb
==> Options
--with-jemalloc
	Select jemalloc as memory allocator when building Redis
--HEAD
	Install HEAD version
==> Caveats
To have launchd start redis now and restart at login:
  brew services start redis
Or, if you don't want/need a background service you can just run:
  redis-server /usr/local/etc/redis.conf
$ brew services start redis
==> Tapping homebrew/services
Cloning into '/usr/local/Library/Taps/homebrew/homebrew-services'...
remote: Counting objects: 7, done.
remote: Compressing objects: 100% (6/6), done.
remote: Total 7 (delta 0), reused 3 (delta 0), pack-reused 0
Unpacking objects: 100% (7/7), done.
Checking connectivity... done.
Tapped 0 formulae (32 files, 46.3K)
==> Successfully started `redis` (label: homebrew.mxcl.redis)
$ redis-cli
127.0.0.1:6379>
```

这样就可以了