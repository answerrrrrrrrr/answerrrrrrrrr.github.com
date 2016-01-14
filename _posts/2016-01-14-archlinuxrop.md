---
layout: post
title: "Setup ROP test environment on Archlinux"
description: ""
category: ROP
tags: [ROP, Archlinux]
---
{% include JB/setup %}

### gdb-peda
`sudo pacman -S gdb`

`git clone https://github.com/longld/peda.git ~/peda`

`echo "source ~/peda/peda.py" >> ~/.gdbinit`



### pip
`curl https://bootstrap.pypa.io/get-pip.py > getpip.py`

`sudo python getpip.py`



### ROPgadget

`sudo pacman -S python-capstone`

`sudo pip install ropgadget`