---
title: Spider-06-requests
date: 2016-04-07 19:53:43
category: Python
tags: [Python, Spider, requests]
---

# 知道创宇爬虫设计第六天：requests

从实验室回学校之后，仅仅是换了个网络，却突然出现了乱码问题

折腾了半天编码无果，无意中发现把`urllib2`换成`requests`就好了   
按照`requests`[官方文档](http://www.python-requests.org/en/master/user/quickstart/)里的解释

>When you make a request, Requests makes educated guesses about the encoding of the response based on the HTTP headers. The text encoding guessed by Requests is used when you access r.text.

难怪总在知乎看见人安利，确实是更好用一些啊。。。

具体用法也很简单方便   
不过使用`request.text`返回结果时，标题依然会乱码

>You can also access the response body as bytes, for non-text requests

改成使用`request.content`，果然一切正常了

# 代码

```python 
...
            # request = urllib2.Request(url, headers=headers)
            # result = urllib2.urlopen(request).read()

            request = requests.get(url, headers=headers)
            # result = request.text
            result = request.content
...
```

# 参考
- http://www.python-requests.org/en/master/
- http://www.python-requests.org/en/master/user/quickstart/
- http://blog.csdn.net/alpha5/article/details/24964009
