---
layout: post
status: publish
published: true
title: CentOS 6.x 安装nvidia显卡驱动及屏幕亮度问题


date: '2016-06-19 10:43:10 +0800'
date_gmt: '2016-06-19 02:43:10 +0800'
categories:
- Util
- Util
tags:
- centos
- nvidia
- 显卡
- 驱动
comments: []
---
<p><strong>一、准备</strong><br />
1<br />
根据nvidia显卡的具体型号，从官方网站下载驱动，比如 <span style="color: #ff6600;">NVIDIA-Linux-x86_64-340.96.run</span><br />
<span style="color: #ff6600;">「手动搜索驱动程序」</span><br />
http://www.geforce.cn/drivers#start-search</p>
<p>2<br />
安装编译环境：gcc、kernel、kernel-devel、kernel-headers<br />
[root@localhost ~]# yum -y install gcc kernel kernel-devel kernel-headers</p>
<p>3<br />
修改/etc/modprobe.d/blacklist.conf 文件，以阻止 nouveau 模块的加载<br />
方法： 添加blacklist nouveau，注释掉blacklist nvidiafb</p>
<p>4<br />
重新建立initramfs image文件</p>
<p>[root@localhost ~]# mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r).img.bak<br />
[root@localhost ~]# dracut /boot/initramfs-$(uname -r).img $(uname -r)</p>
<p>5<br />
修改/etc/inittab，使系统开机进入init 3文本模式:<br />
将最后一行&ldquo;id:5:initdefault:&rdquo;修改成&ldquo;id:3:initdefault:&rdquo;（不包含引号）<br />
注释：5代表系统启动时默认进入x-window图形界面，3代表默认进入终端模式。</p>
<p>6<br />
重启<br />
[root@localhost ~]# reboot</p>
<p><strong>二、安装NVIDIA驱动</strong></p>
<p>1<br />
输入root和password，进入根用户模式下,确保nouveau kernel driver没有被加载<br />
[root@localhost ~]# lsmod | grep nouveau</p>
<p>2<br />
进入驱动程序所在目录,开始安装<br />
[root@localhost ~]# chmod +x NVIDIA-Linux-x86_64-340.96.run<br />
[root@localhost ~]# ./NVIDIA-Linux-x86_64-340.96.run<br />
安装过程中，根据提示选择accept，yes 或 OK，即可完成安装。</p>
<p>3<br />
修改/etc/inittab，使系统开机进入init 5图形界面模式<br />
将最后一行&ldquo;id:3:initdefault:&rdquo;修改成&ldquo;id:5:initdefault:&rdquo;</p>
<p>4<br />
重启<br />
[root@localhost ~]#reboot<br />
当看到Nvidia的logo后，安装成功,登陆后在系统- 首选项里可以看到NVIDIA X Server Settings菜单，可以查看基本信息及进行一些设置</p>
<p><strong>三、&nbsp;屏幕亮度不可调的解决方法</strong><br />
解决办法：修改/etc/X11/xorg.con文件，找Section "Device"，然后在相应的EndSection之前添加一行<br />
Option "RegistryDwords" "EnableBrightnessControl=1"<br />
保存并重启电脑。</p>
<p>参考<br />
http://jingyan.baidu.com/article/9f63fb91d7e6b5c8400f0e0c.html<br />
http://my.oschina.net/hevakelcj/blog/176129</p>
