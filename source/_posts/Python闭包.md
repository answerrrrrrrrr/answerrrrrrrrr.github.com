---
title: Python 中的闭包与装饰器
date: 2016-07-25 10:18:09
category: Python
tags: [Python, Closure, Decorator, func_defaults]
---

# Closure(闭包)

什么是闭包?简单说,闭包就是根据不同的配置信息得到不同的结果。

专业的解释:闭包（Closure）是词法闭包（Lexical Closure）的简称，是引用了自由变量的函数。这个被引用的自由变量将和这个函数一同存在，即使已经离开了创造它的环境也不例外。所以，有另一种说法认为闭包是由函数和与其相关的引用环境组合而成的实体。

概念总是有点抽象，下面结合示例说下我自己的理解。

## 特点

- 外部函数包裹内部函数
- 外部函数最终返回一个函数对象，即一个内部函数实例
- 外部函数传入的参数不同时，会返回不同的内部函数实例
- 外部函数用于`绑定`，内部函数用于`处理`
- 外部函数绑定的参数为`函数`时，即为`装饰器`

## 示例

```py
def plus(augend):
    print 'augend:', augend

    def plus_inside(addend):
        print 'addend:', addend
        result = augend + addend
        print 'result:', result
        return result

    return plus_inside

p20 = plus(20)
# -> augend: 20
# 只打印 augend 说明内部处理函数尚未执行
# 只是完成了将 augend 与处理函数绑定的操作

p20(1)
# -> addend: 1
# -> result: 21
```

# Decorator(装饰器)

前面已经提到，装饰器本质就是外部函数绑定参数为函数的闭包。

另外 Python 给它添加了一个更优雅的调用方式，用在被绑定函数`f`之前添加`@wrapper`的方式，代替在被绑定函数`f`定义后使用`f = wrapper(f)`手动赋值的方式，来进行绑定。

## 示例
```py
def makebold(fn):
    def wrapped():
        return "<b>" + fn() + "</b>"
    return wrapped

def makeitalic(fn):
    def wrapped():
        return "<i>" + fn() + "</i>"
    return wrapped

@makebold
@makeitalic
def hello():
    return "hello world"

print hello() 
# -> <b><i>hello world</i></b>
# 注意<b>和<i>的顺序
```

## 保持函数默认参数常新的装饰器

Cookbook 20.1 里有个特别的例子。

Python 里函数的默认参数只在函数定义时求值一次，然后存入函数内建的 func_defaults 元组内。如果是不可变参数（如 1、'qwe'、None 等），完全没有问题；但如果是类似列表这样的可变参数，重新调用函数时默认的列表可能已经面目全非。

书中提供了两种解决该问题的方法：

### 标准方法
```py
def packitem(item, pkg=None):
    if pkg is None:
        pkg = []
    pkg.append(item)
    return pkg
```

### 装饰器方法
```py
import copy
def freshdefaults(f):
    "a decorator to wrap f and keep its default values fresh between calls"
    fdefaults = f.func_defaults
    def refresher(*args, **kwds):
        f.func_defaults = deepcopy(fdefaults)
        return f(*args, **kwds)
        
    # 用于在 print 时区别不同的被绑定函数，2.4 后有效，见 Cookbook 20.1 
    refresher.__name__ = f.__name__
    
    return refresher

# usage as a decorator, in python 2.4:
@freshdefaults
def packitem(item, pkg=[]):
    pkg.append(item)
    return pkg
# usage in python 2.3: after the function definition, explicitly assign:
# f = freshdefaults(f)
```

### Ref.

- http://www.cnblogs.com/ma6174/archive/2013/04/15/3022548.html
- Cookbook 20.1


