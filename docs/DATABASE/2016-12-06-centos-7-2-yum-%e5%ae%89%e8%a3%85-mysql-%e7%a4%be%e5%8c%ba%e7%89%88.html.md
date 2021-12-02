---
layout: post
status: publish
published: true
title: centos 7.2 yum 安装 MySQL 社区版


date: '2016-12-06 19:39:33 +0800'
date_gmt: '2016-12-06 11:39:33 +0800'
categories:
- Database
tags: []
comments: []
---
<p><strong>1、新建yum源</strong><br />
[root@myhost yum.repos.d]# pwd<br />
/etc/yum.repos.d</p>
<p>[root@myhost yum.repos.d]# cat mysql-community.repo</p>
<blockquote><p># Enable to use MySQL 5.6<br />
[mysql56-community]<br />
name=MySQL 5.6 Community Server<br />
baseurl=http://repo.mysql.com/yum/mysql-5.6-community/el/7/x86_64<br />
enabled=1<br />
gpgcheck=0</p></blockquote>
<p><strong>2、yum 安装MySQL社区版</strong></p>
<p>[root@myhost yum.repos.d]# yum install mysql-community-server<br />
[root@myhost yum.repos.d]# systemctl list-unit-files | grep mysql<br />
[root@myhost yum.repos.d]# service mysql start</p>
<p><strong>3、解决告警</strong><br />
[root@myhost yum.repos.d]# cat /var/log/mysqld.log | grep Warning<br />
问题</p>
<blockquote><p>2016-12-05 15:13:29 9005 [Warning] Buffered warning: Changed limits: max_open_files: 1024 (requested 5000)<br />
2016-12-05 15:13:29 9005 [Warning] Buffered warning: Changed limits: table_open_cache: 431 (requested 2000)</p></blockquote>
<p>解决</p>
<blockquote><p>[root@myhost ~]# ulimit -a<br />
[root@myhost ~]# vi /etc/security/limits.conf</p></blockquote>
<p>追加</p>
<blockquote><p>mysql hard nofile 65535<br />
mysql soft nofile 65535</p></blockquote>
<p>[root@myhost ~]# vi /usr/lib/systemd/system/mysqld.service<br />
(in the [service] section) 追加</p>
<blockquote><p>LimitNOFILE=65535</p></blockquote>
<p>[root@myhost ~]# systemctl daemon-reload<br />
[root@myhost ~]# service mysql restart</p>
<p>see more： http://stackoverflow.com/questions/32760202/buffered-warning-changed-limits-max-connections-214-requested-800</p>
<p><strong>4、重置root密码</strong><br />
# service mysql stop<br />
# mysqld_safe --user=mysql --skip-grant-tables --skip-networking &amp;<br />
# mysql -u root mysql</p>
<blockquote><p>mysql>UPDATE user SET Password=PASSWORD('new_password') where USER='root';<br />
mysql>FLUSH PRIVILEGES;<br />
mysql>quit</p></blockquote>
<p># service mysql start</p>
