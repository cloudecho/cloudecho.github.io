---
layout: post
status: publish
published: true
title: Install fcitx-cloudpinyin on CentOS 7.5


date: '2018-12-01 15:13:59 +0800'
date_gmt: '2018-12-01 07:13:59 +0800'
categories:
- Util
tags:
- centos
- input
- fcitx
- pinyin
comments: []
---
<p><strong>1. 卸载ibus</strong><br />
yum remove ibus imsettings</p>
<p><strong>2. 安装拼音输入法</strong></p>
<blockquote><p>
yum install imsettings fcitx<br />
yum install fcitx-cloudpinyin fcitx-configtool<br />
imsettings-switch fcitx
</p></blockquote>
<p><strong>3. 配置Fcitx</strong><br />
在~/.bashrc中添加如下内容</p>
<blockquote><p>
export GTK_IM_MODULE=fcitx<br />
export QT_IM_MODULE=fcitx<br />
export XMODIFIERS=&rdquo;@im=fcitx&rdquo;
</p></blockquote>
<p>打开fcitx的配置工具，选择输入法标签点&rdquo;+&rdquo;可以搜索并添加输入法</p>
<p><strong>4. Logout & Login</strong></p>
<p><strong>Reference</strong><br />
https://blog.csdn.net/maokexu123/article/details/44495395 </p>
