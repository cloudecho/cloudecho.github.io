---
layout: post
status: publish
published: true
title: Install CloudStack 4.11.1.0 on CentOS 7.5


date: '2018-12-15 16:45:53 +0800'
date_gmt: '2018-12-15 08:45:53 +0800'
categories:
- Opensource
tags:
- cloudstack
- iaas
- cloudnative
comments: []
---
## 1 Preparation
### 1.1 设置selinux

```
sed -i s#'SELINUX=enforcing'#'SELINUX=permissive'#g /etc/selinux/config
setenforce 0
```

### 1.2 安装NTP（时间同步）

```
yum -y install ntp
systemctl enable ntpd
```

### 1.3 安装cloudstack.repo

```
cat <<EOF > /etc/yum.repos.d/cloudstack.repo
[cloudstack]
name=cloudstack
baseurl=http://cloudstack.apt-get.eu/centos/7/4.11/
enabled=1
gpgcheck=0

EOF
```

### 1.4 设置防火墙

```
firewall-cmd --permanent --add-port=111/tcp
firewall-cmd --permanent --add-port=111/udp
firewall-cmd --permanent --add-port=2049/tcp
firewall-cmd --permanent --add-port=32803/tcp
firewall-cmd --permanent --add-port=32769/udp
firewall-cmd --permanent --add-port=892/tcp
firewall-cmd --permanent --add-port=892/udp
firewall-cmd --permanent --add-port=875/tcp
firewall-cmd --permanent --add-port=875/udp
firewall-cmd --permanent --add-port=662/tcp
firewall-cmd --permanent --add-port=662/udp
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --reload
firewall-cmd --list-all
```

## 2 Installation
### 2.1 安装cloudstack-management

```
yum -y install cloudstack-management 
```

### 2.2 安装MariaDB

#### 2.2.1 Install & config mariadb
```
yum install mariadb mariadb-server 
vi /etc/my.cnf 
[mysqld]
innodb_rollback_on_timeout=1
innodb_lock_wait_timeout=600
max_connections=350
log-bin=mysql-bin
binlog-format = 'ROW'
```

#### 2.2.2 创建data目录

```
[root@panda lib]# mkdir -p /data/lib/mysql
[root@panda lib]# chown mysql:mysql /data/lib/mysql/
[root@panda lib]# rmdir /var/lib/mysql/
[root@panda lib]# cd /var/lib && ln -s /data/lib/mysql/ .
```

#### 2.2.3 启动数据库并设置为开机启动

```
systemctl start mariadb      #启动数据库
systemctl enable mariadb     #开机自启动
```

#### 2.2.4 初始化数据库

```
mysql_secure_installation              
#设置密码然后一路yyyy （yes）
```

### 2.3 使用cloudstack-setup-databases初始化CloudStack数据库

```
cloudstack-setup-databases cloud:cloud@localhost --deploy-as=root:123456 -i 192.168.10.3 
## 192.168.10.3是当前系统的本地ip
# 重置数据库密码123456
```

### 2.4 安装management服务器

```
cloudstack-setup-management 
# The --tomcat7 option is deprecated, CloudStack now uses embedded Jetty server.
```

启动cloudstack

```
systemctl start cloudstack-management
```

### 2.5 安装与配置NFS存储

```
yum -y install nfs-utils rpcbind
```


#### 2.5.1 配置域名
```
vi /etc/idmapd.conf
Domain = echoyun.edu
```

#### 2.5.2 准备NFS目录
```
mkdir -p /data/cloudstack/{primary,secondary}
```

#### 2.5.3 修改NFS服务参数
```
# vim /etc/sysconfig/nfs
MOUNTD_PORT=892
STATD_PORT=662
STATD_OUTGOING_PORT=2020
```

```
# vim /etc/modprobe.d/lockd.conf 
options lockd nlm_tcpport=32803
options lockd nlm_udpport=32769
```

#### 2.5.4 配置exports
```
vim /etc/exports
/data/cloudstack/primary *(rw,async,no_root_squash,no_subtree_check)
/data/cloudstack/secondary *(rw,async,no_root_squash,no_subtree_check)
```

#### 2.5.5 设置nfs挂载
```
vim /etc/nfsmount.conf
Nfsvers=4
```

#### 2.5.6 启动nfs和rpcbind

````
systemctl enable rpcbind
systemctl enable nfs-server
systemctl start rpcbind
systemctl start nfs-server
````


#### 2.5.7 测试挂载

```
mount -t nfs 192.168.10.3:/data/cloudstack/primary /mnt
df -h    #查看有了代表成功
umount /mnt
```

### 2.6 下载系统VM模板
```
/usr/share/cloudstack-common/scripts/storage/secondary/cloud-install-sys-tmplt -m /data/cloudstack/secondary -u http://cloudstack.apt-get.eu/systemvm/4.11/systemvmtemplate-4.11.1-kvm.qcow2.bz2 -h kvm -F
```

### 2.7 安装agent（cloudstack主机）

如果部署集群，备机只需要直接部署agent.

```
yum -y install cloudstack-agent
```


#### 2.7.1 配置文件修改
```
# vi /etc/libvirt/qemu.conf  并取消如下行的注释
vnc_listen=0.0.0.0
```

#### 2.7.2 配置KVM

```
# vi /etc/libvirt/libvirtd.conf
listen_tls = 0
listen_tcp = 1
tcp_port = "16059"
auth_tcp = "none"
mdns_adv = 0
```

```
# vi /etc/sysconfig/libvirtd
LIBVIRTD_ARGS="--listen"

systemctl restart libvirtd
systemctl enable libvirtd
```

#### 2.7.3 配置agent

```
vi /etc/cloudstack/agent/agent.properties
host=192.168.10.3
```


#### 2.7.4 配置网卡（做桥接）

编辑第一块网卡(em1)

```
cat <<EOF > /etc/sysconfig/network-scripts/ifcfg-em1 
DEVICE=em1
TYPE=Ethernet
HWADDR=8c:ec:4b:9a:9d:11
BOOTPROTO=none
ONBOOT=yes
NM_CONTROLLED=no
BRIDGE=cloudbr0
EOF
```

网卡桥接（名字也可以自定义，要和里边配置对应上）


```
cat <<EOF > /etc/sysconfig/network-scripts/ifcfg-cloudbr0
TYPE=Bridge
BOOTPROTO=static
DEVICE=cloudbr0
IPV6INIT=yes
ONBOOT=yes
IPADDR=192.168.10.3
NETMASK=255.255.255.0
GATEWAY=192.168.10.1
DNS1=223.5.5.5
DNS2=223.6.6.6
NM_CONTROLLED=no
DELAY=0
EOF
```

```
[root@panda lib]# cat /etc/sysconfig/network
# Created by anaconda
GATEWAY=192.168.10.1
```

#### 2.7.5 初始化cloudstack-agent
```
cloudstack-setup-agent    #一路回车
[root@panda ~]# cloudstack-setup-agent
Welcome to the CloudStack Agent Setup:
Please input the Management Server Hostname/IP-Address:[192.168.10.3]
Please input the Zone Id:[default]
Please input the Pod Id:[default]
Please input the Cluster Id:[default]
Please input the Hypervisor type kvm/lxc:[kvm]
Please choose which network used to create VM:[cloudbr0]
Starting to configure your system:
Configure SElinux ...         [OK]
Configure Network ...         [OK]
Configure Libvirt ...         [OK]
Configure Firewall ...        [OK]
Configure Nfs ...             [OK]
Configure cloudAgent ...      [OK]
CloudStack Agent setup is done!
```

```
systemctl restart cloudstack-agent
systemctl restart libvirtd
```

## 3 下一步
查看8080端口是否启动

```
netstat -tunlp|grep 8080
```

打开浏览器，进行下一步配置

http://192.168.10.3:8080/client/   账号admin 密码password



## Reference
http://www.jackfan.top/posts/47209/