---
title: Mac 安装 mongodb
date: 2016-09-22 20:35:03
category: Mac
tags: [Mac, mongodb]
---

Mac 下按照[官网说明](https://docs.mongodb.com/manual/mongo/) 安装 mongodb 并配置好`PATH`后直接`mongo`会报错：

```
$ brew install mongodb
...
$ export PATH=$PATH:/usr/local/Cellar/mongodb/3.2.9/bin
$ mongo
MongoDB shell version: 3.2.9
connecting to: test
2016-09-22T20:15:48.787+0800 W NETWORK  [thread1] Failed to connect to 127.0.0.1:27017, reason: errno:61 Connection refused
2016-09-22T20:15:48.789+0800 E QUERY    [thread1] Error: couldn't connect to server 127.0.0.1:27017, connection attempt failed :
connect@src/mongo/shell/mongo.js:229:14
@(connect):1:6

exception: connect failed
```

好在 [Stackoverflow](http://stackoverflow.com/questions/12831939/couldnt-connect-to-server-127-0-0-127017/17220732#17220732) 一个答案提到，是因为没有启动 mongodb service:

> Did you run mongod before running mongo?

> I followed installation instructions for mongodb from http://docs.mongodb.org/manual/tutorial/install-mongodb-on-os-x/ and I had the same error as you only when I ran mongo before actually running the mongo process with mongod. I thought installing mongodb would also launch it but you need to launch it manually with mongod before you do anything else that needs mongodb.

不过还是报错：

```
$ mongod
2016-09-22T20:28:37.094+0800 I CONTROL  [initandlisten] MongoDB starting : pid=75109 port=27017 dbpath=/data/db 64-bit host=localhost
2016-09-22T20:28:37.095+0800 I CONTROL  [initandlisten] db version v3.2.9
2016-09-22T20:28:37.095+0800 I CONTROL  [initandlisten] git version: 22ec9e93b40c85fc7cae7d56e7d6a02fd811088c
2016-09-22T20:28:37.095+0800 I CONTROL  [initandlisten] OpenSSL version: OpenSSL 1.0.2h  3 May 2016
2016-09-22T20:28:37.095+0800 I CONTROL  [initandlisten] allocator: system
2016-09-22T20:28:37.095+0800 I CONTROL  [initandlisten] modules: none
2016-09-22T20:28:37.095+0800 I CONTROL  [initandlisten] build environment:
2016-09-22T20:28:37.095+0800 I CONTROL  [initandlisten]     distarch: x86_64
2016-09-22T20:28:37.095+0800 I CONTROL  [initandlisten]     target_arch: x86_64
2016-09-22T20:28:37.095+0800 I CONTROL  [initandlisten] options: {}
2016-09-22T20:28:37.097+0800 I -        [initandlisten] Detected data files in /data/db created by the 'mmapv1' storage engine, so setting the active storage engine to 'mmapv1'.
2016-09-22T20:28:37.100+0800 I STORAGE  [initandlisten] exception in initAndListen: 98 Unable to create/open lock file: /data/db/mongod.lock errno:13 Permission denied Is a mongod instance already running?, terminating
2016-09-22T20:28:37.100+0800 I CONTROL  [initandlisten] dbexit:  rc: 100
```

看见`lock file`习惯性想去删掉，结果依然不行

最后还是在 [Stackoverflow](http://stackoverflow.com/questions/15229412/unable-to-create-open-lock-file-data-mongod-lock-errno13-permission-denied/22623543#22623543) 找到解决方法：

```
$ sudo chown -R $USER /data/db
$ mongod
2016-09-22T21:08:07.066+0800 I CONTROL  [initandlisten] MongoDB starting : pid=75729 port=27017 dbpath=/data/db 64-bit host=localhost
2016-09-22T21:08:07.066+0800 I CONTROL  [initandlisten] db version v3.2.9
2016-09-22T21:08:07.066+0800 I CONTROL  [initandlisten] git version: 22ec9e93b40c85fc7cae7d56e7d6a02fd811088c
2016-09-22T21:08:07.066+0800 I CONTROL  [initandlisten] OpenSSL version: OpenSSL 1.0.2h  3 May 2016
2016-09-22T21:08:07.066+0800 I CONTROL  [initandlisten] allocator: system
2016-09-22T21:08:07.066+0800 I CONTROL  [initandlisten] modules: none
2016-09-22T21:08:07.066+0800 I CONTROL  [initandlisten] build environment:
2016-09-22T21:08:07.066+0800 I CONTROL  [initandlisten]     distarch: x86_64
2016-09-22T21:08:07.066+0800 I CONTROL  [initandlisten]     target_arch: x86_64
2016-09-22T21:08:07.067+0800 I CONTROL  [initandlisten] options: {}
2016-09-22T21:08:07.069+0800 I -        [initandlisten] Detected data files in /data/db created by the 'mmapv1' storage engine, so setting the active storage engine to 'mmapv1'.
2016-09-22T21:08:07.096+0800 I JOURNAL  [initandlisten] journal dir=/data/db/journal
2016-09-22T21:08:07.096+0800 I JOURNAL  [initandlisten] recover : no journal files present, no recovery needed
2016-09-22T21:08:07.112+0800 I JOURNAL  [durability] Durability thread started
2016-09-22T21:08:07.112+0800 I JOURNAL  [journal writer] Journal writer thread started
2016-09-22T21:08:07.438+0800 I FTDC     [initandlisten] Initializing full-time diagnostic data capture with directory '/data/db/diagnostic.data'
2016-09-22T21:08:07.438+0800 I NETWORK  [HostnameCanonicalizationWorker] Starting hostname canonicalization worker
2016-09-22T21:08:07.439+0800 I NETWORK  [initandlisten] waiting for connections on port 27017

```

开启`mongod`后再`mongo`就可以了

```
$ mongo
MongoDB shell version: 3.2.9
connecting to: test
>
```

感觉 mongodb 的官方文档有点掉链子啊...