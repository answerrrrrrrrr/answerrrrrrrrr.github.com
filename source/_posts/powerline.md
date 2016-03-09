---
title: "iTerm下配置Powerline"
date: 2016-03-09 15:06:29
category: [Mac]
tags: [Powerline, iTerm]
---


# Powerline

今天指压师折腾powerline的时候也卡住了，帮他搞定之后，不禁想起以前我折腾这个的时候，网上各种教程都莫名其妙忽略了最关键的iTerm调字体部分，干脆把自己当时写的一篇笔记改一改发blog算了

<img src="https://raw.githubusercontent.com/answerrrrrrrrr/Res/master/Blog/2015-10-03-powerline/powerline.png" width="100%" height="100%">


## For zsh

* 手动下载 [powerline](https://github.com/powerline/powerline)并解压到主目录
	
	或者 
	
	$ `git clone https://github.com/powerline/powerline`			

* $ `vim ~/.zshrc`
  
在zsh配置文件里加入一行:  

	. ~/powerline-develop/powerline/bindings/zsh/powerline.zsh
		

然后启用新配置：
	
$ `source ~/.zshrc`

* 手动下载 [powerline fonts](https://github.com/powerline/fonts)
	
	或者
	
	$ `git clone https://github.com/powerline/fonts`
	
* 然后安装：

	$ `cd fonts`
	
	$ `./install.sh`

* 打开 `iTerm` - `Preferences` - `Profiles` - `Text`  

	将 `Regular Font` & `Non-ASCII Font` 都改为带有 `for Powerline`后缀的字体
	
	我感觉看着比较舒服的是`Source Code Pro for Powerline`
	
	选好的瞬间，iTerm里面的预览效果应该就已经出来了
	
	稍微有点蛋疼的是，iTerm调了透明的时候，箭头符号却不会跟着透明，看着不太顺眼
	
## For vim
$ `vim ~/.vimrc`

加入:

		set rtp+=~/powerline-develop/powerline/bindings/vim
		set guifont=Monaco\ for\ Powerline:h14.5
		set laststatus=2
		let g:Powerline_symbols = 'fancy'
		set encoding=utf-8
		set t_Co=256
		set number
		set fillchars+=stl:\ ,stlnc:\
		set term=xterm-256color
		set termencoding=utf-8
		syntax enable
		set background=light	
		
