---
title: SohuSpider
date: 2016-04-13 15:55:31
category: Python
tags: [Python, sohu, Spider]
---

# 题目

>请设计一个系统，自动完成对于手机搜狐(http://m.sohu.com/ )系统可靠性的检测。具体要求：  
>1. 定时递归检测所有m.sohu.com域名的页面以及这些页面上的链接的可达性，即有没有出现不可访问情况。  
>2. m.sohu.com域名页面很多，从各个方面考虑性能优化。  
>3. 对于错误的链接记录到日志中，日志包括：连接，时间，错误状态等。  
>4. 考虑多线程的方式实现  

>要求：用Python实现，不使用爬取框架，一周内回复。

# 过程

因为之前才刚刚写了一个爬虫，本以为里面的线程池拿来就能用   
结果昨天晚上大致改了个雏形出来，发觉爬到5分钟必定卡死，改了一晚上都没有解决   
一怒之下 Google 了一记。。。   
搜出来两位可能是去年实习的仁兄的答案，其中一位也是用的线程池，才意识到问题应该不在这里   
抬头一看12点了，还突然停水不能洗脚。。。草草刷个牙郁闷地滚去睡了

今天学习了一下二位前辈的代码，彻底重写了一个，还是卡在5分钟，实在莫名其妙   
Google 百度 各种改来改去无果，差点绝望了   

后来想到，没头绪的缘由还是因为卡住的时候连个报错都没有，没有好的切入点   
那我就多加点 logger 好了

这才发现，5分钟的时候提取 URL 会出现大片的`None`，在这之前有个链接是 http://m.sohu.com/f/521204/?_once_=000067_ayy    
手动打开的话会弹窗下载 搜狐新闻 apk   
难道是因为这个原因导致 BeautifulSoup 提取不出来 href 了？

另外有个意外发现。。。   
这回看见卡住了之后没有急着顺手 kill 掉   
结果居然等了几分钟就好了。。。跑得那叫一个顺畅。。。   
我也不知道这算什么情况了。。。   

把 crontab 的自动定时加上，这样大致算是完成了吧   
明天再看看能做什么调整

还有论文没看呢。。。

# 代码

https://github.com/answerrrrrrrrr/SohuSpider/blob/master/SohuSpider.py

# 参考

- https://github.com/zhangity/sohu_crawled/blob/master/sohu1-5.py
- https://github.com/lan2720/deadurl_detector/blob/master/crawl.py#L2
- http://honglu.me/2014/09/20/OSX%E7%B3%BB%E7%BB%9F%E6%B7%BB%E5%8A%A0%E5%AE%9A%E6%97%B6%E4%BB%BB%E5%8A%A1/