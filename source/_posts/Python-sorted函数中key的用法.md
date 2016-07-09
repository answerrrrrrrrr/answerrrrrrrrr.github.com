---
title: Python-sorted函数中key的用法
date: 2016-05-19 09:02:08
category: Python
tags: [Python, sorted, key]
---

sorted函数的可用参数如下
> sorted(iterable[, cmp[, key[, reverse]]])

其它几个还好理解，就是`key`的用法经常会忘记，所以记录一下备用

[文档](http://devdocs.io/python~2.7/library/functions#sorted)中说：
> key specifies a function of one argument that is used to extract a comparison key from each list element: key=str.lower. The default value is None (compare the elements directly).

我的理解是   
`key`提供了一个函数，以`iterable`对象中的元素为唯一参数，返回一个与原元素一一对应的 key 值   
然后再对以这些 key 值为元素的`iterable`进行排序   
最后将这些 key 值替换回对应的原元素   
排序完成
   
需要注意的就是`False < True`

然后是实例（参考https://segmentfault.com/q/1010000005111826/a-1020000005112829）



```py
#!/usr/bin/env python
# -*- coding: utf-8 -*-

s = 'aB23'

def sorted_with_key(s, key):
    s = sorted(s, key=key)
    print s
    print 'keys: ',
    print [key(x) for x in s]

print '\nstr.lower'
sorted_with_key(s, str.lower)

print '\nstr.islower'
sorted_with_key(s, str.islower)

print '\nlambda x: x.isdigit() and int(x) % 2 == 0'
sorted_with_key(s, lambda x: x.isdigit() and int(x) % 2 == 0)

print '\nlambda x: x.isdigit(), x.isdigit() and int(x) % 2==0, x.isupper(), x.islower(), x'
# 排序:小写-大写-奇数-偶数
sorted_with_key(s, lambda x: (x.isdigit(), x.isdigit() and int(x) %
                              2 == 0, x.isupper(), x.islower(), x))
```

output

```

str.lower
['2', '3', 'a', 'B']
keys:  ['2', '3', 'a', 'b']

str.islower
['B', '2', '3', 'a']
keys:  [False, False, False, True]

lambda x: x.isdigit() and int(x) % 2 == 0
['a', 'B', '3', '2']
keys:  [False, False, False, True]

lambda x: (x.isdigit(), x.isdigit() and int(x) % 2==0, x.isupper(), x.islower(), x)
['a', 'B', '3', '2']
keys:  [(False, False, False, True, 'a'), (False, False, True, False, 'B'), (True, False, False, False, '3'), (True, True, False, False, '2')]

```


# 2016.7.9 补充

今天看了 cookbook 5.2，Python 2.4 之前是不支持`key`的，书中提供了一个类似的思路，感觉对理解`key`的实现很有帮助，摘录如下：

```
def case_insensitive_sorted(string_list):
    auxiliary_list = [(x.lower(), x) for x in string_list] # decorate
    auxiliary_list.sort()                                  # sort
    return [x[1] for x in auxiliary_list]                  # undecorate
```