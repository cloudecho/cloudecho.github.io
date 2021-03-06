---
layout: post
status: publish
published: true
title: Linux系统设置Swap分区的大小(两种方法)


date: '2017-05-20 11:43:33 +0800'
date_gmt: '2017-05-20 03:43:33 +0800'
categories:
- Util
tags:
- linux
- swap
comments: []
---
<h3>在安装完Linux系统后，swap分区太小怎么办，怎么可以扩大Swap分区呢？有两个办法，一个是从新建立swap分区，一个是增加swap分区。下面介绍这两种方法：</h3>
<p>第一您必须有root权限，过程中一定要很小心，一不小心就破坏了整个硬盘的数据，执行下面的过程之前您需要三思而行，错误操作后的后果由执行者自己承担。</p>
<h3>方法一：新建swap分区（慎用）</h3>
<ol>
<li>以root身份进入控制台，输入</li>
</ol>
<p># swapoff -a&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; #停止交换分区</p>
<p>&nbsp;</p>
<ol start="2">
<li>用fdisk命令加swap分区的盘符，（例：# fdisk /dev/sdb）剔除swap分区，输入d删除swap分区，然后再n添加分区（添加时硬盘必须要有可用空间，然后再用t将新添的分区id改为82（linux swap类型），最后用w将操作实际写入硬盘（没用w之前的操作是无效的）。</li>
</ol>
<p>&nbsp;</p>
<ol start="3">
<li># mkswap /dev/sdb2 #格式化swap分区，这里的sdb2要看您加完后p命令显示的实际分区设备名</li>
</ol>
<p>&nbsp;</p>
<ol start="4">
<li># swapon /dev/sdb2 #启动新的swap分区</li>
</ol>
<p>&nbsp;</p>
<ol start="5">
<li>为了让系统启动时能自动启用交换分区，可以编辑/etc/fstab,加入下面一行</li>
</ol>
<p>/dev/sdb2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; swap&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; swap&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; defaults&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 0</p>
<p>6.完成</p>
<h3></h3>
<h3>方法二：增加Swap分区</h3>
<p>1.创建交换分区的文件:增加1G大小的交换分区，则命令写法如下，其中的 count 等于想要的块大小。</p>
<p># dd if=/dev/zero of=/home/swapfile bs=1M count=1024</p>
<p>&nbsp;</p>
<p>2.设置交换分区文件:</p>
<p># mkswap /home/swapfile&nbsp; #建立swap的文件系统</p>
<p>&nbsp;</p>
<p>3.立即启用交换分区文件:</p>
<p># swapon /home/swapfile&nbsp;&nbsp; #启用swap文件</p>
<p>&nbsp;</p>
<p>4.使系统开机时自启用，在文件/etc/fstab中添加一行：</p>
<p>/home/swapfile swap swap defaults 0 0</p>
<p>&nbsp;</p>
<p>5.完成</p>
<p>本文出自 &ldquo;<a href="http://hancj.blog.51cto.com/">hancj</a>&rdquo; 博客，请务必保留此出处<a href="http://hancj.blog.51cto.com/89070/197915">http://hancj.blog.51cto.com/89070/197915</a></p>
