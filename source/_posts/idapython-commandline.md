---
title: 命令行调用 idapython 脚本
date: 2016-09-20 10:40:41
category: ida
tags:   [ida, idapython, idc]
---

# 安装
1. 安装 Python 2.7

2. 下载 https://github.com/idapython/bin/raw/master/idapython-6.9.0-python2.7-mac.zip 并解压

3. 将 Python 内的所有内容复制到 IDA 根目录的 Python 内（没有就新建）

4. 将 Plugins 内的所有内容复制到 IDA 根目录的 Plugins 内

5. 将 python.cfg 复制到 IDA 根目录的 cfg 内

6. 重启 IDA，File 菜单下面会有 Python Command 选项，而且 Script files 选项中可以选择 py 文件


python 目录中的四个文件：

- init.py 是初始的基础文件
- idaapi.py 中导入了 _idaapi 模块，这个以下划线开始的 idaapi 模块就是对 IDA API 的低层封装，idaapi.py 则是作为调用 IDA API 的用户层
- idautils.py 提供了一些高级功能的函数
- idc.py 则是对 IDA 内置的 IDC 脚本语言的兼容


# 用法

调用 idapython 脚本时总是要鼠标点来点去很不方便，在官网找了找 

https://www.hex-rays.com/products/ida/support/idadoc/417.shtml

该页面提供了命令行使用 ida 时的可用参数，比较常用的有：

-A 让 ida 自动运行，不需要人工干预。也就是在处理的过程中不会弹出交互窗口，但是如果从来没有使用过 ida 那么许可协议的窗口无论你是否使用这个参数都将会显示。

-c 参数会删除所有与参数中指定的文件相关的数据库，并且生成一个新的数据库。

-S 参数用于指定 ida 在分析完数据之后执行的 idc 脚本，**注意：该选项和参数之间没有空格**，并且搜索目录为 ida 目录下的 idc 目录。

-B 参数指定批量模式，等效于-A –c  –Sanylysis.idc.在分析完成后会自动生成相关的数据库和 asm 代码。并且在最后关闭 ida，以保存新的数据库。

_[这篇文章](http://www.h4ck.org.cn/2012/03/ida-batch-mode/)<sup>2</sup>比较详细地讲解了批量模式的用法_ 

# 实例


```py test.py
from idautils import *
from idaapi import *
import idc

idc.Wait()	# idaapi.autoWait()

ea = BeginEA()
dll_functions = []

fp = open("fun_output.txt", "w")
fp.write("check")
for funcea in Functions(SegStart(ea), SegEnd(ea)):
    functionName = GetFunctionName(funcea)
    dll_functions.append(functionName)
    fp.write(functionName)
    print(functionName)
fp.close()

idc.Exit(0)

```
_其中`idc.Wait()`表示带有`-A`参数时，等待 ida 自动分析过程完成后再运行后续脚本，`idc.Exit(0)`表示脚本运行结束后自动关闭 ida_

不过在实际测试时，`idaq -c -A -Stest.py heap_test`失败且没有任何错误提示，参阅了[Using IDAPython to Make Your Life Easier: Part 6
](http://researchcenter.paloaltonetworks.com/2016/06/unit42-using-idapython-to-make-your-life-easier-part-6/)<sup>3</sup>，脚本和命令都没什么问题，不知是不是因为 Demo 版的缘故。。。

`idaq -c -Stest.py heap_test`倒是一切正常，只好暂且如此了。。。


# 参考

1. http://blog.csdn.net/zhangmiaoping23/article/details/14521995
2. http://www.h4ck.org.cn/2012/03/ida-batch-mode/
3. http://researchcenter.paloaltonetworks.com/2016/06/unit42-using-idapython-to-make-your-life-easier-part-6/