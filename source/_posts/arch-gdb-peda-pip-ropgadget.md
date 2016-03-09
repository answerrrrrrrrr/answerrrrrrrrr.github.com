---
title: arch gdb pip ropgadget
date: 2016-03-09 15:28:36
category: Archlinux
tags: [ROP, Archlinux, gdb, pip]
---

### gdb plugin: [gdb-peda](https://github.com/longld/peda)
`sudo pacman -S gdb`

`git clone https://github.com/longld/peda.git ~/peda`

`echo "source ~/peda/peda.py" >> ~/.gdbinit`


### gdb plugin: [libheap](https://github.com/cloudburst/libheap)
`curl https://raw.githubusercontent.com/answerrrrrrrrr/VRL/master/test/exploits/lib/libheap.py > libheap.py`

`sudo mv libheap.py /usr/lib/python2.7`

`gdb`

`(gdb) python from libheap import *`

`(gdb) heap -h`


### pip
`curl https://bootstrap.pypa.io/get-pip.py > getpip.py`

`sudo python getpip.py`



### ROPgadget

`sudo pacman -S python-capstone`

`sudo pip install ropgadget`

If gets errors about capstone:

`sudo pip install ropgadget --upgrade`
