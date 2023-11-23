---
layout: post
status: publish
published: true
title: Redis主从配置及使用KeepAlived实现Redis高可用


date: '2016-04-04 15:28:48 +0800'
date_gmt: '2016-04-04 07:28:48 +0800'
categories:
- Opensource
tags:
- Keepalived
- Redis
- 高可用
comments: []
---
<div><strong>一：环境介绍</strong></div>
<div>Master:&nbsp;172.16.206.29</div>
<div>Slave:&nbsp;172.16.206.28</div>
<div>Virtural&nbsp;IP&nbsp;Address&nbsp;(VIP):&nbsp;172.16.206.250</div>
<div></div>
<div><strong>二：设计思路：</strong></div>
<div>当&nbsp;Master&nbsp;与&nbsp;Slave&nbsp;均运作正常时,&nbsp;Master负责服务，Slave负责Standby；</div>
<div>当&nbsp;Master&nbsp;挂掉，Slave&nbsp;正常时,&nbsp;Slave接管服务，有写权限，同时关闭主从复制功能；</div>
<div>当&nbsp;Master&nbsp;恢复正常，则从Slave同步数据，同步数据之后关闭主从复制功能，恢复Master身份，同时Slave等待Master同步数据完成之后，恢复Slave身份。</div>
<div></div>
<div><strong>三：安装配置前准备工作</strong></div>
<div>在主服务器&nbsp;172.16.206.29&nbsp;上面做下面操作</div>
<div>echo&nbsp;&ldquo;172.16.206.29&nbsp;osb29&rdquo;&nbsp;>>&nbsp;/etc/hosts</div>
<div>echo&nbsp;&ldquo;172.16.206.28&nbsp;osb28&rdquo;&nbsp;>>&nbsp;/etc/hosts</div>
<div>在从服务器&nbsp;172.16.206.28&nbsp;上面做下面操作</div>
<div>echo&nbsp;&ldquo;172.16.206.29&nbsp;osb29&rdquo;&nbsp;>>&nbsp;/etc/hosts</div>
<div>echo&nbsp;&ldquo;172.16.206.28&nbsp;osb28&rdquo;&nbsp;>>&nbsp;/etc/hosts</div>
<div></div>
<div><strong>四：主服务器配置redis</strong></div>
<div>1．下载redis&nbsp;版本2.8.19</div>
<div>wget&nbsp;<a href="http://download.redis.io/releases/redis-2.8.19.tar.gz">http://download.redis.io/releases/redis-2.8.19.tar.gz</a></div>
<div>2．解压&nbsp;tar&nbsp;-zxvf&nbsp;redis-2.8.19.tar.gz</div>
<div>3．cd&nbsp;redis-2.8.19</div>
<div>4．make&nbsp;&amp;&amp;&nbsp;make&nbsp;install</div>
<div>5．cp&nbsp;redis.conf&nbsp;/etc/redis.conf</div>
<div>cd&nbsp;src/</div>
<div>cp&nbsp;redis-server&nbsp;redis-cli&nbsp;redis-benchmark&nbsp;redis-check-aofredis-check-dump&nbsp;/usr/local/bin</div>
<div>6．修改&nbsp;/etc/redis.conf里面可以把daemonize&nbsp;no&nbsp;修改为daemonize&nbsp;yes</div>
<div>目的是可以在后台执行redis-server。</div>
<div>7．init.d&nbsp;启动脚本</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;vi&nbsp;/etc/init.d/redis-server</div>
<div></div>
<div>#!/usr/bin/env&nbsp;bash</div>
<div>#</div>
<div>#&nbsp;redis&nbsp;start&nbsp;up&nbsp;the&nbsp;redis&nbsp;server&nbsp;daemon</div>
<div>#</div>
<div>#&nbsp;chkconfig:&nbsp;345&nbsp;99&nbsp;99</div>
<div>#&nbsp;description:&nbsp;redis&nbsp;service&nbsp;in&nbsp;/etc/init.d/redis</div>
<div>#&nbsp;chkconfig&nbsp;--add&nbsp;redis&nbsp;or&nbsp;chkconfig&nbsp;--list&nbsp;redis</div>
<div>#&nbsp;service&nbsp;redis&nbsp;start&nbsp;or&nbsp;service&nbsp;redis&nbsp;stop</div>
<div>#&nbsp;processname:&nbsp;redis-server</div>
<div>#&nbsp;config:&nbsp;/etc/redis.conf</div>
<div>PATH=/usr/local/bin:/sbin:/usr/bin:/bin</div>
<div>REDISPORT=6379</div>
<div>EXEC=/usr/local/bin/redis-server</div>
<div>REDIS_CLI=/usr/local/bin/redis-cli</div>
<div></div>
<div>PIDFILE=/var/run/redis.pid</div>
<div>CONF="/etc/redis.conf"</div>
<div>#make&nbsp;sure&nbsp;some&nbsp;dir&nbsp;exist</div>
<div>if&nbsp;[&nbsp;!&nbsp;-d&nbsp;/var/lib/redis&nbsp;]&nbsp;then</div>
<div>mkdir&nbsp;-p&nbsp;/var/lib/redis</div>
<div>mkdir&nbsp;-p&nbsp;/var/log/redis</div>
<div></div>
<div>fi</div>
<div></div>
<div>case&nbsp;"$1"&nbsp;in</div>
<div>status)</div>
<div>ps&nbsp;-A|grep&nbsp;redis</div>
<div>;;</div>
<div>start)</div>
<div>if&nbsp;[&nbsp;-f&nbsp;$PIDFILE&nbsp;]</div>
<div>then</div>
<div>echo&nbsp;"$PIDFILE&nbsp;exists,&nbsp;process&nbsp;is&nbsp;already&nbsp;running&nbsp;or&nbsp;crashed"</div>
<div>else</div>
<div>echo&nbsp;"Starting&nbsp;Redis&nbsp;server..."</div>
<div>$EXEC&nbsp;$CONF</div>
<div>fi</div>
<div>if&nbsp;[&nbsp;"$?"="0"&nbsp;]</div>
<div>then</div>
<div>echo&nbsp;"Redis&nbsp;is&nbsp;running..."</div>
<div>fi</div>
<div>;;</div>
<div>stop)</div>
<div>if&nbsp;[&nbsp;!&nbsp;-f&nbsp;$PIDFILE&nbsp;]</div>
<div>then</div>
<div>echo&nbsp;"$PIDFILE&nbsp;does&nbsp;not&nbsp;exist,&nbsp;process&nbsp;is&nbsp;not&nbsp;running"</div>
<div>else</div>
<div>PID=$(cat&nbsp;$PIDFILE)</div>
<div>echo&nbsp;"Stopping&nbsp;..."</div>
<div>$REDIS_CLI&nbsp;-p&nbsp;$REDISPORT&nbsp;SHUTDOWN</div>
<div>while&nbsp;[&nbsp;-x&nbsp;${PIDFILE}&nbsp;]</div>
<div>do</div>
<div>echo&nbsp;"Waiting&nbsp;for&nbsp;Redis&nbsp;to&nbsp;shutdown&nbsp;..."</div>
<div>sleep&nbsp;1</div>
<div>done</div>
<div>echo&nbsp;"Redis&nbsp;stopped"</div>
<div>fi</div>
<div>;;</div>
<div>restart|force-reload)</div>
<div>${0}&nbsp;stop</div>
<div>${0}&nbsp;start</div>
<div>;;</div>
<div>*)</div>
<div>echo&nbsp;"Usage:&nbsp;/etc/init.d/redis&nbsp;{start|stop|restart|force-reload}"&nbsp;>&amp;2</div>
<div>exit&nbsp;1</div>
<div></div>
<div>esac</div>
<div></div>
<div>执行：</div>
<div>$&nbsp;chmod&nbsp;o+x&nbsp;/etc/init.d/redis-server</div>
<div>$&nbsp;chkconfig&nbsp;&ndash;add&nbsp;redis-server</div>
<div>$&nbsp;service&nbsp;redis-server&nbsp;start</div>
<div></div>
<div><strong>五：从服务器配置redis</strong></div>
<div>从服务器，配置一样，只不过&nbsp;修改/etc/redis.conf&nbsp;中</div>
<div>slaveof&nbsp;<masterip>&nbsp;<masterport>修改为</div>
<div>slaveof&nbsp;172.16.206.28&nbsp;6379</div>
<div>然后开启从服务器的redis服务。</div>
<div>start&nbsp;redis-server&nbsp;start</div>
<div></div>
<div><strong>六：进行redis主从测试</strong></div>
<div>#主服务器</div>
<div>redis-cli&nbsp;-p&nbsp;6379&nbsp;set&nbsp;hello&nbsp;world</div>
<div>#从服务器</div>
<div>redis-cli&nbsp;-p&nbsp;6379&nbsp;get&nbsp;hello</div>
<div>&ldquo;world&rdquo;</div>
<div></div>
<div>#主服务器</div>
<div>redis-cli&nbsp;-p&nbsp;6379&nbsp;set&nbsp;hello2&nbsp;world2</div>
<div>#从服务器</div>
<div>redis-cli&nbsp;-p&nbsp;6379&nbsp;get&nbsp;hello2</div>
<div>&ldquo;world2&rdquo;</div>
<div>redis-cli&nbsp;-p&nbsp;6379&nbsp;set&nbsp;hello&nbsp;world</div>
<div>(error)&nbsp;READONLY&nbsp;You&nbsp;can&rsquo;t&nbsp;write&nbsp;against&nbsp;a&nbsp;read&nbsp;only&nbsp;slave.</div>
<div>成功配置主从redis服务器，由于配置中有一条从服务器是只读的，所以从服务器没法设置数据，只可以读取数据。</div>
<div></div>
<div><strong>七：安装和配置keepalived</strong></div>
<div>1．&nbsp;wget&nbsp;<a href="http://www.keepalived.org/software/keepalived-1.2.15.tar.gz">http://www.keepalived.org/software/keepalived-1.2.15.tar.gz</a></div>
<div>tar&nbsp;-zxvf&nbsp;keepalived-1.2.15.tar.gz</div>
<div>cd&nbsp;keepalived-1.2.15</div>
<div></div>
<div>2．&nbsp;&nbsp;安装openssl-devel和kernel-devel</div>
<div>yum&nbsp;install&nbsp;openssl-devel</div>
<div>yum&nbsp;install&nbsp;kernel-devel</div>
<div>ln&nbsp;-s&nbsp;/usr/src/kernels/2.6.32-431.el6.x86_64&nbsp;/usr/src/linux</div>
<div></div>
<div>3．&nbsp;配置编译安装</div>
<div>./configure&ndash;prefix=/usr/local/keepalived&nbsp;&nbsp;&ndash;with-kernel-dir=/usr/src/linux&nbsp;&nbsp;&nbsp;&ndash;enable-sha1</div>
<div>make&nbsp;&amp;&amp;&nbsp;make&nbsp;install</div>
<div></div>
<div>4．&nbsp;复制keepalived相关文件</div>
<div>cp&nbsp;/usr/local/keepalived/etc/sysconfig/keepalived&nbsp;/etc/sysconfig/keepalived</div>
<div>cp&nbsp;/usr/local/keepalived/sbin/keepalived&nbsp;/usr/sbin/keepalived</div>
<div>cp&nbsp;/usr/local/keepalived/etc/rc.d/init.d/keepalived&nbsp;/etc/init.d/keepalived</div>
<div>mkdir&nbsp;/etc/keepalived</div>
<div>cp&nbsp;/usr/local/keepalived/etc/keepalived/samples/keepalived.conf.virtualhost</div>
<div>/etc/keepalived/keepalived.conf</div>
<div></div>
<div><strong>八：修改配置文件和相关脚本</strong></div>
<div>1．&nbsp;在Master上创建配置文件keepalived.conf</div>
<div>vi&nbsp;/etc/keepalived/keepalived.conf</div>
<div></div>
<div>//////////////////////////////////////////////////</div>
<div>!&nbsp;Configuration&nbsp;File&nbsp;for&nbsp;keepalived</div>
<div></div>
<div>vrrp_script&nbsp;chk_redis&nbsp;{</div>
<div>&nbsp;&nbsp;script&nbsp;"/etc/keepalived/scripts/redis_check.sh"&nbsp;###监控脚本</div>
<div>&nbsp;&nbsp;interval&nbsp;2&nbsp;###监控时间</div>
<div>}</div>
<div></div>
<div>#网卡需要注意，使用ifconfig查看一下当前活动网卡</div>
<div></div>
<div>vrrp_instance&nbsp;VI_1&nbsp;{</div>
<div>&nbsp;&nbsp;state&nbsp;MASTER&nbsp;###设置为MASTER</div>
<div>&nbsp;&nbsp;interface&nbsp;eth0&nbsp;###监控网卡</div>
<div>&nbsp;&nbsp;virtual_router_id&nbsp;51</div>
<div>&nbsp;&nbsp;priority&nbsp;100&nbsp;###权重值</div>
<div>&nbsp;&nbsp;authentication&nbsp;{</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;auth_type&nbsp;PASS&nbsp;###加密</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;auth_pass&nbsp;1111&nbsp;###密码</div>
<div>&nbsp;&nbsp;}</div>
<div></div>
<div>&nbsp;&nbsp;track_script&nbsp;{</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;chk_redis&nbsp;###执行上面定义的chk_redis</div>
<div>&nbsp;&nbsp;}</div>
<div></div>
<div>&nbsp;&nbsp;virtual_ipaddress&nbsp;{</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;172.16.206.250&nbsp;######VIP</div>
<div>&nbsp;&nbsp;}</div>
<div></div>
<div>&nbsp;&nbsp;notify_master&nbsp;/etc/keepalived/scripts/redis_master.sh</div>
<div>&nbsp;&nbsp;notify_backup&nbsp;/etc/keepalived/scripts/redis_backup.sh</div>
<div>&nbsp;&nbsp;notify_fault&nbsp;/etc/keepalived/scripts/redis_fault.sh</div>
<div>&nbsp;&nbsp;notify_stop&nbsp;/etc/keepalived/scripts/redis_stop.sh</div>
<div>}</div>
<div></div>
<div>2．在Slave上创建配置文件keepalived.conf</div>
<div>vim&nbsp;/etc/keepalived/keepalived.conf</div>
<div></div>
<div>//////////////////////////////////////////////////</div>
<div>!&nbsp;Configuration&nbsp;File&nbsp;for&nbsp;keepalived</div>
<div></div>
<div>vrrp_script&nbsp;chk_redis&nbsp;{</div>
<div>&nbsp;&nbsp;script&nbsp;"/etc/keepalived/scripts/redis_check.sh"&nbsp;###监控脚本</div>
<div>&nbsp;&nbsp;interval&nbsp;2&nbsp;###监控时间</div>
<div>}</div>
<div></div>
<div>#同样要注意网卡</div>
<div>vrrp_instance&nbsp;VI_1&nbsp;{</div>
<div>&nbsp;&nbsp;state&nbsp;BACKUP&nbsp;###设置为BACKUP</div>
<div>&nbsp;&nbsp;interface&nbsp;eth0&nbsp;###监控网卡</div>
<div>&nbsp;&nbsp;virtual_router_id&nbsp;51</div>
<div>&nbsp;&nbsp;priority&nbsp;10&nbsp;###比MASTRE权重值低</div>
<div>&nbsp;&nbsp;authentication&nbsp;{</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;auth_type&nbsp;PASS</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;auth_pass&nbsp;1111&nbsp;###密码与MASTRE相同</div>
<div>&nbsp;&nbsp;}</div>
<div></div>
<div>&nbsp;&nbsp;track_script&nbsp;{</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;chk_redis&nbsp;###执行上面定义的chk_redis</div>
<div>&nbsp;&nbsp;}</div>
<div>&nbsp;&nbsp;virtual_ipaddress&nbsp;{</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;172.16.206.250&nbsp;####vip</div>
<div>&nbsp;&nbsp;}</div>
<div></div>
<div>&nbsp;&nbsp;notify_master&nbsp;/etc/keepalived/scripts/redis_master.sh</div>
<div>&nbsp;&nbsp;notify_backup&nbsp;/etc/keepalived/scripts/redis_backup.sh</div>
<div>&nbsp;&nbsp;notify_fault&nbsp;/etc/keepalived/scripts/redis_fault.sh</div>
<div>&nbsp;&nbsp;notify_stop&nbsp;/etc/keepalived/scripts/redis_stop.sh</div>
<div>}</div>
<div></div>
<div>3．在Master和Slave上创建监控Redis的脚本</div>
<div>$&nbsp;&nbsp;mkdir&nbsp;/etc/keepalived/scripts</div>
<div>$&nbsp;&nbsp;vim&nbsp;/etc/keepalived/scripts/redis_check.sh</div>
<div></div>
<div>#!/bin/bash</div>
<div>ALIVE=`/usr/local/bin/redis-cli&nbsp;-p&nbsp;6379&nbsp;-a&nbsp;password_of_redis&nbsp;PING`</div>
<div>if&nbsp;[&nbsp;"$ALIVE"&nbsp;==&nbsp;"PONG"&nbsp;];&nbsp;then</div>
<div>&nbsp;&nbsp;echo&nbsp;$ALIVE</div>
<div>&nbsp;&nbsp;exit&nbsp;0</div>
<div>else</div>
<div>&nbsp;&nbsp;echo&nbsp;$ALIVE</div>
<div>&nbsp;&nbsp;exit&nbsp;1</div>
<div>fi</div>
<div></div>
<div>4．编写关键脚本</div>
<div>notify_master&nbsp;/etc/keepalived/scripts/redis_master.sh</div>
<div>notify_backup&nbsp;/etc/keepalived/scripts/redis_backup.sh</div>
<div>notify_fault&nbsp;/etc/keepalived/scripts/redis_fault.sh</div>
<div>notify_stop&nbsp;/etc/keepalived/scripts/redis_stop.sh</div>
<div></div>
<div>Keepalived在转换状态时会依照状态来执行脚本：</div>
<ul>
<li>当进入Master状态时会呼叫&nbsp;notify_master</li>
<li>当进入Backup状态时会呼叫&nbsp;notify_backup</li>
<li>当发现异常情况时进入Fault状态呼叫&nbsp;notify_fault</li>
<li>当程序终止时则呼叫&nbsp;notify_stop</li>
</ul>
<div></div>
<div>4.1&nbsp;在Redis&nbsp;Master上创建notity_master与notify_backup脚本：</div>
<div>vi&nbsp;/etc/keepalived/scripts/redis_master.sh</div>
<div></div>
<div>#!/bin/bash</div>
<div>REDISCLI="/usr/local/bin/redis-cli"</div>
<div>LOGFILE="/var/log/keepalived-redis-state.log"</div>
<div>echo&nbsp;"[master]"&nbsp;>>&nbsp;$LOGFILE</div>
<div>date&nbsp;>>&nbsp;$LOGFILE</div>
<div>echo&nbsp;"Being&nbsp;master...."&nbsp;>>&nbsp;$LOGFILE&nbsp;2>&amp;1</div>
<div>echo&nbsp;"Run&nbsp;SLAVEOF&nbsp;cmd&nbsp;..."&nbsp;>>&nbsp;$LOGFILE</div>
<div>$REDISCLI&nbsp;SLAVEOF&nbsp;172.16.206.sl&nbsp;6379&nbsp;>>&nbsp;$LOGFILE&nbsp;2>&amp;1</div>
<div>sleep&nbsp;10&nbsp;#延迟10秒以后待数据同步完成后再取消同步状态</div>
<div></div>
<div>echo&nbsp;"Run&nbsp;SLAVEOF&nbsp;NO&nbsp;ONE&nbsp;cmd&nbsp;..."&nbsp;>>&nbsp;$LOGFILE</div>
<div>$REDISCLI&nbsp;SLAVEOF&nbsp;NO&nbsp;ONE&nbsp;>>&nbsp;$LOGFILE&nbsp;2>&amp;1</div>
<div></div>
<div></div>
<div>vi&nbsp;/etc/keepalived/scripts/redis_backup.sh</div>
<div></div>
<div>#!/bin/bash</div>
<div>REDISCLI="/usr/local/bin/redis-cli"</div>
<div>LOGFILE="/var/log/keepalived-redis-state.log"</div>
<div></div>
<div>echo&nbsp;"[backup]"&nbsp;>>&nbsp;$LOGFILE</div>
<div>date&nbsp;>>&nbsp;$LOGFILE</div>
<div>echo&nbsp;"Being&nbsp;slave...."&nbsp;>>&nbsp;$LOGFILE&nbsp;2>&amp;1</div>
<div></div>
<div>sleep&nbsp;15&nbsp;#延迟15秒待数据被对方同步完成之后再切换主从角色</div>
<div>echo&nbsp;"Run&nbsp;SLAVEOF&nbsp;cmd&nbsp;..."&nbsp;>>&nbsp;$LOGFILE</div>
<div>$REDISCLI&nbsp;SLAVEOF&nbsp;192.168.1.sl&nbsp;6379&nbsp;>>&nbsp;$LOGFILE&nbsp;2>&amp;1</div>
<div></div>
<div></div>
<div>4.2&nbsp;在Redis&nbsp;Slave上创建notity_master与notify_backup脚本：</div>
<div>vi&nbsp;/etc/keepalived/scripts/redis_master.sh</div>
<div></div>
<div>#!/bin/bash</div>
<div>REDISCLI="/usr/local/bin/redis-cli"</div>
<div>LOGFILE="/var/log/keepalived-redis-state.log"</div>
<div>echo&nbsp;"[master]"&nbsp;>>&nbsp;$LOGFILE</div>
<div>date&nbsp;>>&nbsp;$LOGFILE</div>
<div>echo&nbsp;"Being&nbsp;master...."&nbsp;>>&nbsp;$LOGFILE&nbsp;2>&amp;1</div>
<div></div>
<div>echo&nbsp;"Run&nbsp;SLAVEOF&nbsp;cmd&nbsp;..."&nbsp;>>&nbsp;$LOGFILE</div>
<div>$REDISCLI&nbsp;SLAVEOF&nbsp;192.168.1.ma&nbsp;6379&nbsp;>>&nbsp;$LOGFILE&nbsp;2>&amp;1</div>
<div>sleep&nbsp;10&nbsp;#延迟10秒以后待数据同步完成后再取消同步状态</div>
<div>echo&nbsp;"Run&nbsp;SLAVEOF&nbsp;NO&nbsp;ONE&nbsp;cmd&nbsp;..."&nbsp;>>&nbsp;$LOGFILE</div>
<div>$REDISCLI&nbsp;SLAVEOF&nbsp;NO&nbsp;ONE&nbsp;>>&nbsp;$LOGFILE&nbsp;2>&amp;1</div>
<div></div>
<div></div>
<div>vi&nbsp;/etc/keepalived/scripts/redis_backup.sh</div>
<div></div>
<div>#!/bin/bash</div>
<div></div>
<div>REDISCLI="/usr/local/bin/redis-cli"</div>
<div>LOGFILE="/var/log/keepalived-redis-state.log"</div>
<div>echo&nbsp;"[backup]"&nbsp;>>&nbsp;$LOGFILE</div>
<div>date&nbsp;>>&nbsp;$LOGFILE</div>
<div>echo&nbsp;"Being&nbsp;slave...."&nbsp;>>&nbsp;$LOGFILE&nbsp;2>&amp;1</div>
<div></div>
<div>sleep&nbsp;15&nbsp;#延迟15秒待数据被对方同步完成之后再切换主从角色</div>
<div>echo&nbsp;"Run&nbsp;SLAVEOF&nbsp;cmd&nbsp;..."&nbsp;>>&nbsp;$LOGFILE</div>
<div>$REDISCLI&nbsp;SLAVEOF&nbsp;192.168.1.4&nbsp;6379&nbsp;>>&nbsp;$LOGFILE&nbsp;2>&amp;1</div>
<div></div>
<div>4.3&nbsp;然后在Master与Slave创建如下相同的脚本：</div>
<div></div>
<div>vi&nbsp;/etc/keepalived/scripts/redis_fault.sh</div>
<div>#!/bin/bash</div>
<div>LOGFILE=/var/log/keepalived-redis-state.log</div>
<div>echo&nbsp;"[fault]"&nbsp;>>&nbsp;$LOGFILE</div>
<div>date&nbsp;>>&nbsp;$LOGFILE</div>
<div></div>
<div>vi&nbsp;/etc/keepalived/scripts/redis_stop.sh</div>
<div>#!/bin/bash</div>
<div>LOGFILE=/var/log/keepalived-redis-state.log</div>
<div>echo&nbsp;"[stop]"&nbsp;>>&nbsp;$LOGFILE</div>
<div>date&nbsp;>>&nbsp;$LOGFILE</div>
<div></div>
<div>4.4&nbsp;在主从服务器上面给脚本都加上可执行权限：</div>
<div>chmod&nbsp;+x&nbsp;/etc/keepalived/scripts/*.sh</div>
<div></div>
<div><strong>九：相关功能测试</strong></div>
<div>1.&nbsp;启动Master和slave上的Redis</div>
<div>service&nbsp;redis-server&nbsp;start</div>
<div></div>
<div>2.启动Master和slave上的Keepalived</div>
<div>/etc/init.d/keepalived&nbsp;start</div>
<div></div>
<div>3.尝试通过VIP连接Redis:</div>
<div>$&nbsp;redis-cli&nbsp;-h&nbsp;172.16.206.250&nbsp;-p&nbsp;6379&nbsp;-a&nbsp;password_of_redis&nbsp;INFO</div>
<div>连接成功，可以看到主从机的信息，例如：</div>
<div>role:master</div>
<div>slave0:172.16.206.28,6379,online</div>
<div></div>
<div>4.尝试插入一些数据：</div>
<div>$&nbsp;redis-cli&nbsp;-h&nbsp;172.16.206.250&nbsp;SET&nbsp;hello3&nbsp;world3</div>
<div>OK</div>
<div></div>
<div>从VIP读取数据</div>
<div>$&nbsp;redis-cli&nbsp;-h&nbsp;172.16.206.250&nbsp;GET&nbsp;hello3</div>
<div>&ldquo;world3&rdquo;</div>
<div></div>
<div>从Master读取数据</div>
<div>$&nbsp;redis-cli&nbsp;-h&nbsp;172.16.206.29&nbsp;GET&nbsp;hello3</div>
<div>&ldquo;world3&rdquo;</div>
<div></div>
<div>从Slave读取数据</div>
<div>$&nbsp;redis-cli&nbsp;-h&nbsp;172.16.206.28&nbsp;GET&nbsp;hello3</div>
<div>&ldquo;world3&rdquo;</div>
<div></div>
<div>5.将Master上的Redis进程杀死：</div>
<div>$&nbsp;service&nbsp;redis-server&nbsp;stop</div>
<div></div>
<div>查看Master上的Keepalived日志</div>
<div>$&nbsp;tail&nbsp;-f&nbsp;/var/log/keepalived-redis-state.log</div>
<div>[fault]</div>
<div>Mon&nbsp;Jan&nbsp;&nbsp;5&nbsp;14:06:22&nbsp;CST&nbsp;2015</div>
<div></div>
<div>同时Slave上的日志显示：</div>
<div>$&nbsp;tail&nbsp;-f&nbsp;/var/log/keepalived-redis-state.log</div>
<div>[master]</div>
<div>Mon&nbsp;Jan&nbsp;&nbsp;5&nbsp;14:13:52&nbsp;CST&nbsp;2015</div>
<div>Being&nbsp;master&hellip;.</div>
<div>Run&nbsp;SLAVEOF&nbsp;cmd&nbsp;&hellip;</div>
<div>OK&nbsp;Already&nbsp;connected&nbsp;to&nbsp;specified&nbsp;master</div>
<div>Run&nbsp;SLAVEOF&nbsp;NO&nbsp;ONE&nbsp;cmd&nbsp;&hellip;</div>
<div>OK</div>
<div></div>
<div>现在，Slave已经接管服务，并且拥有Master的角色</div>
<div>$&nbsp;redis-cli&nbsp;-h&nbsp;172.16.206.250&nbsp;INFO</div>
<div>$&nbsp;redis-cli&nbsp;-h&nbsp;172.16.206.28&nbsp;INFO</div>
<div>role:master</div>
<div></div>
<div>6.然后恢复Master的Redis进程</div>
<div>$&nbsp;&nbsp;service&nbsp;redis-server&nbsp;start</div>
<div></div>
<div>查看Master上的Keepalived日志</div>
<div>$&nbsp;tail&nbsp;-f&nbsp;/var/log/keepalived-redis-state.log</div>
<div></div>
<div>[master]</div>
<div>2015年&nbsp;01月&nbsp;05日&nbsp;星期一&nbsp;15:48:08&nbsp;CST</div>
<div>Being&nbsp;master&hellip;.</div>
<div>Run&nbsp;SLAVEOF&nbsp;cmd&nbsp;&hellip;</div>
<div>OK</div>
<div>Run&nbsp;SLAVEOF&nbsp;NO&nbsp;ONE&nbsp;cmd&nbsp;&hellip;</div>
<div>OK</div>
<div></div>
<div>同时Slave上的日志显示：</div>
<div>$&nbsp;tail&nbsp;-f&nbsp;/var/log/keepalived-redis-state.log</div>
<div>[backup]</div>
<div>Mon&nbsp;Jan&nbsp;&nbsp;5&nbsp;14:53:16&nbsp;CST&nbsp;2015</div>
<div>Being&nbsp;slave&hellip;.</div>
<div>Run&nbsp;SLAVEOF&nbsp;cmd&nbsp;&hellip;</div>
<div>OK</div>
<div></div>
<div>Master已经再次恢复了Master角色</div>
<div></div>
<div>摘自「http://abcve.com/redis-keepalived/」</div>