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
## 1. 准备

```sh
cat /etc/redhat-release
# CentOS Linux release 7.6.1810 (Core)
```

## 2. 安装Mariadb 10.4

```sh
cat | sudo tee /etc/yum.repos.d/mariadb.repo <<EOF
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

sudo mysql_secure_installation
```

**Create database**. Let's take wordpress as an example:

```sql
$ mysql -u root -p
MariaDB [(none)]> CREATE DATABASE `wordpress` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;

MariaDB [(none)]> grant all on wordpress.* to wp@'localhost' identified by 'changeMe';
```

## 3. 安装Apache2

```sh
sudo yum install httpd
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
```

## 4. 安装php 7.3
### 4.1 安装php
```
sudo yum remove php*

sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum -y install yum-utils
sudo yum-config-manager --enable remi-php73

sudo yum --enablerepo remi,epel install php php-mysql php-gd php-imagick php-bcmath

php -v
```

### 4.2 httpd 支持 php

sudo vi /etc/httpd/conf/httpd.conf
```
......
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
.......
```

检查httpd.conf语法 & 重新加载
```
apachectl -t  && sudo apachectl graceful
```

### 4.3 测试页面
```
echo -e '<?php\necho "Hello, PHP."\n?>' | sudo tee /var/www/html/1.php
```

## Reference
- https://tecadmin.net/install-mariadb-10-centos-redhat/
- centos安装php https://my.oschina.net/codercpf/blog/1825069
- httpd支持php https://blog.51cto.com/shuzonglu/2074448
- selinux contexts https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/sect-security-enhanced_linux-working_with_selinux-selinux_contexts_labeling_files