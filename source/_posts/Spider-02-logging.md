---
title: Spider-02-logging
date: 2016-04-03 21:42:37
category: [Python]
tags: [Spider]
---

知道创宇爬虫设计第二天：学习logging模块

[此文章](http://blog.chinaunix.net/uid-26000296-id-4372063.html)的测试用例详细实用，对logging模块的解析也很不错，现把自己理解的要点摘录如下

- 只要logging.getLogger(name)中名称参数name相同则返回的Logger实例就是同一个，且仅有一个，也即name与Logger实例一一对应
- 子孙既会将消息分发给他的handler进行处理，也会传递给所有的祖先Logger处理
- 若为Handler加Filter则所有使用了该Handler的Logger都会受到影响。而为Logger添加Filter只会影响到自身
- 典型的多模块场景下使用logging的方式，是在main模块中配置logging，这个配置会作用于其所有子模块
- `logging.config.fileConfig("logging.conf")`

```python logging.conf
# 定义logger模块，root是父类，必需存在的，其它的是自定义。
# logging.getLogger(NAME)便相当于向logging模块注册了一种日志打印
# name 中用 . 表示 log 的继承关系
[loggers]
keys=root,infoLogger,errorLogger
 
# 定义handler
[handlers]
keys=infoHandler,errorHandler
 
# 定义格式化输出
[formatters]
keys=infoFmt,errorFmt
 
#--------------------------------------------------
# 实现上面定义的logger模块，必需是[logger_xxxx]这样的形式
#--------------------------------------------------
# [logger_xxxx] logger_模块名称
# level     级别，级别有DEBUG、INFO、WARNING、ERROR、CRITICAL
# handlers  处理类，可以有多个，用逗号分开
# qualname  logger名称，应用程序通过 logging.getLogger获取。对于不能获取的名称，则记录到root模块。
# propagate 是否继承父类的log信息，0:否 1:是
[logger_root]
level=INFO
handlers=errorHandler
 
[logger_errorLogger]
level=ERROR
handlers=errorHandler
propagate=0
qualname=errorLogger
 
[logger_infoLogger]
level=INFO
handlers=infoHandler
propagate=0
qualname=infoLogger
 
#--------------------------------------------------
# handler
#--------------------------------------------------
# [handler_xxxx]
# class handler类名
# level 日志级别
# formatter，上面定义的formatter
# args handler初始化函数参数
 
[handler_infoHandler]
class=StreamHandler
level=INFO
formatter=infoFmt
args=(sys.stdout,)
 
[handler_errorHandler]
class=logging.handlers.TimedRotatingFileHandler
level=ERROR
formatter=errorFmt
# When computing the next rollover time for the first time (when the handler is created),
# the last modification time of an existing log file, or else the current time,
# is used to compute when the next rotation will occur.
# 这个功能太鸡肋了，是从handler被创建的时间算起，不能按自然时间 rotation 切分，除非程序一直运行，否则这个功能会有问题
# 临时解决方案参考下面的链接：Python 多进程日志记录
# http://blogread.cn/it/article/4175?f=wb2
args=('C:\\Users\\june\\Desktop\\error.log', 'M', 1, 5)
 
#--------------------------------------------------
# 日志格式
#--------------------------------------------------
# %(asctime)s       年-月-日 时-分-秒,毫秒 2013-04-26 20:10:43,745
# %(filename)s      文件名，不含目录
# %(pathname)s      目录名，完整路径
# %(funcName)s      函数名
# %(levelname)s     级别名
# %(lineno)d        行号
# %(module)s        模块名
# %(message)s       消息体
# %(name)s          日志模块名
# %(process)d       进程id
# %(processName)s   进程名
# %(thread)d        线程id
# %(threadName)s    线程名
 
[formatter_infoFmt]
format=%(asctime)s %(levelname)s %(message)s
datefmt=
class=logging.Formatter
 
[formatter_errorFmt]
format=%(asctime)s %(levelname)s %(message)s
datefmt=
class=logging.Formatter
```