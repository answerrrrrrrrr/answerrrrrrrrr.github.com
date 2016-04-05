---
title: Sublime Packages
date: 2016-04-05 16:24:00
category: [Sublime]
tags: [SublimeREPL, ExpandRegion]
---

# [Vintage](https://github.com/sublimehq/Vintage)

这个是Sublime自带的vi模式  
先注释掉`Preferences.sublime-settings`里的`Vintage`

```js Preferences.sublime-settings
...
    "ignored_packages":[
        // "Vintage"
    ],
...
```

再按照习惯把`esc`改成`j` `j`

```js Default (OSX).sublime-keymap
...
// Vintage
    {
        "keys": ["j", "j"],
        "command": "exit_insert_mode",
        "context":[
            {
                "key": "setting.command_mode",
                "operand": false
            },
            {
                "key": "setting.is_widget",
                "operand": false
            }
        ]
    },
...
```
另外还有一个[VintageEx](https://github.com/SublimeText/VintageEx)，不过我倒是没有太大需求


# [SublimeREPL](https://github.com/wuub/SublimeREPL)

无意中发现一个类似 Vim 下 quickrun 的插件`SublimeREPL`

在`Perferences`-`Key Bindings - User`中加入

```js Default (OSX).sublime-keymap
...
    // SublimeREPL - Python
    {
        "keys": ["f2"],
        "caption": "SublimeREPL: Python - RUN current file",
        "command": "run_existing_window_command",
        "args": {
            "id": "repl_python_run",
            "file": "config/Python/Main.sublime-menu",
        }
    },
...
```

这样一来，保存之后按`F2`即可快速运行 Python 脚本，不用来回切换终端了   
C'est bon!

# [ExpandRegion](https://github.com/aronwoost/sublime-expand-region)

在[知乎](https://www.zhihu.com/question/24896283)看到推荐感觉挺不错，用于快速扩展选区，也是在`Perferences`-`Key Bindings - User`中加入

```js Default (OSX).sublime-keymap
...
    {
        "keys": ["super+e"],
        "command": "expand_region"
    },
    {
        "keys": ["super+u"],
        "command": "expand_region",
        "args": {
            "undo": true
        },
        "context": [
            {
                "key": "expand_region_soft_undo"
            }
        ]
    },
...
```