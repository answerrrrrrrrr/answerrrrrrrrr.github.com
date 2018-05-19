---
title: 树莓派初体验
date: 2018-05-19 22:37:06
category: raspi
tags: [raspi]
---

树莓派

都不清楚自己为啥好像一直很忙的样子, 买来树莓派吃灰了快一年, 今天终于有闲心再好好折腾下了


首先是装系统, 按着这里 http://www.ruanyifeng.com/blog/2017/06/raspberry-pi-tutorial.html 的步骤
* 下载 NOOBS。
* 在 mac 磁盘工具格式化 Micro SD 卡为 FAT 格式（操作指导）。
* 解压 NOOBS.zip 到 Micro SD 卡根目录。
* 插入 Micro SD 卡到树莓派底部的卡槽，接通电源，启动系统。
插上鼠标点击安装, 等个十来分钟就好, 然后把 ssh 打开, 密码改一下(顺便把 root 也改了)


之前可能是没找对小触屏的驱动, 本来好好的系统一装完这个就挂了
今天好好看了下壳子上的版本号: KeDei 3.5 inch SPI TFTLCD version 6.3, 才发现官网其实很好找(只要用的是Google而不是百度...)
http://www.kedei.net/raspberry/raspberry.html
v6.3 用的应该就是这个驱动 http://www.kedei.net/raspberry/v6_1/LCD_show_v6_1_3.tar.gz


不过保险起见, 先备份一下系统吧
shutdown 后拔下 SD 卡, 插回 mac 可以看到自动挂载了 /boot 和 /recover 分区, 但其实还有两个分区, 打开磁盘工具可以看到
mount 看一下 /boot 和 /recover 是什么盘符:
/dev/disk3s6                           68Mi   23Mi   45Mi    34%       0          0  100%   /Volumes/boot
/dev/disk3s1                          1.8Gi  1.7Gi   90Mi    96%       0          0  100%   /Volumes/RECOVERY

所以把整个 disk3 备份一下就可以了
sudo dd if=/dev/disk3 of=/Users/air9/Downloads/raspi/backup.img
不过因为是整个 32G 的 SD 卡, 很是有些慢...

以后要恢复的话, 反着来就行(当然也是要先 mount 看一下啦)
sudo dd if=/Users/air9/Downloads/raspi/backup.img of=/dev/disk3


准备就绪, 开始尝试触屏了
将之前下载的 6.3 驱动 scp 到树莓派里
然后按照 http://blog.sina.com.cn/s/blog_163c3da910102whds.html 的步骤
解压驱动并 cd 进入
sudo apt-get update
sudo ./LCD_backup  # 备份当前显示设置
sudo ./LCD35_v   # 切换到小触屏的显示设置, 并自动重启

这时外接的大显示屏已经不亮了, 一开始还以为系统又挂了, 后来插上小触屏才发现...原来这俩显示模式不能共存...
然后用手指触控基本不可能...只能用一个上个世纪电阻屏手机的那种触控笔...
好吧...只能不情愿的接受这个设定了...

这个命令切换回正常的显示模式
sudo ./LCD_restore
