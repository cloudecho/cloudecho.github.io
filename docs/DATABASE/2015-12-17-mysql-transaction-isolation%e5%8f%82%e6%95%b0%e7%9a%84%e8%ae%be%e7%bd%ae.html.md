---
layout: post
status: publish
published: true
title: MySQL transaction-isolation参数的设置


date: '2015-12-17 17:46:10 +0800'
date_gmt: '2015-12-17 09:46:10 +0800'
categories:
- Database
tags:
- MySQL
- transaction
- isolation
comments: []
---
<p>1.在<span class="skimlinks-unlinked">my.cnf中的【mysqld</span>】部分添加：</p>
<p>[mysqld]</p>
<p>transaction-isolation = read-committed</p>
<p>2.重启mysql数据库</p>
<p>mysql> show variables like &lsquo;tx%&rsquo;;<br />
+&mdash;&mdash;&mdash;&mdash;&mdash;+&mdash;&mdash;&mdash;&mdash;&mdash;-+<br />
| Variable_name | Value&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |<br />
+&mdash;&mdash;&mdash;&mdash;&mdash;+&mdash;&mdash;&mdash;&mdash;&mdash;-+<br />
| tx_isolation&nbsp; | READ-COMMITTED |<br />
+&mdash;&mdash;&mdash;&mdash;&mdash;+&mdash;&mdash;&mdash;&mdash;&mdash;-+</p>
<p>摘自『https://anmh.wordpress.com/2010/06/30/mysql%EF%BC%9Atransaction-isolation%E5%8F%82%E6%95%B0%E7%9A%84%E8%AE%BE%E7%BD%AE/』</p>
