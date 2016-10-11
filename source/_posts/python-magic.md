---
title: python-magic has no attribute 'from_file'
date: 2016-10-11 09:32:53
category: Python
tags: [Python, python-magic, mime, apt-get, pip]
---

[python-magic](https://github.com/ahupp/python-magic) 是一个用来判断文件类型的第三方库，效果与 linux 命令`file`类似

使用`pip install python-magic`安装后，在 mac 上还需要`brew install libmagic`，之后即可正常使用

```
>>> import magic
>>> magic.from_file('readme.md')
'ASCII text'
```

不过在 kali rolling 上则会报错

```
>>> import magic
>>> magic.from_file("testdata/test.pdf")
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'module' object has no attribute 'from_file'
```

在 [stackoverflow](http://stackoverflow.com/questions/25286176/how-to-use-python-magic-5-19-1) 中有人提到原因：

python-magic 有多种实现，apt-get 中预装了 5.19.1 版，`import`时优先于刚刚用 pip 安装的版本，使用起来相对复杂一些

```
>>> import magic
>>> m=magic.open(magic.MAGIC_NONE)
>>> m.load()
0
>>> m.file('/etc/passwd')
'ASCII text'
>>> m.file('/usr/share/cups/data/default.pdf')
'PDF document, version 1.5'


>>> m=magic.open(magic.MAGIC_MIME)
>>> m.load()
0
>>> m.file('/etc/passwd')
'text/plain; charset=us-ascii'
>>> m.file('/usr/share/cups/data/default.pdf')
'application/pdf; charset=binary'
```

如果想使用带有`from_file`方法的版本将其替换为 pip 版即可

```
apt-get remove python-magic
pip install python-magic
```


