---
layout: post
status: publish
published: true
title: ubuntu linuxmint下自动安装雅黑字体脚本 -- 转


date: '2017-01-01 14:25:13 +0800'
date_gmt: '2017-01-01 06:25:13 +0800'
categories:
- Util
tags:
- ubuntu
- linuxmint
comments: []
---
<p>安装ubuntu的时候，总是需要美化中文字体。 微软雅黑是比较好的中文字体美化方案。 下面的这个脚本可以帮助大家自动来美化中文字体。</p>
<pre lang="bash">wget -O get-fonts.sh.zip http://files.cnblogs.com/DengYangjun/get-fonts.sh.zip
unzip -o get-fonts.sh.zip 1>/dev/null
chmod a+x get-fonts.sh
./get-fonts.sh</pre>
<p>删除下载的字体安装脚本文件：</p>
<pre lang="bash">rm get-fonts.sh get-fonts.sh.zip 2>/dev/null</pre>
<p>恢复以前的字体设置：</p>
<pre lang="bash">cd /etc/fonts/conf.avail
sudo mv 51-local.conf.old 51-local.conf 2>/dev/null
sudo mv 69-language-selector-zh-cn.conf.old 69-language-selector-zh-cn.conf 2>/dev/null
sudo rm -f -r /usr/share/fonts/truetype/myfonts 2>/dev/null
cd -</pre>
<p>修正记录：<br />
1.添加了最新的Windows 7的微软雅黑字体。（附件大小限制，未实现）<br />
2.修正了CRT渲染的配置文件的链接错误。<br />
3.添加字体：Agency FB<br />
4.添加字体设置恢复功能。</p>
<p>via <a href="http://blog.prosight.me/blogs/722/">http://blog.prosight.me/blogs/722/</a></p>
<p>转自： http://blog.sae.sina.com.cn/archives/1280</p>
<p>附：<span class="s1">get-fonts.sh </span></p>
<pre style="font-size: 14px; font-family: Helvetica, Arial, sans-serif;">
#!/bin/bash

#dir define
myfonts_dir=/usr/share/fonts/truetype/myfonts
remote_dir=http://files.cnblogs.com/DengYangjun

#fonts define
monaco=monaco-linux.ttf
lucida=lucida-console.ttf
msyh=msyh.ttf
msyhbd=msyhbd.ttf
agencyr=agencyr.ttf
agencyrb=agencyrb.ttf

screen=0

sudo mkdir $myfonts_dir 2>/dev/null

echo "Ubuntu字体自动安装工具"
echo "(C)2008-2009 Deng.Yangjun@Gmail.com"

echo "安装等宽英文台字体:Monaco"
wget -O $monaco.zip $remote_dir/$monaco.zip
unzip -o $monaco.zip 1>/dev/null
sudo mv $monaco $myfonts_dir
rm $monaco.zip

echo "安装等宽英文字体:Lucida Console"
wget -O $lucida.zip $remote_dir/$lucida.zip
unzip -o $lucida.zip 1>/dev/null
sudo mv $lucida $myfonts_dir
rm $lucida.zip

echo "安装英文字体:Agency FB"
wget -O $agencyr.zip $remote_dir/$agencyr.zip
unzip -o $agencyr.zip 1>/dev/null
sudo mv $agencyr $myfonts_dir
rm $agencyr.zip

wget -O $agencyrb.zip $remote_dir/$agencyrb.zip
unzip -o $agencyrb.zip 1>/dev/null
sudo mv $agencyrb $myfonts_dir
rm $agencyrb.zip

echo "安装字体:微软雅黑"
wget -O $msyh.zip $remote_dir/$msyh.zip
unzip -o $msyh.zip 1>/dev/null
sudo mv $msyh $myfonts_dir
rm $msyh.zip

wget -O $msyhbd.zip $remote_dir/$msyhbd.zip
unzip -o $msyhbd.zip 1>/dev/null
sudo mv $msyhbd $myfonts_dir
rm $msyhbd.zip

#Ubuntu 7.10
#wget http://www.cnblogs.com/Files/DengYangjun/language-selector.conf.zip
#unzip -o language-selector.conf.zip
#sudo mv language-selector.conf /etc/fonts
#rm language-selector.conf.zip

#Ubuntu 8.04 
echo "请选择显示器类型(1-2)：1-LED	2-CRT"
read screen
case $screen in
1) 
	wget -O local.conf.zip  $remote_dir/local.conf.led.zip
	;;
2)	
	wget -O local.conf.zip  $remote_dir/local.conf.crt.zip
	;;
?) 
	echo "无效选择，退出安装，安装未完成。"
	exit 1;
esac

unzip -o local.conf.zip 1>/dev/null
sudo mv /etc/fonts/conf.avail/51-local.conf /etc/fonts/conf.avail/51-local.conf.old
sudo mv local.conf /etc/fonts/conf.avail/51-local.conf
rm local.conf.zip

cd /etc/fonts/conf.avail
sudo mv 69-language-selector-zh-cn.conf 69-language-selector-zh-cn.conf.old 2>/dev/null

echo "请稍等，正在刷新系统字体..."
cd $myfonts_dir
sudo chmod 555 *
sudo mkfontscale 1>/dev/null
sudo mkfontdir 1>/dev/null
sudo fc-cache -v 1>/dev/null

echo "安装字体结束，谢谢使用。请退出X-Server，重新登录，查看字体效果。"
</pre>
<p><a href="http://techo.dev/wp-content/uploads/2017/01/agencyr.ttf_.zip">agencyr-ttf</a> <a href="http://techo.dev/wp-content/uploads/2017/01/agencyrb.ttf_.zip">agencyrb-ttf</a> <a href="http://techo.dev/wp-content/uploads/2017/01/local.conf_.zip">local-conf</a> <a href="http://techo.dev/wp-content/uploads/2017/01/lucida-console.ttf_.zip">lucida-console-ttf</a> <a href="http://techo.dev/wp-content/uploads/2017/01/monaco-linux.ttf_.zip">monaco-linux-ttf</a> <a href="http://techo.dev/wp-content/uploads/2017/01/msyh.ttf_.zip">msyh-ttf</a> <a href="http://techo.dev/wp-content/uploads/2017/01/msyhbd.ttf_.zip">msyhbd-ttf</a></p>
