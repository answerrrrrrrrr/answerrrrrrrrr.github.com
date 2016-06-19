---
title: Sublime Preferences
date: 2016-04-05 16:24:00
category: [Sublime]
tags: [SublimeREPL, ExpandRegion, Anaconda, MarkdownEditing]
---

# 切换标签页
首先，Sublime 的所谓「标签页智能切换」很蛋疼，改成通用快捷键设定

```js Default (OSX).sublime-keymap
    {
        "keys": ["ctrl+tab"],
        "command": "next_view"
    },
    {
        "keys": ["ctrl+shift+tab"],
        "command": "prev_view"
    },
```


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

# [Anaconda](https://github.com/DamnWidget/anaconda)

这个插件确实强大，不过有点小问题

## import 时不能自动补全
在[Stackoverflow](https://github.com/DamnWidget/anaconda/issues/89)找到解决方案   
新建`/Users/air9/Library/Application\ Support/Sublime\ Text\ 3/Packages/Python/Completion\ Rules.tmPreferences`并加入如下内容

```xml Completion Rules.tmPreferences
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>scope</key>
    <string>source.python</string>
    <key>settings</key>
    <dict>
        <key>cancelCompletion</key>
        <string>^(.*\b(and|or)$)|(\s*(pass|return|and|or|(class|def)\s*[a-zA-Z_0-9]+)$)</string>
    </dict>
</dict>
</plist>
```

保存后重启 Sublime 即可

**不过第一次弄的时候，不知道怎么回事出现了配置文件被初始化的 bug，所有插件和改键都失效了。。。还好我碰巧刚刚做了备份，所以下次也要记得先备份一下**

## 过于频繁的补全弹窗
随便按一个空格就以`a`开头弹窗提示我补全，有时甚至回车补全完成之后弹窗仍然消失不掉，一怒之下禁用掉了

```js Anaconda.sublime-settings
...
    /*
        Disable anaconda completion

        WARNING: set this as true will totally disable anaconda completion
    */
    // "disable_anaconda_completion": false,
    "disable_anaconda_completion": true,

    /*
...
```

Sublime 自带的轻量级补全其实已经满足我的日常需求了，装 Anaconda 主要还是为了 Tooltip 和 PEP8 提示

# [MarkdownEditing](https://github.com/SublimeText-Markdown/MarkdownEditing)

这个其实用处不大，平常在 Mac 上写 Markdown 都用的 MacDown   
不过默认会渲染 txt 还是挺蛋疼的，注释掉   
顺便改个主题

```js Markdown.sublime-settings
{
    "extensions":
    [
        "md",
        "mdown",
        // "txt"
    ],

    "color_scheme": "Packages/MarkdownEditing/MarkdownEditor-Dark.tmTheme",
}
```