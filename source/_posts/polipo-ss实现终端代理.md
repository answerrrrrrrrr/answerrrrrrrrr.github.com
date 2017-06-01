---
title: polipo+ss实现 iTerm2 终端科学上网
date: 2017-04-03 15:55:00
category: Mac
tags: 
- proxy
- iTerm
- polipo
- Shadowsocks
- Charles
- 科学上网
---

# polipo

似乎 10.11 引入 SIP 以来 Proxychains 就不能正常工作了, 导致终端代理一直出问题, 今天意外发现 polipo 这个不受 SIP 影响的工具, 尝试了一下果然不错

```
brew install polipo
polipo socksParentProxy=localhost:1086
```

即可实现配合 Shadowsocks(sock5 默认工作在 1086 端口)

为了方便日常切换, 在`.zshrc`中加入

```
#proxy
alias proxy="polipo socksParentProxy=localhost:1086"
export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
pon () {
    export http_proxy="http://127.0.0.1:8123/"
    export https_proxy="http://127.0.0.1:8123/"
    export ftp_proxy="http://127.0.0.1:8123/"
}
poff () {
    unset http_proxy
    unset https_proxy
    unset ftp_proxy
}
# charles proxy
pch () {
    export http_proxy="http://127.0.0.1:8888/"
    export https_proxy="http://127.0.0.1:8888/"
    export ftp_proxy="http://127.0.0.1:8888/"
}
```

以后常驻一个 pane 挂着`proxy`, 然后其他 pane 通过`pon`和`poff`切换即可

# Charles

其中附加的`pch`, 可以实现 Charles 对终端的抓包

如果 Charles 打开 macOS 模式, 同时将 External Proxy 端口设置为 1087(Shadowsocks http/https 代理的默认端口), 可以翻墙的同时进行抓包

需要注意的是, 在没有导入证书的情况下对 HTTPS 抓包会出现失败或是乱码等问题


# 测试

```
> $ pon

> $ curl ip.cn
当前 IP：x.x.x.x 来自：香港特别行政区 xTom

> $ poff

> $ curl ip.cn
当前 IP：x.x.x.x 来自：北京市 电信

> $ pch

> $ curl ip.cn
当前 IP：x.x.x.x 来自：香港特别行政区 xTom

```
![](https://ww1.sinaimg.cn/large/006tNbRwgy1fe9k951wo6j31kw0ydgti.jpg)




