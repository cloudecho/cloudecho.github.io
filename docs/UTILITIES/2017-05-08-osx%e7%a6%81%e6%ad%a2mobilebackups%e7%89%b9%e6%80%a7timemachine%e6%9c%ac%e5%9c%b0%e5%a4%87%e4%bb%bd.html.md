---
layout: post
status: publish
published: true
title: OSX禁止MobileBackups特性(TimeMachine本地备份)


date: '2017-05-08 10:09:59 +0800'
date_gmt: '2017-05-08 02:09:59 +0800'
categories:
- Util
tags: []
comments: []
---
<p>MobileBackups，即OS X上TimeMachine的本地备份。会占用非常大得空间。</p>
<p>我在查看硬盘使用情况的时候，发现目录/Volumes/MobileBackups占用了20多G空间，这是TimeMachine用来做备份的。</p>
<p>根据官网的介绍，在OS 10.7及以后的版本中，当你没有插入其他硬盘作为TimeMachine的备份硬盘时，TimeMachine会自动创建/Volumes/MobileBackups用作备份。因为占用的空间太大了，所以不得不禁止TimeMachine的这种行为。</p>
<p>在终端下执行命令：</p>
<pre><code><span class="title">sudo</span> tmutil disablelocal
</code></pre>
<p>就可以关闭本地备份了。不过记得要及时的使用TimeMachine备份资料。</p>
<p>&nbsp;</p>
<h2>摘自</h2>
<blockquote><p>http://blog.xinspace.space/2015/08/14/osx-disable-mobilebackups/</p></blockquote>
