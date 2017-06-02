---
title: Markdown 同步 Evernote
date: 2017-06-01 20:05:09
tags: [markdown, evernote, sublime, vscode]
---


# evernote markdown

用 vim 写 markdown 还是太捉急了: 输入法切换, URL 换行, 列表换行...

另外考虑到同步问题, 把笔记全都放到一个地方还是更便于管理一点, 最终决定是 evernote 了, 有道的 mac 客户端太渣了连个全局搜索的快捷键都没有...

## sublime evernote

参照 [http://www.tuicool.com/articles/MfMZveq](http://www.tuicool.com/articles/MfMZveq) 配置好 sublime evernote 插件, 目前感觉还是挺不错的

遇到了 package control 的同步问题([http://www.jianshu.com/p/a3af44257b15](http://www.jianshu.com/p/a3af44257b15)), 其实 ss 切全局后重启 sublime 就可以了, 以后出问题了记得 cmd + `

本来想试试 cmd markdown 将本地笔记导入 Evernote 的, 结果这是付费功能而且不能批量导入... 还是 sublime 手动导入吧...

### 常用命令

*   ever new
*   ever send
*   ever recent
*   ever open
*   ever update

## vscode evermonkey

vscode 上有两个 evernote 相关的插件, evermonkey 远好于另外一个, 功能更全, 但还是比不上 sublime 的 evernote 插件, 不过也够用了, 另外也好看得多.

### 常用命令

*   ever new
*   ever publish
*   ever recent
*   ever open
*   ever client (用本地客户端打开, 这个很实用的功能是 sublime 没有的)

### 优点

*   Markdown 高亮比 st 好看
*   最后生成的笔记排版也更好看些
*   交互信息更友好

### 缺点

*   一旦保存文件到本地后, publish 附带的 update 功能就会失效, 会变成创建新文件
*   open 后是一个 untitled 文件, 可能会出现莫名其妙的 html 标签
*   不会记忆上一次的命令

# vscode

今天这一折腾, 突然发现 vscode 原来是个非常棒的编辑器. 目前已发现的优点:

*   整体性更强, 没有 st 的分裂感, 扩展和配置的管理比 st 更先进, 注释也非常友好
*   速度略逊于 st, 但远好于 atom 那个渣渣...
*   大部分默认快捷键都近似 st, 基本无缝切换
*   vim 插件居然是官方提供的, 质量远高于 st
*   支持当前工作区设置, 项目目录下单独的配置文件, 十分简便

推荐插件 [https://github.com/varHarrie/Dawn-Blossoms/issues/10](https://github.com/varHarrie/Dawn-Blossoms/issues/10)

## shell
参考 https://stackoverflow.com/questions/30065227/run-open-vscode-from-mac-terminal

`Command + Shift + P` 后 `Shell Command : Install code in PATH`, vscode 就会在 `/usr/local/bin` 加入一个脚本命令, 然后就能在终端直接`code .`了



