---
title: hexo-rss-sitemap
date: 2016-07-28 10:42:46
category: hexo
tags: [hexo, rss, sitemap]
---

今天突然发现没给博客添加`RSS`订阅和`sitemap`（站点地图，方便搜索引擎的收录）   
尝试了一下发觉还挺方便的   

```
npm install hexo-generator-feed --save
npm install hexo-generator-baidu-sitemap --save
```

这里一定要加上`--save`，否则无法`generate`对应的 xml

然后在根目录的`_config.xml`加入

```xml
# RSS & sitemap
# Extensions
Plugins:
- hexo-generator-feed
- hexo-generator-sitemap

# Feed Atom
feed:
  type: atom
  path: atom.xml
  limit: 20

# sitemap
sitemap:
  path: sitemap.xml
```

然后`hexo g`即可生成对应 xml

> INFO  Start processing   
> INFO  Files loaded in 650 ms   
> INFO  Generated: atom.xml   
> INFO  Generated: sitemap.xml   
> INFO  2 files generated in 2.47 s

这时访问对应路径即可验证，另外边栏也可以看见`RSS`图标了
