---
layout: post
status: publish
published: true
title: Ubuntu 文件共享 samba服务


date: '2015-11-27 16:12:29 +0800'
date_gmt: '2015-11-27 08:12:29 +0800'
categories:
- Util
tags:
- ubuntu
- samba
comments: []
---
<p>文件共享 samba服务，它是一个在linux和unix上实现SMB协议的一个免费软件，SMB协议全称叫做Server Message Block（信息服务块），它可以在局域网上共享文件和打印机的一种协议，功能很强大。我采用的是这种方法。</p>
<p>首先，安装smb：执行下列命令</p>
<p>sudo apt-get install samba</p>
<p>sudo apt-get install smbfs</p>
<p>如果提示找不到软件的话，update,upgrade一次应该就行。</p>
<p>然后，终端中执行shares-admin命令，可能也会提示先装相应的tools，按提示装就行</p>
<p>在界面中，先执行unlock操作，再添加一个共享文件夹，如图所示</p>
<p><img src="http://img.blog.csdn.net/20140705100115000?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGVtb253eWM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" alt="" /></p>
<p>共享之后，如果不做任何设置，则mac os可以连接到ubuntu虚拟机，但要提示用户名和密码，此时不论输入什么都无法访问共享的内容。</p>
<p>实现匿名访问需要修改配置文件。</p>
<p>修改配置文件smb.conf：执行命令 sudo nano /etc/samba/smb.conf</p>
<p>在其中搜索到"security=user" 改为 "securtiy=share"，并将该行头 # 注释去掉。</p>
<p>重启samba（sudo /etc/init.d/samba restart）或重启虚拟机。</p>
<p>这时已经能在mac os的文件目录下看到 共享的... 条目，如图所示</p>
<p><img src="http://img.blog.csdn.net/20140705100548453?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGVtb253eWM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" alt="" width="570" height="341" /></p>
<p>不过，这个时候只能读，不能写，如果还要写入的话，执行命令</p>
<p>chmod 777 /home/lemon/Downloads （这里的路径是我共享文件的路径），到这里已经可以任意的读取写入了。</p>
<p>摘自「互联网」</p>
