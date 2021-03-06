---
layout: post
status: publish
published: true
title: CentOS 6 yum 安装  GlusterFS 3.6


date: '2016-12-08 16:25:27 +0800'
date_gmt: '2016-12-08 08:25:27 +0800'
categories:
- Opensource
tags: []
comments: []
---
<p>GlusterFS 安装至 o2o-gluster-1,o2o-gluster-2<br />
============================================================<br />
两台机组成GlusterFS Server集群。<br />
1、安装依赖包<br />
# yum -y install wget<br />
# cd /etc/yum.repos.d/<br />
# wget http://download.gluster.org/pub/gluster/glusterfs/3.6/LATEST/CentOS/glusterfs-epel.repo<br />
# yum -y install epel-release</p>
<p>2、安装服务端 (o2o-gluster-1,o2o-gluster-2)<br />
# yum install glusterfs-server<br />
# service glusterd start  或  # /etc/init.d/glusterd start<br />
# chkconfig glusterfsd on</p>
<p>**如果是o2o-gluster-1，o2o-gluster-2集群**<br />
-----------------------------------------------<br />
下面这行命令在一台服务器上执行即可，状态将同步到其他服务器<br />
例如在o2o-gluster-1上执行<br />
# gluster peer probe o2o-gluster-2<br />
-----------------------------------------------</p>
<p>查看状态<br />
# gluster peer status</p>
<p>注：已挂载独立硬盘分区到/gfs_data目录<br />
在o2o-gluster-1和o2o-gluster-2中分别执行<br />
# mkdir -p /gfs_data/glusterfs/brick1</p>
<p>**如果是o2o-gluster-1，o2o-gluster-2集群**<br />
-----------------------------------------------<br />
在o2o-gluster-1和o2o-gluster-2其中一台机器上执行<br />
replica 指定副本数量<br />
# gluster volume create gv0 replica 2 o2o-gluster-1:/gfs_data/glusterfs/brick1 o2o-gluster-2:/gfs_data/glusterfs/brick1<br />
-----------------------------------------------</p>
<p>**如果是o2o-gluster-1单机**<br />
-----------------------------------------------<br />
gluster volume create gv0 o2o-gluster-1:/gfs_data/glusterfs/brick1<br />
-----------------------------------------------</p>
<p>启动volume<br />
# gluster volume start gv0</p>
<p>若要使用Cache<br />
# gluster volume set gv0 performance.cache-size 1GB</p>
<p># 可选项：配置ACL只允许指定IP访问集群，例如：<br />
gluster volume set gv0 auth.allow 10.10.0.1,10.10.0.2<br />
查看volume状态<br />
# gluster volume status<br />
# gluster volume info</p>
<p>3、**客户端**挂载远程文件系统 （以o2o-proxy-1为例）<br />
查找 glusterfs 命令<br />
# which glusterfs<br />
/usr/sbin/glusterfs  </p>
<p>如果glusterfs命令**不存在**，则安装glusterfs-client<br />
# yum install glusterfs-client </p>
<p>挂载目录<br />
# mkdir -p /data/gfs_data<br />
# chown -R prod:prod /data/gfs_data</p>
<p>在客户机（例如o2o-proxy-1）上执行挂载命令（读写模式）：<br />
mount -t glusterfs -o rw o2o-gluster-1:/gv0 /data/gfs_data<br />
注：ro:只读模式  rw:读写模式</p>
<p>设置为开机自动挂载<br />
# vi /etc/fstab<br />
追加<br />
o2o-gluster-1:/gv0 /data/gfs_data glusterfs defaults,_netdev 0 0</p>
