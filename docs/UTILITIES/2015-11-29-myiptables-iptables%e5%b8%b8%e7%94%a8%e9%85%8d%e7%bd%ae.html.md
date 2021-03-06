---
layout: post
status: publish
published: true
title: 'myiptables: iptables常用配置'


date: '2015-11-29 13:44:31 +0800'
date_gmt: '2015-11-29 05:44:31 +0800'
categories:
- Util
tags:
- iptables
comments: []
---
<p>#!/bin/bash<br />
# myiptables.sh<br />
iptables -F<br />
iptables -P INPUT DROP<br />
iptables -P FORWARD DROP<br />
iptables -P OUTPUT DROP</p>
<p># DNS<br />
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT<br />
iptables -A INPUT -p udp --sport 53 -j ACCEPT</p>
<p># 允许包从22端口进入<br />
iptables -A INPUT -p tcp --dport 22 -j ACCEPT<br />
# 允许从22端口进入的包返回<br />
iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT</p>
<p># 允许本机访问本机<br />
iptables -A INPUT -i lo -j ACCEPT</p>
<p># 允许所有IP访问80端口<br />
iptables -A INPUT -p tcp -s 0/0 --dport 80 -j ACCEPT<br />
iptables -A OUTPUT -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT</p>
<p># 保存配置 或者使用命令 service iptables save<br />
iptables-save > /etc/sysconfig/iptables<br />
iptables -L</p>
<p><strong>注</strong>：仅仅屏蔽外网(eth1)<br />
iptables -P INPUT ACCEPT<br />
iptables -A INPUT -p tcp -i eth1 --dport 8080 -j DROP</p>
<p><strong>附</strong>：/etc/sysconfig/iptables &nbsp;实例</p>
<blockquote>
<pre># Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8161 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 6379 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
</pre>
</blockquote>
