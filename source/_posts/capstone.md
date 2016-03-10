---
title: ropgadget capstone 
date: 2016-03-10 15:41:52
tags: [ropgadget, capstone]
category: rop
---

# import error
capstone是一个著名的反汇编框架   
ropgadget会用到

不知道是作者偷懒还是什么情况   
每次`pip install ropgadget`之后都会报错
`import error:ERROR: fail to load the dynamic library.`

原因在于所需的动态库文件libcapstone.dylib没有位于capstone主目录   
所以找到libcapstone.dylib并拷贝一个就可以了

有两种方法
## sudo find / -name 'libcapstone.*'
原来作者把动态库写在了这么一个奇葩的地址
`/usr/local/lib/python2.7/site-packages/usr/local/Cellar/python/2.7.11/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages/capstone/libcapstone.dylib`
大概是写掉了一个`/`吧

## pip uninstall capstone
这个方法略显鸡贼，但更快一点      
可以发现列出了所有与capstone相关的文件   
其中最后一个就是要找的libcapstone.dylib


# then
```
$ cp /usr/local/lib/python2.7/site-packages/usr/local/Cellar/python/2.7.11/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages/capstone/libcapstone.dylib /usr/local/lib/python2.7/site-packages/capstone/libcapstone.dylib
$ ropgadget
Need a binary filename (--binary/--console or --help)

```

已经可以正常使用了



# 补充
在kali rolling里试了一下   
第二种方法行不通   
只能用find   
可以找到一个`/usr/lib/libcapstone.so.3`   
然后
`cp /usr/lib/libcapstone.so.3 /usr/local/lib/python2.7/dist-packages/capst│                                                                             
one/libcapstone.dylib`
解决










