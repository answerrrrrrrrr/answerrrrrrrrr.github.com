---
date: 2016-03-09 15:33:31
title: "10.11 privoxy [Errno 61] Connection refused"
category: Mac
tags: [Privoxy, Shadowsocks, gfw]
---

自从更新10.11以来   
之前用scrapy写的一个小爬虫就用不成了   
总是报错`[Errno 61] Connection refused`   
但是因为不经常用也就没怎么上心   
搜了一下sof   
以为是网站做了防爬虫处理   
但是折腾未果就去忙正经事了   

结果今天挂着代理`pip list --outdated`的时候   
居然报了同样的`[Errno 61] Connection refused`   
才意识到可能是代理的问题

然而Shadowsocks一直使用正常   
那问题就只可能出在Privoxy上了   

果然`lsof -i:8118`之后   
发觉Privoxy居然没有绑在8118端口上   
难怪会「Connection refused」。。。

Google之后   
[这里](http://www.andrewwatters.com/privoxy/)提到更新10.11需要重装Privoxy   
那就重装吧。。。   
在[SourceForge](https://sourceforge.net/projects/ijbswa/files/)下载最新版   
然后按以往一样   
`sudo vim /usr/local/etc/privoxy/config`   
修改如下两行   
`listen-address  127.0.0.1:8118`   
`forward-socks5t   /               127.0.0.1:1080 .`   
再启动Privoxy   
`sudo /Applications/Privoxy/startPrivoxy.sh`   
按以往经验   
这时候应该就可以了   
然而`lsof -i:8118`依然什么也没有   

在[这里](http://1992s.com/blog/share-shadowsocks-over-lan-on-mac-os-x.html)找到问题所在   
启用修改后的配置   
`cd /usr/local/sbin/`
`./privoxy --no-daemon /usr/local/etc/privoxy/config`   

这时候`lsof -i:8118`   
终于见到了久违的Privoxy   
然后爬虫也终于重生啦

另外   
也是在[这里](http://1992s.com/blog/share-shadowsocks-over-lan-on-mac-os-x.html)发现可以用Privoxy来帮手机搭梯子   
算是意外收获了~
























