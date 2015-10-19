---
layout: post
title: "Metasploit渗透测试魔鬼训练营"
description: ""
category: [Metasploit]
tags: [Metasploit, Penetration]
---
{% include JB/setup %}



###记录一下学习过程中遇到的问题

* OSX 10.10下配置VMware Fusion虚拟网络环境

	打开`/Library/Preferences/VMware Fusion/networking`

修改对应行

	answer VNET_8_HOSTONLY_SUBNET 10.10.10.0



* 3.5 DB

* 4.2.5 wXf

* 4.3.1 DVWA如何打开
	
	在带有浏览器的测试机打开 http://www.dvssc.com/dvwa (http://10.10.10.129/dvma)
	
	并以`admin` `admin`登陆

* 4.3.2 XSSF配置

	下载[XSSF](https://code.google.com/p/xssf/downloads/list)
	
	合并/XSSF中的data、lib、modules、plugins至

BT5 & Kali: `/opt/metasploit/apps/pro/msf3/`

Kali2: `/usr/share/metasploit-framework/`	



