---
title: Python-Cookbook-1.09 简化 translate 方法
date: 2016-05-25 21:46:44
category: Python
tags: [Python, cookbook, closure, factory, string]
---

# string.maketrans

```
Help on built-in function maketrans in module strop:

maketrans(...)
    maketrans(frm, to) -> string

    Return a translation table (a string of 256 bytes long)
    suitable for use in string.translate.  The strings frm and to
    must be of the same length.
(END)
```
生成一个供`string.translate`使用的 ASCII 表，其中`frm`中的所有字符都依序被替换成`to`中字符：

```
>>> maketrans('abc', 'fed')
'\x00\x01\x02\x03\x04\x05\x06\x07\x08\t\n\x0b\x0c\r\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`feddefghijklmnopqrstuvwxyz{|}~\x7f\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff'
>>>
```


# string.translate

```
Help on function translate in module string:

translate(s, table, deletions='')
    translate(s,table [,deletions]) -> string

    Return a copy of the string s, where all characters occurring
    in the optional argument deletions are removed, and the
    remaining characters have been mapped through the given
    translation table, which must be a string of length 256.  The
    deletions argument is not allowed for Unicode strings.
(END)
```
(也可以`s.translate(table, deletions='')`为格式）

以`maketrans`生成的映射表为基准进行字符转换：

```
>>> translate('abcdef', a)
'feddef'
>>> translate('abcdef', a, 'd')
'fedef'
>>> translate('abcdef', a, 'dd')
'fedef'
>>> translate('abcdef', a, 'de')
'fedf'
>>> translate('abcdef', a, 'ade')
'edf'
>>>
```

# 自建一个返回闭包的工厂函数 translator

```python
import string


def translator(frm='', to='', delete='', keep=None):
    if len(to) == 1:
        to = to * len(frm)
    trans = string.maketrans(frm, to)
    if keep is not None:
        allchars = string.maketrans('', '')
        delete = allchars.translate(allchars, keep.translate(allchars, delete))

    def translate(s):
        return s.translate(trans, delete)
        
    return translate


if __name__ == '__main__':
    digits_only = translator(keep=string.digits)
    print digits_only('qwedwefaf24215')

    no_digits = translator(delete=string.digits)
    print no_digits('qwedwefaf24215')
```