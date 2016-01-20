---
layout: post
title: "Mouse scrolling and copy2clipboard in tmux"
description: ""
category: tmux
tags: [tmux, Archlinux]
---
{% include JB/setup %}

[https://wiki.archlinux.org/index.php/Tmux#Mouse_scrolling](https://wiki.archlinux.org/index.php/Tmux#Mouse_scrolling)


###Mouse scrolling

*Note: This interferes with selection buffer copying and pasting. To copy/paste to/from the selection buffer hold the `shift` key.*

If you want to scroll with your mouse wheel, ensure mode-mouse is on in .tmux.conf

	set -g mouse on

You can set scroll History with:

	set -g history-limit 30000

For mouse wheel scrolling as from tmux 2.1 try adding one or both of these to ~/.tmux.conf
	
	bind-key -T root WheelUpPane   if-shell -F -t = "#{alternate_on}" "send-keys -M" "select-pane -t =; copy-mode -e; send-keys -M"   
	bind-key -T root WheelDownPane if-shell -F -t = "#{alternate_on}" "send-keys -M" "select-pane -t =; send-keys -M"


###Copy from tmux to clipboard

Hold the `shift` key to select the text, then copy & paste.