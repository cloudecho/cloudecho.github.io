---
layout: post
status: publish
published: true
title: CentOS 7.2 redis-3.0.5 WARNING  solved


date: '2016-12-21 20:20:55 +0800'
date_gmt: '2016-12-21 12:20:55 +0800'
categories:
- Database
- Opensource
tags:
- Redis
- nosql
- 缓存
comments: []
---
<p>启动redis，显示告警如下：</p>
<blockquote><p>8589:M 05 Dec 14:28:58.509 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.<br />
8589:M 05 Dec 14:28:58.509 # Server started, Redis version 3.0.5<br />
8589:M 05 Dec 14:28:58.509 # WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.<br />
8589:M 05 Dec 14:28:58.523 # WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.</p></blockquote>
<p>解决方法:</p>
<blockquote><p># vi /etc/sysctl.conf<br />
追加<br />
-------------------------------------------<br />
vm.overcommit_memory = 1<br />
net.core.somaxconn = 4096<br />
-------------------------------------------<br />
使上述配置生效<br />
# /sbin/sysctl -p</p></blockquote>
<blockquote><p># echo never > /sys/kernel/mm/transparent_hugepage/enabled<br />
# vi /etc/rc.local<br />
追加<br />
-------------------------------------------<br />
echo never > /sys/kernel/mm/transparent_hugepage/enabled<br />
-------------------------------------------</p></blockquote>
<blockquote><p># vi /etc/security/limits.conf<br />
追加如下内容<br />
注：redis是启动redis的操作系统用户<br />
-------------------------------------------<br />
redis hard nofile 64000<br />
redis soft nofile 64000<br />
-------------------------------------------</p></blockquote>
<p>然后重启redis.</p>
