---
layout: post
status: publish
published: true
title: Sublime Text 支持GBK（解决中文乱码）


date: '2018-01-27 10:44:41 +0800'
date_gmt: '2018-01-27 02:44:41 +0800'
categories:
- Util
tags:
- Sublime
- 乱码
- GBK
comments: []
---
<p>Sublime Text 是一款既简洁又强大的文本编辑器，然而其默认采用UTF8编码，这就造成了许多采用GBK编码的文件里的中文显示为乱码。还好有一个专门解决这个问题的插件：ConvertToUTF8 。</p>
<p>安装方法如下：</p>
<ol>
<li>打开Sublime Text，按Ctrl + ~打开控制台，在&nbsp;<a href="https://packagecontrol.io/installation" target="_blank" rel="noopener">https://packagecontrol.io/installation</a>&nbsp;根据你的 Sublime Text 版本选择对应的安装代码，将代码输入控制台后回车，之后便会自动下载并安装 Package Control，安装完成后需要重启Sublime Text 。</li>
<li>按Ctrl +&nbsp;Shift + P打开万能搜索框，然后输入install package回车，这时候会加载所有的packages列表。看到列表之后再输入ConvertToUTF8回车，就会下载安装这个包了</li>
<li>同样的方式安装Codecs33</li>
</ol>
<p>&nbsp;</p>
<p>参考：http://blog.csdn.net/jackeriss/article/details/44115813</p>
