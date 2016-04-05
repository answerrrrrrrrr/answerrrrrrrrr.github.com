---
title: Spider-04-sqlite3
date: 2016-04-05 09:39:06
category: [Python]
tags: [Spider]
---

# 知道创宇爬虫设计第四天：sqlite3

这部分比较简单，需要注意的几点

- connect, cursor
- execute
- commit, rollback
- close


既然之前已经学会了使用logging，就可以尝试下配合着使用

# 代码

```python MySqlite.py
#!/usr/bin/env python
# -*- coding: utf-8 -*-

__author__ = 'Air9'



import sqlite3
import logging
import logging.config
logging.config.fileConfig('logging.conf')


levels = {
            1:'CRITICAL',
            2:'ERROR',
            3:'WARNING',
            4:'INFO',
            5:'DEBUG',
         }
loglevel = 4
logger = logging.getLogger('spider')
logger.setLevel(levels[loglevel])


class MySqlite(object):
    def __init__(self, dbfile):
        try:
            self.conn = sqlite3.connect(dbfile)
            logger.info("Open database %s" % dbfile)
            logger.debug("Open database %s" % dbfile)
        except sqlite3.Error as e:
            # print "Fail to connect %s: %s" % (dbfile, e) # e.args[0]
            logger.error("Fail to connect %s: %s" % (dbfile, e))
            return

        self.cursor = self.conn.cursor()

    def create(self, table):
        try:
            logger.info("Create table %s" % table)
            self.cursor.execute("CREATE TABLE IF NOT EXISTS %s(Id INTEGER PRIMARY KEY AUTOINCREMENT, Data VARCHAR(40))"% table)
            self.conn.commit()
        except sqlite3.Error as e:
            logger.error("Fail to create %s: %s" % (dbfile, e))
            self.conn.rollback()

    def insert(self, table, data):
        try:
            logger.info("Insert %s into table %s" % (data, table))
            self.cursor.execute("INSERT INTO %s(Data) VALUES('%s')" % (table, data))
            self.conn.commit()
        except sqlite3.Error as e:
            logger.error("Fail to insert %s into %s: %s" % (data, table, e))
            self.conn.rollback()

    def close(self):
        logger.info("Close database")
        self.cursor.close()
        self.conn.close()


if __name__ == '__main__':
    ms = MySqlite('spider.db')
    ms.create('t1')
    ms.insert('t1', 'test')
    ms.close()


```
```shell logging.conf
[loggers]
keys = root, spider

[handlers]
keys = consoleHandler

[formatters]
keys = simpleFormatter

[logger_root]
level = DEBUG
handlers = consoleHandler

[logger_spider]
level = DEBUG
handlers = consoleHandler
qualname = spider
propagate = 0

[handler_consoleHandler]
class = StreamHandler
level = DEBUG
formatter = simpleFormatter
args = (sys.stdout,)

[formatter_simpleFormatter]
format = %(asctime)s - %(name)s - %(levelname)s - %(message)s
datefmt = 
```

# 参考

- https://docs.python.org/2/library/sqlite3.html
- http://blog.sina.com.cn/s/blog_72603eac01013pbc.html
- http://blog.csdn.net/jeepxiaozi/article/details/8808435
- http://dongweiming.github.io/blog/archives/pa-chong-lian-xi/