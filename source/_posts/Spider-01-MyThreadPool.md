---
title: Spider-01-MyThreadPool
date: 2016-04-02 16:08:14
category: [Python]
tags: [Python, Spider, ThreadPool]
---

# 知道创宇爬虫设计第一天：threadpool

题目要求自己实现线程池，研究了好几篇博客之后，大致提取出几个要点：

* 使用默认的`Thread()`创建线程时，通常都是直接绑定一个具体的`func `  
但若使用线程池，初始化的线程数在有些时候可能会多于任务数   
因此，在自定义`MyThread()`时，采用先绑定整个任务队列，然后逐条取出任务`func`执行的方式   
* 使用`MyThreadPool`提前创建所需数目的线程，再分配给具体任务`func`
* 自定义`MyThread()`中需设置`self.daemon = True`，否则完成所有任务后仍不会推出
* `Queue()`提供了两个非常好用的方法
	* `task_done()`一条任务完成时通知整个队列，空闲下来的线程就可以被分配新任务
	* `join()`在所有任务执行完成之前阻塞主线程

# 代码

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-


from threading import Thread
from Queue import Queue


class MyThreadPool(object):
    def __init__(self, num_threads=20):
        self.tasks = Queue(num_threads)
        for _ in xrange(num_threads):
            # Init the pool with the number of num_threads
            MyThread(self.tasks)

    def add_task(self, func, *args, **kwargs):
        self.tasks.put((func, args, kwargs))

    def wait_completion(self):
        # Blocks until all items in the queue have been gotten and processed.
        self.tasks.join()


class MyThread(Thread):
    def __init__(self, tasks):
        Thread.__init__(self)
        self.tasks = tasks
        # This must be set before start() is called. The entire Python program
        # exits when no alive non-daemon threads are left.
        self.daemon = True
        self.start()

    def run(self):
        while True:
            # Block until an item is available.
            func, args, kwargs = self.tasks.get()
            try:
                func(*args, **kwargs)
            except Exception as e:
                print e
            # Tells the queue that the processing on the task is complete.
            self.tasks.task_done()


if __name__ == '__main__':
    ''' test task '''
    from time import sleep

    def nap(sec):
        sleep(sec)
        print 'Had a %ds nap...' % sec

    tp = MyThreadPool(5)
    nap_time = [i for i in xrange(1, 11)]
    for i, t in enumerate(nap_time, 1):
        print 'Worker No.%d needs a %ds nap.' % (i, t)
        tp.add_task(nap, t)

    tp.wait_completion()

```


# 参考
1. [python线程池](http://www.the5fire.com/python-thread-pool.html)   
2. [【Howie玩python】-多线程从0到1到澡堂子洗澡](http://github.howie.wang/2016/01/07/python-threading/)
