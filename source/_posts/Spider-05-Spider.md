---
title: Spider-05-Spider
date: 2016-04-06 09:00:36
category: Python
tags: [Python, Spider]
---

# 知道创宇爬虫设计第五天：Spider

 准备工作完成的差不多了，今天尝试下把之前的模块都整合起来做一个初期版本
 
 首先 [What is the difference between web-crawling and web-scraping?](http://stackoverflow.com/questions/4327392/what-is-the-difference-between-web-crawling-and-web-scraping)   
感觉其实这个答案比最佳答案更简洁明了  

> Web Crawling is what Google does - it goes around a website looking at links and building a database of the layout of that site and sites it links to

> Web Scraping would be the progamatic analysis of a web page to load some data off of it, EG loading up BBC weather and ripping (scraping) the weather forcast off of it and placing it elsewhere or using it in another program.

我的理解就是`web-crawling`在于广度，`web-scraping`在于精度

# BeautifulSoup

为了`crawl`，需要从页面提取出用于进一步爬取的 URL ，BeautifulSoup 正好能方便快捷地完成这个任务，上手也很简单，基本上看看[官方文档](http://beautifulsoup.readthedocs.org/zh_CN/latest/)就万事大吉了

# FileHandler

在整合 logger 的时候发现一个问题，使用`logging.config.fileConfig('logging.conf')
`的话，需要提前在配置文件里写定日志保存路径，为了配合参数设定其他路径，似乎（看了一下 [FileHandler](http://devdocs.io/python~2.7/library/logging.handlers#logging.FileHandler) 的用法）只能额外添加一个了

```
...
    # If logfile is not 'spider.log'
    formatter = logging.Formatter(
        '%(asctime)s - %(levelname)s - %(message)s')
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
...
```

# 代码

目前爬虫已经基本能用，但偶尔还是会出现`502`，然后该往数据库里放些什么东西还有待考虑，另外也没有加上自测功能

```python myspider.py
#!/usr/bin/env python
# -*- coding: utf-8 -*-

from threading import Thread
from Queue import Queue
from bs4 import BeautifulSoup
import urllib2
import argparse
import sqlite3
import logging
import logging.config


logging.config.fileConfig('logging.conf')
logger = logging.getLogger('spider')

levels = {
    1: 'CRITICAL',
    2: 'ERROR',
    3: 'WARNING',
    4: 'INFO',
    5: 'DEBUG',
}


class MySqlite(object):
    def __init__(self, dbfile):
        try:
            logger.warning("Open database %s" % dbfile)
            self.conn = sqlite3.connect(dbfile)
        except sqlite3.Error as e:
            # print "Fail to connect %s: %s" % (dbfile, e) # e.args[0]
            logger.error("Fail to connect %s: %s" % (dbfile, e))
            return

        self.cursor = self.conn.cursor()

    def create(self, table):
        try:
            logger.warning("Create table %s if not exists" % table)
            self.cursor.execute(
                "CREATE TABLE IF NOT EXISTS %s (id INTEGER PRIMARY KEY \
                AUTOINCREMENT, url VARCHAR(100), data VARCHAR(40))" % table)
            self.conn.commit()
        except sqlite3.Error as e:
            logger.error("Fail to create %s: %s" % (table, e))
            self.conn.rollback()

    def insert(self, table, url, data):
        try:
            logger.warning(
                "Insert (%s, %s) into table %s" % (url, data, table))
            self.cursor.execute(
                "INSERT INTO %s (url, data) VALUES ('%s', '%s')" %
                (table, url, data))
            self.conn.commit()
        except sqlite3.Error as e:
            logger.error(
                "Fail to insert (%s, %s) into %s: %s" %
                (url, data, table, e))
            self.conn.rollback()

    def close(self):
        logger.info("Close database")
        self.cursor.close()
        self.conn.close()


class MyThreadPool(object):
    def __init__(self, num_threads=10):
        self.tasks = Queue(num_threads)
        for i in xrange(1, num_threads+1):
            # Initialize the pool with the number of num_threads
            logger.info('Initialize thread %d' % i)
            MyThread(self.tasks)

    def add_task(self, func, *args, **kwargs):
        self.tasks.put((func, args, kwargs))
        logger.debug('Add task')

    def wait_completion(self):
        # Blocks until all items in the queue have been gotten and processed.
        self.tasks.join()
        logger.info('All tasks are done')


class MyThread(Thread):
    def __init__(self, tasks):
        Thread.__init__(self)
        self.tasks = tasks
        # This must be set before start() is called. The entire Python program
        # exits when no alive non-daemon threads are left.
        self.daemon = True
        self.start()
        logger.debug('Thread started...')

    def run(self):
        while True:
            # Block until an item is available.
            func, args, kwargs = self.tasks.get()
            try:
                logger.warning('Thread is working...')
                func(*args, **kwargs)
            except Exception as e:
                logger.error(e)
            # Tells the queue that the processing on the task is complete.
            self.tasks.task_done()


class MySpider(object):
    def __init__(self, args):
        ''' Initialize the spider
        '''
        # Initialize args
        self.url = args.url
        self.depth = args.depth
        self.logfile = args.logfile
        self.dbfile = args.dbfile
        self.num_threads = args.num_threads
        self.key = args.key.lower()
        self.selftest = args.selftest

        # Store visited url
        self.visited_urls = set()

        # Initialize threadpool
        self.threadpool = MyThreadPool(self.num_threads)

    def run(self):
        ''' Run the spider
        '''
        if not self.url.startswith('http://'):
            self.url = 'http://' + self.url
        logger.critical('Start crawl on %s' % self.url)
        self.threadpool.add_task(self.scrape, self.url, self.depth)
        self.threadpool.wait_completion()

    def scrape(self, url, depth):
        ''' Scrape the content of page
        '''
        # Open database with dbfile
        db = MySqlite(self.dbfile)
        # Create table with keyword
        table = 'none' if not self.key else self.key
        db.create(table)

        # Avoid being recognized as robot
        headers = {
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) \
            AppleWebKit/537.36 (KHTML, like Gecko) \
            Chrome/49.0.2623.110 Safari/537.36'
        }

        # Avoid repeat
        if url in self.visited_urls:
            logger.debug('%s had been crawled' % url)
            return
        else:
            self.visited_urls.add(url)
            logger.info('Crawling on %s' % url)

        # Request with headers
        try:
            logger.warning('Open %s' % url)
            request = urllib2.Request(url, headers=headers)
            result = urllib2.urlopen(request).read()
        except ValueError as e:
            logger.error(e)
            return

        # Extract the title by BeautifulSoup
        soup = BeautifulSoup(result, "lxml")
        title = soup.title.string
        logger.debug('title = %s' % title)

        # Store url and title of the page with keyword into database
        if self.key in result.lower():
            table = 'none' if not self.key else self.key
            db.insert(table, url, title)
            logger.critical(
                'KEYWORD:\'%s\' - URL:\'%s\' - TITLE:\'%s\' (DEPTH:%d)' %
                (self.key, url, title, depth))

        # Close database after modification
        db.close()

        # Go deeper into urls in result
        self.crawl(soup, depth-1)

    def crawl(self, soup, depth):
        ''' Crawl to new pages
        '''
        if depth > 0:
            for link in soup.find_all('a'):
                url = link.get('href')
                # scrape new url
                self.threadpool.add_task(self.scrape, url, depth)

    # def stop(self):
    #     ''' Stop the spider
    #     '''
    #     logger.critical('OVER')


def args_parser():
    ''' Parse the args
    '''
    parser = argparse.ArgumentParser()

    parser.add_argument(
        '-u', '--url', dest='url', required=True,
        help='specify the URL to start crawl'
    )
    parser.add_argument(
        '-d', '--depth', dest='depth', default=1, type=int,
        help='specify the depth of the spider (default: 1)'
    )
    parser.add_argument(
        '-f', '--file', dest='logfile', default='spider.log',
        help='specify the path of logfile (default: spider.log)'
    )
    parser.add_argument(
        '-l', '--level', dest='loglevel', default=5, type=int,
        choices=range(1, 6),
        help='specify the verbose level of the log (default: 5)'
    )
    parser.add_argument(
        '--dbfile', dest='dbfile', default='spider.db',
        help='specify the path of sqlite dbfile (default: spider.db)'
    )
    parser.add_argument(
        '--thread', dest='num_threads', default=10, type=int,
        help='specify the size of thread pool (default: 10)'
    )
    parser.add_argument(
        '--key', dest='key', default='',
        help='specify the keyword (default: '')'
    )
    parser.add_argument(
        '--selftest', action='store_true',
        help='self-test'
    )

    args = parser.parse_args()
    return args


def set_logger(loglevel, logfile):
    ''' Set the logger with loglevel and logfile
    '''
    logger.setLevel(levels[loglevel])
    file_handler = logging.FileHandler(logfile)

    # If logfile is not 'spider.log'
    formatter = logging.Formatter(
        '%(asctime)s - %(levelname)s - %(message)s')
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)


def main():
    args = args_parser()
    set_logger(args.loglevel, args.logfile)
    logger.debug(args)

    spider = MySpider(args)
    spider.run()


if __name__ == '__main__':
    main()
```

# 参考

- http://beautifulsoup.readthedocs.org/zh_CN/latest/
- http://devdocs.io/python~2.7/library/logging.handlers#logging.FileHandler
- http://dongweiming.github.io/blog/archives/pa-chong-lian-xi/

