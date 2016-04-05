---
title: Sublime-SublimeREPL
date: 2016-04-05 16:24:00
tags: [SublimeREPL]
category: [Sublime]
---

无意中发现一个类似 Vim 下 quickrun 的插件`SublimeREPL`

在`Perferences`-`Key Bindings - User`中加入

```json Default (OSX).sublime-keymap
...
    // SublimeREPL - python
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