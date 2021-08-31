---
layout: post
title:  "Install Haproxy v1.8 and Keepalived on CentOS 7"
date:   2021-08-24 10:17:00 +0800
categories: Opensource
tags:
- Haproxy
- Keepalived
- centos
---

# 1. Preparation

## 1.1 KVMs


*2 KVMs*

Hostname       | vCPUs | Memory | Swap | IP             | OS       | sudoer 
---------------|-------|--------|------|----------------|----------|-------
*slb01*.k8s    | 2     | 2G     | 0    | 192.168.10.201 | CentOS 7 | echo  
*slb02*.k8s    | 2     | 2G     | 0    | 192.168.10.202 | CentOS 7 | echo  
*cluster*.k8s  | -     | -      | -    | 192.168.10.200 | -        | -  

*NOTE: 192.168.10.200 is a virtual (HA) IP which points to slb01 or slb02.*

## 1.2 Install Ansible on Host machine

```sh
# Install ansible on host machine
sudo yum install ansible
```

## 1.3 Password free Configuration

```sh
cat <<EOF | sudo tee -a /etc/ansible/hosts
[slb]
slb01.k8s
slb02.k8s
EOF

# Have a test 
ansible slb --ask-pass -u echo -m shell -a 'echo ok'

# Password free for login
ansible slb --ask-pass -u echo -m file -a "path=.ssh state=directory mode=700"
ansible slb --ask-pass -u echo -m copy -a "src=~/.ssh/id_rsa.pub dest=.ssh/authorized_keys mode=600"

# Password free for sudo
ansible slb --ask-pass -u echo -b -m shell -a "echo 'echo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"

# Now we can have a test as below
ansible slb -u echo -m shell -a 'echo ok'
```

## 1.4 DNS via hosts file

```sh
cat <<EOF > /tmp/add-hosts.sh
cat <<EEE >> /etc/hosts 
192.168.10.201 slb01.k8s
192.168.10.202 slb02.k8s

# A virtual IP which points slb01 or slb02
192.168.10.200 cluster.k8s
EEE
EOF

ansible k8s -u echo -b -m script -a "/tmp/add-hosts.sh"
```

# 2. Basic Configurations for servers

## 2.1 Required ports (Firewall Configuration)

```sh
ansible slb -u echo -b -m shell -a "firewall-cmd --permanent --add-port=80/tcp --add-port=443/tcp --add-port=8081/tcp"
ansible slb -u echo -b -m shell -a "firewall-cmd --reload"
```

## 2.2 Set SELinux in permissive mode (effectively disabling it)

```sh
cat <<EOF > /tmp/set-selinux.sh
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
EOF

ansible slb -u echo -b -m script -a '/tmp/set-selinux.sh'
```

# 3. Install HAProxy + Keepalived on SLB servers

## 3.1 Install HAProxy

```sh
cat <<EOF > /tmp/install-haproxy.sh
sudo yum install centos-release-scl -y
sudo yum install rh-haproxy18 -y
sudo scl enable rh-haproxy18 bash -y
sudo systemctl enable rh-haproxy18-haproxy
sudo systemctl start rh-haproxy18-haproxy
EOF

ansible slb -u echo -b -m script -a "/tmp/install-haproxy.sh"
```

## 3.2 Install Keepalived

```sh
ansible slb -u echo -b -m shell -a "yum install -y keepalived"
```

# 4. Configuraton Example

## 4.1 Self-signed Cert

```sh
# e.g.
openssl req -newkey rsa:2048 -nodes -sha256 -keyout example.key \
  -x509 -days 3650 -out example.crt \
  -subj "/CN=example.com"
cat example.crt example.key > example.pem
```

## 4.2 Example of haproxy.cfg

*/etc/opt/rh/rh-haproxy18/haproxy/haproxy.cfg*

```sh
cat <<EOF > /tmp/haproxy.cfg
#---------------------------------------------------------------------
# Example configuration for a possible web application.  See the
# full configuration options online.
#
#   http://haproxy.1wt.eu/download/1.8/doc/configuration.txt
#
#---------------------------------------------------------------------

#---------------------------------------------------------------------
# Global settings
#---------------------------------------------------------------------
global
    # to have these messages end up in /var/opt/rh/rh-haproxy18/log/haproxy.log you will
    # need to:
    #
    # 1) configure syslog to accept network log events.  This is done
    #    by adding the '-r' option to the SYSLOGD_OPTIONS in
    #    /etc/sysconfig/syslog
    #
    # 2) configure local2 events to go to the /var/opt/rh/rh-haproxy18/log/haproxy.log
    #   file. A line like the following can be added to
    #   /etc/sysconfig/syslog
    #
    #    local2.*                       /var/opt/rh/rh-haproxy18/log/haproxy.log
    #
    log         127.0.0.1 local2

    chroot      /var/opt/rh/rh-haproxy18/lib/haproxy
    pidfile     /var/run/rh-haproxy18-haproxy.pid
    maxconn     4000
    user        haproxy
    group       haproxy
    daemon

    # turn on stats unix socket
    stats socket /var/opt/rh/rh-haproxy18/lib/haproxy/stats

    # utilize system-wide crypto-policies
    #ssl-default-bind-ciphers PROFILE=SYSTEM
    #ssl-default-server-ciphers PROFILE=SYSTEM

#---------------------------------------------------------------------
# common defaults that all the 'listen' and 'backend' sections will
# use if not designated in their block
#---------------------------------------------------------------------
defaults
    mode                    http
    log                     global
    #option                  httplog
    option                  dontlognull
    option http-server-close
    #option forwardfor       except 127.0.0.0/8
    option                  redispatch
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    timeout http-keep-alive 10s
    timeout check           10s
    maxconn                 3000

#---------------------------------------------------------------------
# main frontend which proxys to the backends
#---------------------------------------------------------------------
frontend main
    #bind *:80
    bind *:443 ssl crt /etc/ssl/certs/example.pem 
    acl url_static       path_beg       -i /static /images /javascript /stylesheets
    acl url_static       path_end       -i .jpg .gif .png .css .js

    #use_backend static          if url_static
    default_backend            static

    #acl root_path path_reg ^/$

#---------------------------------------------------------------------
# static backend for serving up images, stylesheets and such
#---------------------------------------------------------------------
backend static
    balance     roundrobin
    server      static 127.0.0.1:4331 check

#---------------------------------------------------------------------
# round robin balancing between the various backends
#---------------------------------------------------------------------
# listen k8sapi
    # bind *:6443
    # mode tcp
    # balance roundrobin
    # option  tcp-check
    # server  master01 master01.k8s:6443 check
    # server  master02 master02.k8s:6443 check
    # server  master03 master03.k8s:6443 check

#---------------------------------------------------------------------
# HAProxy Monitoring Config
#---------------------------------------------------------------------
listen monitoring
    bind *:8081                #Haproxy Monitoring run on port 8081    
    mode http
    option forwardfor
    option httpclose
    stats enable
    stats show-legends
    stats refresh 5s
    stats uri /stats           #URL for HAProxy monitoring
    #stats realm Haproxy Statistics
    stats auth howtoforge:howtoforge        
    stats admin if TRUE
EOF

ansible slb -u echo -b -m copy -a \
 "src=/tmp/haproxy.cfg 
  dest=/etc/opt/rh/rh-haproxy18/haproxy/haproxy.cfg 
  mode=600 owner=haproxy group=haproxy"

ansible slb -u echo -b -m copy -a \
 "src=example.pem 
  dest=/etc/ssl/certs/example.pem
  mode=600 owner=haproxy group=haproxy"

ansible slb -u echo -b -m shell -a "systemctl restart rh-haproxy18-haproxy"
```

## 4.3 Example of keepalived.conf

*/etc/keepalived/keepalived.conf*

```sh
cat <<EOF> /tmp/keepalived.conf
global_defs {
   notification_email {
     admin@example.k8s
   }
   notification_email_from noreply1@example.k8s
   smtp_server localhost
   smtp_connect_timeout 30
}

vrrp_script chk_haproxy {
  script "pkill -0 haproxy" # check the haproxy process
  interval 2 # every 2 seconds
  weight 2 # add 2 points if OK
}

vrrp_instance VI_1 {
  interface eth0 # interface to monitor
  state MASTER # MASTER on slb01, BACKUP on slb02
  virtual_router_id 51
  priority 100 # 100 on slb01, 99 on slb02

  #IP Address of local machine. 
  #NOTE: this is mandatory if multicast is forbidden in your network  
  unicast_src_ip 192.168.122.201
  unicast_peer {
    #IP Address of other machine(s). 
    #NOTE1: this is mandatory if multicast is forbidden in your network. 
    #NOTE2: multiple values can be issued here
    192.168.122.202
  }

  authentication {
    auth_type PASS
    auth_pass 1849
  }
  virtual_ipaddress {
    192.168.10.200/24 # virtual ip address
  }
  track_script {
    chk_haproxy
  }
}
EOF


ansible slb -u echo -b -m copy -a \
 "src=/tmp/keepalived.conf 
  dest=/etc/keepalived/keepalived.conf
  mode=644"
```

*Edit keepalived.conf on slb02.k8s*

```sh
# On slb02.k8s:
#   state BACKUP 
#   priority 99
#   unicast_src_ip 192.168.122.202
#   unicast_peer {
#     192.168.122.201 
#   }
vi /etc/keepalived/keepalived.conf
```

*Enable & Restart keepalived*

```sh
ansible echoyun-slb -u echo -b -m shell -a "systemctl enable keepalived"
ansible echoyun-slb -u echo -b -m shell -a "systemctl restart keepalived"
```

# 5. Access HAProxy stats page

*Now we can open HAProxy stats page in Browser*

```sh
# auth: howtoforge:howtoforge
http://cluster.k8s:8081/stats/
```

# Reference

* [ansible/2.9/modules/list_of_commands_modules.html](https://docs.ansible.com/ansible/2.9/modules/list_of_commands_modules.html)
* [ansible/2.9/modules/copy_module.html](https://docs.ansible.com/ansible/2.9/modules/copy_module.html)
* [lists.centos.org/pipermail/centos-announce/2018-June/022915.html](https://lists.centos.org/pipermail/centos-announce/2018-June/022915.html)
* [thingsboard.io/docs/user-guide/install/pe/add-haproxy-rhel](https://thingsboard.io/docs/user-guide/install/pe/add-haproxy-rhel/)
* [howtoforge.com/tutorial/how-to-setup-haproxy-as-load-balancer-for-nginx-on-centos-7](https://www.howtoforge.com/tutorial/how-to-setup-haproxy-as-load-balancer-for-nginx-on-centos-7/)
* [red_hat_enterprise_linux/7/html/load_balancer_administration/keepalived_install_example1](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/load_balancer_administration/keepalived_install_example1)
* [red_hat_enterprise_linux/7/html/load_balancer_administration/ch-initial-setup-VSA](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/load_balancer_administration/ch-initial-setup-VSA)
* [KeepAlived configuration for automatic switch of virtual IP](https://gist.github.com/gasgasalterego/0bb06963f069417058d999994c794a61)