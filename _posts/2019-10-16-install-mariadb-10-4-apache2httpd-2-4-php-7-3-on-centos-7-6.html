---
layout: post
status: publish
published: true
title: Install MariaDB 10.4 + Apache2(httpd) 2.4 + PHP 7.3 on CentOS 7.6


date: '2019-10-16 12:07:51 +0800'
date_gmt: '2019-10-16 04:07:51 +0800'
categories:
- Database
- Opensource
tags:
- MariaDB
- apache2
- httpd
- PHP
comments: []
---
<h2>1. 准备</h2>
<pre><code class="language-sh">cat /etc/redhat-release
# CentOS Linux release 7.6.1810 (Core)</code></pre>
<h2>2. 安装MariaDB 10.4</h2>
<pre><code class="language-sh">cat | sudo tee /etc/yum.repos.d/mariadb.repo <<EOF
[mariadb]
name = MariaDB
baseurl = https://yum.mariadb.org/10.4/rhel7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

sudo yum install MariaDB-server MariaDB-client
sudo systemctl start mariadb
sudo systemctl enable mariadb

#表名大小写不敏感
sudo sed -i 's/\[mysqld\]/[mysqld]\nlower_case_table_names=1/' /etc/my.cnf

sudo mysql_secure_installation</code></pre>
<p><strong>Create database</strong>. Let's take wordpress as an example:</p>
<pre><code class="language-sql">$ mysql -u root -p
MariaDB [(none)]> CREATE DATABASE `wordpress` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;

MariaDB [(none)]> grant all on wordpress.* to wp@'localhost' identified by 'changeMe';</code></pre>
<h2>3. 安装Apache2</h2>
<pre><code class="language-sh">sudo yum install httpd
sudo systemctl enable httpd
sudo systemctl start httpd

sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --reload
sudo firewall-cmd --list-all

sudo chown -R apache:apache /var/www/html
# ls -Z /var/www/html/
sudo chcon -R  -t  httpd_sys_rw_content_t /var/www/html/

# For reverse proxy
sudo setsebool -P httpd_can_network_connect on
</code></pre>
<h2>4. 安装php 7.3</h2>
<h3>4.1 安装php</h3>
<pre><code>sudo yum remove php*

sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum -y install yum-utils
sudo yum-config-manager --enable remi-php73

sudo yum --enablerepo remi,epel install php php-mysql php-gd php-imagick php-bcmath

php -v</code></pre>
<h3>4.2 httpd 支持 php</h3>
<p>sudo vi /etc/httpd/conf/httpd.conf</p>
<pre><code>......
ServerName your_domain:80

......
<Directory />
    AllowOverride none
    #Require all denied
    Require all granted
</Directory>

......
<IfModule dir_module>
    DirectoryIndex index.html index.php
</IfModule>
AddType application/x-httpd-php .php

.......
<Directory /var/www/html>
    ......
    AllowOverride All
.......</code></pre>
<p>检查httpd.conf语法 &amp; 重新加载</p>
<pre><code>apachectl -t  &amp;&amp; sudo apachectl graceful</code></pre>
<h3>4.3 测试页面</h3>
<pre><code>echo -e '<?php\necho "Hello, PHP."\n?>' | sudo tee /var/www/html/1.php</code></pre>
<h2>Reference</h2>
<ul>
<li><a href="https://tecadmin.net/install-mariadb-10-centos-redhat/">https://tecadmin.net/install-mariadb-10-centos-redhat/</a></li>
<li>centos安装php <a href="https://my.oschina.net/codercpf/blog/1825069">https://my.oschina.net/codercpf/blog/1825069</a></li>
<li>httpd支持php <a href="https://blog.51cto.com/shuzonglu/2074448">https://blog.51cto.com/shuzonglu/2074448</a></li>
<li>selinux contexts <a href="https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/sect-security-enhanced_linux-working_with_selinux-selinux_contexts_labeling_files">https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/sect-security-enhanced_linux-working_with_selinux-selinux_contexts_labeling_files</a></li>
</ul>
