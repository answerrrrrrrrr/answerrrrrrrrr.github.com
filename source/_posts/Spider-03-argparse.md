---
title: Spider-03-argparse
date: 2016-04-04 15:39:12
category: [Python]
tags: [Python, Spider, argparse]
---

# 知道创宇爬虫设计第三天：argparse

题目原本是2012年的，要求的optparse模块已经过时，因此按照argparse来学习

提取要点如下：

- `class argparse.ArgumentParser(prog=None, usage=None, description=None, epilog=None, parents=[], formatter_class=argparse.HelpFormatter, prefix_chars='-', fromfile_prefix_chars=None, argument_default=None, conflict_handler='error', add_help=True)`
- `ArgumentParser.add_argument(name or flags...[, action][, nargs][, const][, default][, type][, choices][, required][, help][, metavar][, dest])`
- ArgumentParser通过parse_args()方法解析参数。它将检查命令行，把每个参数转换成恰当的类型并采取恰当的动作。在大部分情况下，这意味着将从命令行中解析出来的属性建立一个简单的 Namespace对象



# 代码


```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-


import argparse


def parse():
    parser = argparse.ArgumentParser()

    parser.add_argument(
        '-u', '--url', dest='url', required=True,
        help='specify the URL to start crawl'
        )
    parser.add_argument(
        '-d', '--depth', dest='depth',
        default=1, type=int,
        help='specify the depth of the spider (default: 1)'
        )
    parser.add_argument(
        '-f', '--file', dest='logfile',
        default='spider.log',
        help='specify the path of logfile (default: spider.log)'
        )
    parser.add_argument(
        '-l', '--level', dest='loglevel', choices=range(1, 6),
        default=1, type=int,
        help='specify the verbose level of the log (default: 1)'
        )
    parser.add_argument(
        '--dbfile', dest='dbfile',
        default='spider.db',
        help='specify the path of sqlite dbfile (default: spider.db)'
        )
    parser.add_argument(
        '--thread', dest='num_threads',
        default=10, type=int,
        help='specify the size of thread pool (default: 10)'
        )
    parser.add_argument(
        '--keyword', dest='keyword',
        help='specify the keyword'
        )
    parser.add_argument(
        '--selftest', action='store_true',
        help='self-test'
        )

    args = parser.parse_args()
    # > Namespace(
    #     dbfile='spider.db', depth=1, keyword=None,
    #     logfile='spider.log', loglevel=1, num_threads=10,
    #     selftest=False, url='www.baidu.com'
    #     )
    return args


if __name__ == '__main__':
    parse()

```

# 参考

- https://docs.python.org/2/howto/argparse.html
- https://docs.python.org/2/library/argparse.html#choices
- http://python.usyiyi.cn/python_278/library/argparse.html
- http://blog.xiayf.cn/2013/03/30/argparse/