---
layout: post
status: publish
published: true
title: centos7 安装 MariaDB - MySQL社区版


date: '2015-07-30 21:01:18 +0800'
date_gmt: '2015-07-30 13:01:18 +0800'
categories:
- Database
tags:
- 数据库
- MySQL
- MariaDB
comments: []
---
<h3><strong>一、安装</strong></h3>
<div># yum install mariadb-server mariadb-client</div>
<div># systemctl start mariadb</div>
<div>
<div># systemctl enable mariadb</div>
</div>
<div></div>
<h3><strong>二、配置</strong></h3>
<h4><strong>1、修改root用户密码</strong></h4>
<div>
<p>默认情况下安装好mysql数据库之后root密码是空的，为了安全起见需要修改root用户密码<br />
# mysqladmin -u root password 111111&nbsp;&nbsp; //将root用户的密码修改为111111</p>
<h4><strong>2、表名大小写不敏感</strong></h4>
<div>用root帐号登录，在/etc/my.cnf 或 /etc/myql/my.cnf中的[mysqld]后添加</div>
<div>lower_case_table_names=1</div>
</div>
<div></div>
<div></div>
<h3><strong>三、创建数据库</strong></h3>
<div>
<div>
<h4><strong>1、创建数据库</strong></h4>
<div># mysql -u root -p</div>
<div></div>
<p><span class="s1">MariaDB [(none)]>&nbsp;</span>CREATE DATABASE `malldb` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;</p>
</div>
<div>
<h4><strong>2、远程连接malldb数据库</strong></h4>
<div>
<p class="p1"><span class="s1">MariaDB [(none)]>&nbsp;</span>grant all on malldb.* to root@'%' identified by '123456';</p>
</div>
</div>
</div>
