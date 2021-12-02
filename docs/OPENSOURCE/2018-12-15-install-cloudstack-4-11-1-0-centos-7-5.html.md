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
<h1 id="1-prepareration" data-source-line="1">1 Preparation</h1>
<h2 id="11-设置selinux" data-source-line="2">1.1 设置selinux</h2>
<pre data-source-line="4"><code class="hljs">sed -<span class="hljs-selector-tag">i</span> s#<span class="hljs-string">'SELINUX=enforcing'</span>#<span class="hljs-string">'SELINUX=permissive'</span><span class="hljs-selector-id">#g</span> /etc/selinux/config
setenforce <span class="hljs-number">0</span>
</code></pre>
<h2 id="12-安装ntp时间同步" data-source-line="9">1.2 安装NTP（时间同步）</h2>
<pre data-source-line="11"><code class="hljs">yum -y install<span class="hljs-built_in"> ntp
</span>systemctl <span class="hljs-builtin-name">enable</span> ntpd
</code></pre>
<h2 id="13-安装cloudstackrepo" data-source-line="16">1.3 安装cloudstack.repo</h2>
<pre data-source-line="18"><code class="hljs">cat <<EOF > /etc/yum.repos.d/cloudstack.repo
[cloudstack]
name=cloudstack
baseurl=http://cloudstack.apt-get.eu/centos/7/4.11/
enabled=1
gpgcheck=0

EOF
</code></pre>
<h2 id="14-设置防火墙" data-source-line="29">1.4 设置防火墙</h2>
<pre data-source-line="31"><code class="hljs">firewall-<span class="hljs-keyword">cmd</span><span class="bash"> --permanent --add-port=111/tcp
</span>firewall-<span class="hljs-keyword">cmd</span><span class="bash"> --permanent --add-port=111/udp
</span>firewall-<span class="hljs-keyword">cmd</span><span class="bash"> --permanent --add-port=2049/tcp
</span>firewall-<span class="hljs-keyword">cmd</span><span class="bash"> --permanent --add-port=32803/tcp
</span>firewall-<span class="hljs-keyword">cmd</span><span class="bash"> --permanent --add-port=32769/udp
</span>firewall-<span class="hljs-keyword">cmd</span><span class="bash"> --permanent --add-port=892/tcp
</span>firewall-<span class="hljs-keyword">cmd</span><span class="bash"> --permanent --add-port=892/udp
</span>firewall-<span class="hljs-keyword">cmd</span><span class="bash"> --permanent --add-port=875/tcp
</span>firewall-<span class="hljs-keyword">cmd</span><span class="bash"> --permanent --add-port=875/udp
</span>firewall-<span class="hljs-keyword">cmd</span><span class="bash"> --permanent --add-port=662/tcp
</span>firewall-<span class="hljs-keyword">cmd</span><span class="bash"> --permanent --add-port=662/udp
</span>firewall-<span class="hljs-keyword">cmd</span><span class="bash"> --permanent --add-port=8080/tcp
</span>firewall-<span class="hljs-keyword">cmd</span><span class="bash"> --reload
</span>firewall-<span class="hljs-keyword">cmd</span><span class="bash"> --list-all
</span></code></pre>
<h1 id="2-installation" data-source-line="48">2 Installation</h1>
<h2 id="21-安装cloudstack-management" data-source-line="49">2.1 安装cloudstack-management</h2>
<pre data-source-line="51"><code class="hljs">yum -y <span class="hljs-keyword">install </span><span class="hljs-keyword">cloudstack-management </span>
</code></pre>
<h2 id="22-安装mariadb" data-source-line="55">2.2 安装MariaDB</h2>
<h3 id="221-install-config-mariadb" data-source-line="57">2.2.1 Install &amp; config mariadb</h3>
<pre data-source-line="58"><code class="hljs">yum <span class="hljs-keyword">install</span> mariadb mariadb-<span class="hljs-keyword">server</span> 
vi /etc/my.cnf 
[mysqld]
innodb_rollback_on_timeout=<span class="hljs-number">1</span>
innodb_lock_wait_timeout=<span class="hljs-number">600</span>
max_connections=<span class="hljs-number">350</span>
<span class="hljs-keyword">log</span>-<span class="hljs-keyword">bin</span>=mysql-<span class="hljs-keyword">bin</span>
<span class="hljs-keyword">binlog</span>-<span class="hljs-keyword">format</span> = <span class="hljs-string">'ROW'</span>
</code></pre>
<h3 id="222-创建data目录" data-source-line="69">2.2.2 创建data目录</h3>
<pre data-source-line="71"><code class="hljs">[root@panda <span class="hljs-class"><span class="hljs-keyword">lib</span>]<span class="hljs-comment"># mkdir -p /data/lib/mysql</span></span>
[root@panda <span class="hljs-class"><span class="hljs-keyword">lib</span>]<span class="hljs-comment"># chown mysql:mysql /data/lib/mysql/</span></span>
[root@panda <span class="hljs-class"><span class="hljs-keyword">lib</span>]<span class="hljs-comment"># rmdir /var/lib/mysql/</span></span>
[root@panda <span class="hljs-class"><span class="hljs-keyword">lib</span>]<span class="hljs-comment"># cd /var/lib &amp;&amp; ln -s /data/lib/mysql/ .</span></span>
</code></pre>
<h3 id="223-启动数据库并设置为开机启动" data-source-line="78">2.2.3 启动数据库并设置为开机启动</h3>
<pre data-source-line="80"><code class="hljs">systemctl start mariadb      <span class="hljs-comment">#<span class="zh-hans">启动数据库</span></span>
systemctl <span class="hljs-built_in">enable</span> mariadb     <span class="hljs-comment">#<span class="zh-hans">开机自启动</span></span>
</code></pre>
<h3 id="224-初始化数据库" data-source-line="85">2.2.4 初始化数据库</h3>
<pre data-source-line="87"><code class="hljs"><span class="hljs-attribute">mysql_secure_installation</span>              
<span class="hljs-comment">#<span class="zh-hans">设置密码然后一路</span>yyyy <span class="zh-hans">（</span>yes<span class="zh-hans">）</span></span>
</code></pre>
<h2 id="23-使用cloudstack-setup-databases初始化cloudstack数据库" data-source-line="92">2.3 使用cloudstack-setup-databases初始化CloudStack数据库</h2>
<pre data-source-line="94"><code class="hljs">cloudstack-setup-databases cloud:cloud@localhost --deploy-as=root:<span class="hljs-number">123456</span> -i <span class="hljs-number">192.168</span><span class="hljs-meta">.10</span><span class="hljs-meta">.3</span> 
# <span class="hljs-number">192.168</span><span class="hljs-meta">.10</span><span class="hljs-meta">.3</span><span class="zh-hans">是当前系统的本地</span><span class="hljs-built_in">ip</span>
# <span class="zh-hans">重置数据库密码</span><span class="hljs-number">123456</span>
</code></pre>
<h2 id="24-安装management服务器" data-source-line="100">2.4 安装management服务器</h2>
<pre data-source-line="102"><code class="hljs">cloudstack-setup-management 
# The --tomcat7 <span class="hljs-keyword">option</span> <span class="hljs-keyword">is</span> deprecated, CloudStack <span class="hljs-built_in">now</span> uses embedded Jetty <span class="hljs-built_in">server</span>.
</code></pre>
<h3 id="启动cloudstack" data-source-line="107">启动cloudstack</h3>
<pre data-source-line="109"><code class="hljs">systemctl <span class="hljs-keyword">start</span> cloudstack-<span class="hljs-keyword">management</span>
</code></pre>
<h2 id="25-安装与配置nfs存储" data-source-line="113">2.5 安装与配置NFS存储</h2>
<pre data-source-line="115"><code class="hljs">yum -y <span class="hljs-keyword">install</span> nfs-utils rpcbind
</code></pre>
<h3 id="251-配置域名" data-source-line="120">2.5.1 配置域名</h3>
<pre data-source-line="121"><code class="hljs">vi /etc/idmapd<span class="hljs-selector-class">.conf</span>
Domain = echoyun<span class="hljs-selector-class">.edu</span>
</code></pre>
<h3 id="252-准备nfs目录" data-source-line="126">2.5.2 准备NFS目录</h3>
<pre data-source-line="127"><code class="hljs"><span class="hljs-title">mkdir</span> -p /<span class="hljs-class"><span class="hljs-keyword">data</span>/cloudstack/{<span class="hljs-title">primary</span>,<span class="hljs-title">secondary</span>}</span>
</code></pre>
<h3 id="253-修改nfs服务参数" data-source-line="131">2.5.3 修改NFS服务参数</h3>
<pre data-source-line="132"><code class="hljs"><span class="hljs-comment"># vim /etc/sysconfig/nfs</span>
<span class="hljs-attr">MOUNTD_PORT</span>=<span class="hljs-number">892</span>
<span class="hljs-attr">STATD_PORT</span>=<span class="hljs-number">662</span>
<span class="hljs-attr">STATD_OUTGOING_PORT</span>=<span class="hljs-number">2020</span>
</code></pre>
<pre data-source-line="139"><code class="hljs"><span class="hljs-comment"># vim /etc/modprobe.d/lockd.conf </span>
options lockd <span class="hljs-attribute">nlm_tcpport</span>=32803
options lockd <span class="hljs-attribute">nlm_udpport</span>=32769
</code></pre>
<h3 id="254-配置exports" data-source-line="145">2.5.4 配置exports</h3>
<pre data-source-line="146"><code class="hljs"><span class="hljs-title">vim</span> /etc/exports
/<span class="hljs-class"><span class="hljs-keyword">data</span>/cloudstack/primary *(<span class="hljs-title">rw</span>,<span class="hljs-title">async</span>,<span class="hljs-title">no_root_squash</span>,<span class="hljs-title">no_subtree_check</span>)</span>
/<span class="hljs-class"><span class="hljs-keyword">data</span>/cloudstack/secondary *(<span class="hljs-title">rw</span>,<span class="hljs-title">async</span>,<span class="hljs-title">no_root_squash</span>,<span class="hljs-title">no_subtree_check</span>)</span>
</code></pre>
<h3 id="255-设置nfs挂载" data-source-line="152">2.5.5 设置nfs挂载</h3>
<pre data-source-line="153"><code class="hljs">vim /etc/nfsmount.conf
Nfsvers=4
</code></pre>
<h3 id="256-启动nfs和rpcbind" data-source-line="158">2.5.6 启动nfs和rpcbind</h3>
<pre data-source-line="160"><code class="hljs">systemctl <span class="hljs-builtin-name">enable</span> rpcbind
systemctl <span class="hljs-builtin-name">enable</span> nfs-server
systemctl start rpcbind
systemctl start nfs-server
</code></pre>
<h3 id="257-测试挂载" data-source-line="168">2.5.7 测试挂载</h3>
<pre data-source-line="170"><code class="hljs">mount -t nfs <span class="hljs-number">192.168</span>.<span class="hljs-number">10.3</span><span class="hljs-symbol">:/data/cloudstack/primary</span> /mnt
df -h    <span class="hljs-comment">#<span class="zh-hans">查看有了代表成功</span></span>
umount /mnt
</code></pre>
<h2 id="26-下载系统vm模板" data-source-line="176">2.6 下载系统VM模板</h2>
<pre data-source-line="177"><code class="hljs"><span class="hljs-regexp">/usr/</span>share<span class="hljs-regexp">/cloudstack-common/</span>scripts<span class="hljs-regexp">/storage/</span>secondary<span class="hljs-regexp">/cloud-install-sys-tmplt -m /</span>data<span class="hljs-regexp">/cloudstack/</span>secondary -u <span class="hljs-string">http:</span><span class="hljs-comment">//cloudstack.apt-get.eu/systemvm/4.11/systemvmtemplate-4.11.1-kvm.qcow2.bz2 -h kvm -F</span>
</code></pre>
<h2 id="27-安装agentcloudstack主机" data-source-line="181">2.7 安装agent（cloudstack主机）</h2>
<p data-source-line="183">如果部署集群，备机只需要直接部署agent.</p>
<pre data-source-line="185"><code class="hljs">yum -y <span class="hljs-keyword">install </span><span class="hljs-keyword">cloudstack-agent
</span></code></pre>
<h3 id="271-配置文件修改" data-source-line="190">2.7.1 配置文件修改</h3>
<pre data-source-line="191"><code class="hljs"><span class="hljs-comment"># vi /etc/libvirt/qemu.conf  <span class="zh-hans">并取消如下行的注释</span></span>
<span class="hljs-attr">vnc_listen</span>=<span class="hljs-number">0.0</span>.<span class="hljs-number">0.0</span>
</code></pre>
<h3 id="272-配置kvm" data-source-line="196">2.7.2 配置KVM</h3>
<pre data-source-line="198"><code class="hljs"><span class="hljs-comment"># vi /etc/libvirt/libvirtd.conf</span>
<span class="hljs-attr">listen_tls</span> = <span class="hljs-number">0</span>
<span class="hljs-attr">listen_tcp</span> = <span class="hljs-number">1</span>
<span class="hljs-attr">tcp_port</span> = <span class="hljs-string">"16059"</span>
<span class="hljs-attr">auth_tcp</span> = <span class="hljs-string">"none"</span>
<span class="hljs-attr">mdns_adv</span> = <span class="hljs-number">0</span>
</code></pre>
<pre data-source-line="207"><code class="hljs"><span class="hljs-comment"># vi /etc/sysconfig/libvirtd</span>
<span class="hljs-attribute">LIBVIRTD_ARGS</span>=<span class="hljs-string">"--listen"</span>

systemctl restart libvirtd
systemctl <span class="hljs-builtin-name">enable</span> libvirtd
</code></pre>
<h3 id="273-配置agent" data-source-line="215">2.7.3 配置agent</h3>
<pre data-source-line="217"><code class="hljs">vi /etc/cloudstack/agent/agent.properties
host=<span class="hljs-number">192.168</span><span class="hljs-number">.10</span><span class="hljs-number">.3</span>
</code></pre>
<h3 id="274-配置网卡做桥接" data-source-line="223">2.7.4 配置网卡（做桥接）</h3>
<p data-source-line="225">网卡1</p>
<pre data-source-line="227"><code class="hljs">vi /etc/sysconfig/network-scripts/ifcfg-em1 

<span class="hljs-comment">#<span class="zh-hans">编辑第一块网卡</span> <span class="zh-hans">是什么就编辑什么</span> <span class="zh-hans">我这叫</span>em1</span>
TYPE=Ethernet
DEVICE=em1
ONBOOT=yes
BRIDGE=cloudbr0
</code></pre>
<p data-source-line="237">网卡桥接（名字也可以自定义，要和里边配置对应上）</p>
<pre data-source-line="240"><code class="hljs">cat <<EOF > /etc/sysconfig/network-scripts/ifcfg-cloudbr0
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
EOF
</code></pre>
<pre data-source-line="255"><code class="hljs">[root@panda <span class="hljs-class"><span class="hljs-keyword">lib</span>]<span class="hljs-comment"># cat /etc/sysconfig/network</span></span>
<span class="hljs-comment"># Created by anaconda</span>
GATEWAY=<span class="hljs-number">192.168</span>.<span class="hljs-number">10.1</span>
</code></pre>
<h3 id="275-初始化cloudstack-agent" data-source-line="261">2.7.5 初始化cloudstack-agent</h3>
<pre data-source-line="262"><code class="hljs">cloudstack-setup-agent    #<span class="zh-hans">一路回车</span>
[root@panda ~]# cloudstack-setup-agent
Welcome <span class="hljs-keyword">to</span> the CloudStack Agent Setup:
Please input the Management<span class="hljs-built_in"> Server </span>Hostname/IP-Address:[192.168.10.3]
Please input the Zone Id:[default]
Please input the Pod Id:[default]
Please input the Cluster Id:[default]
Please input the Hypervisor<span class="hljs-built_in"> type </span>kvm/lxc:[kvm]
Please choose which<span class="hljs-built_in"> network </span>used <span class="hljs-keyword">to</span> create VM:[cloudbr0]
Starting <span class="hljs-keyword">to</span> configure your system:
Configure SElinux <span class="hljs-built_in">..</span>.         [OK]
Configure<span class="hljs-built_in"> Network </span><span class="hljs-built_in">..</span>.         [OK]
Configure Libvirt <span class="hljs-built_in">..</span>.         [OK]
Configure<span class="hljs-built_in"> Firewall </span><span class="hljs-built_in">..</span>.        [OK]
Configure Nfs <span class="hljs-built_in">..</span>.             [OK]
Configure cloudAgent <span class="hljs-built_in">..</span>.      [OK]
CloudStack Agent setup is done!
</code></pre>
<pre data-source-line="282"><code class="hljs">systemctl <span class="hljs-built_in">restart</span> cloudstack-agent
systemctl <span class="hljs-built_in">restart</span> libvirtd
</code></pre>
<h1 id="3-下一步" data-source-line="287">3 下一步</h1>
<p data-source-line="288">查看8080端口是否启动</p>
<pre data-source-line="290"><code class="hljs">netstat -tunlp<span class="hljs-string">|grep 8080</span>
</code></pre>
<p data-source-line="294">打开浏览器，进行下一步配置</p>
<p data-source-line="296"><a href="http://192.168.10.3:8080/client/" target="_blank" rel="noopener">http://192.168.10.3:8080/client/</a>&nbsp;账号admin 密码password</p>
<h1 id="reference" data-source-line="299">Reference</h1>
<p data-source-line="300"><a href="http://www.jackfan.top/posts/47209/" target="_blank" rel="noopener">http://www.jackfan.top/posts/47209/</a></p>
<p><audio style="display: none;" controls="controls"></audio></p>
<p><audio style="display: none;" controls="controls"></audio></p>
