---
title: keystone
date: 2016-11-30 15:37:27
category: rop
tags: [rop, keystone, capstone, unicorn]
---

Python 的反汇编框架很多，尤其是 capstone 非常好用
但是将常见汇编语句汇编成对应机器码的框架居然一直没找到
难道没有其他懒得记机器码的人了吗╮(╯_╰)╭

今天突然发现 capstone 的作者似乎居然早就听到了我的心声
在上半年就发布了一个汇编框架 [keystone](http://www.keystone-engine.org/)
`pip install keystone-engine` 就可以安装，用法和 capstone 非常相似
甚至连毛病也一样，把动态库放到正确的位置才能正常使用...

```
cp /usr/local/lib/python2.7/site-packages/usr/local/Cellar/python/2.7.12_1/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages/keystone/libkeystone.dylib /usr/local/lib/python2.7/site-packages/keystone/libkeystone.dylib
```

使用起来非常简单

```
#!/usr/bin/python

from __future__ import print_function
from keystone import *


def ks_asm(code, arch=KS_ARCH_X86, mode=KS_MODE_64, syntax=0):
    ks = Ks(arch, mode)
    if syntax != 0:
        ks.syntax = syntax

    encoding, count = ks.asm(code)
    # print(encoding)

    print('{} = '.format(code), end='')
    for i in encoding:
        print('{:02x} '.format(i), end='')


code = 'mov rax, rsp; syscall; nop; pop rbx; ret'
ks_asm(code)
# mov rax, rsp; syscall; nop; pop rbx; ret = 48 89 e0 0f 05 90 5b c3

```

另外官方用例：https://github.com/keystone-engine/keystone/blob/master/bindings/python/sample.py

简直爱死这个作者了 -0-
另外发现他还有一个 CPU emulator 框架 [Unicorn](http://www.unicorn-engine.org/docs/tutorial.html)
有时间了可以学习下


