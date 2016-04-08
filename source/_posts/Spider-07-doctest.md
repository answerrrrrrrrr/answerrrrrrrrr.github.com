---
title: Spider-07-doctest
date: 2016-04-08 11:43:23
category: Python
tags: [Spider]
---

# 知道创宇爬虫设计第七天: doctest

`doctest`是 Python 内建的模块，用于文档测试，正好可以拿来用于爬虫的自测功能

这个模块相对简单，直接贴代码

# 代码

```python
...
def main():
    ''' Prepare and run the spider
    Self-test:
    >>> class Args(object):
    ...     pass
    ...
    >>> args = Args()
    >>> args.url = 'www.baidu.com'
    >>> args.depth = 1
    >>> args.logfile = 'testself.log'
    >>> args.loglevel = 4
    >>> args.dbfile = 'testself.db'
    >>> args.num_threads = 1
    >>> args.key = ''
    >>> set_logger(args.loglevel, args.logfile)
    >>> logger.info(vars(args))
    >>> spider = MySpider(args)
    >>> spider.run()
    '''
...
    # Self test
    if args.testself:
        import doctest
        print doctest.testmod()
        return
...
```
另外其它部分也有少量修改，放在 https://github.com/answerrrrrrrrr/KnownsecSpider

# 参考
- http://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000/0014319170285543a4d04751f8846908770660de849f285000
- http://devdocs.io/python~2.7/library/doctest#doctest.DocTest
- http://devdocs.io/python~2.7/library/argparse#argparse.Namespace