---
layout: post
title:  "Getting started with docker swarm mode"
date:   2021-11-09 17:26:00 +0800
categories: Opensource
tags:
- docker
- swarm
- cloudnative
description: 
---

# 1. Preparation

## 1.1 KVMs

*3 KVMs*

Hostname       | vCPUs | Memory | Swap | IP              | OS       | sudoer 
---------------|-------|--------|------|-----------------|----------|-------
*minion01*.k8s | 2     | 8G     | 0    | 192.168.122.101 | CentOS 7 | echo  
*minion02*.k8s | 2     | 8G     | 0    | 192.168.122.102 | CentOS 7 | echo  
*minion03*.k8s | 2     | 8G     | 0    | 192.168.122.103 | CentOS 7 | echo  


## 1.2 Install Ansible on Host machine

```sh
# Install ansible on host machine
sudo yum install ansible
```

## 1.3 Password free configuration

```sh
cat <<EOF | sudo tee -a /etc/ansible/hosts
[swarm-nodes]
minion01.k8s
minion02.k8s
minion03.k8s
EOF

# Have a test 
ansible swarm-nodes --ask-pass -u echo -m shell -a 'echo ok'

# Password free for login
ansible swarm-nodes --ask-pass -u echo -m file -a "path=.ssh state=directory mode=700"
ansible swarm-nodes --ask-pass -u echo -m copy -a "src=~/.ssh/id_rsa.pub dest=.ssh/authorized_keys mode=600"

# Password free for sudo
ansible swarm-nodes --ask-pass -u echo -b -m shell -a "echo 'echo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"

# Now we can have a test as below
ansible swarm-nodes -u echo -m shell -a 'echo ok'
```

## 1.4 DNS via hosts file

```sh
cat <<EOF > /tmp/add-hosts.sh
cat <<EEE >> /etc/hosts 
192.168.122.101 minion01.k8s
192.168.122.102 minion02.k8s
192.168.122.103 minion03.k8s
EEE
EOF

ansible swarm-nodes -u echo -b -m script -a "/tmp/add-hosts.sh"
```

# 2. Open protocols and ports between the hosts

The following ports must be available. On some systems, these ports are open by default.

- TCP port 2377 for cluster management communications
- TCP and UDP port 7946 for communication among nodes
- UDP port 4789 for overlay network traffic

If you plan on creating an overlay network with encryption (--opt encrypted), you also need to ensure ip protocol 50 (ESP) traffic is allowed

```sh
cat <<EOF > /tmp/required-ports.sh
firewall-cmd --permanent --add-port=2377/tcp
firewall-cmd --permanent --add-port=7946/tcp --add-port=7946/udp
firewall-cmd --permanent --add-port=4789/udp
# NOTE: published ports (for demo use)
firewall-cmd --permanent --add-port=30000-32767/tcp
firewall-cmd --reload
EOF

ansible swarm-nodes -u echo -b -m script -a '/tmp/required-ports.sh'
```

# 3. Install docker-ce as the container runtime

## 3.1 Install container-selinux

```sh
ansible swarm-nodes -u echo -m shell -a \
'sudo yum --enablerepo=extras install -y container-selinux'
```

## 3.2 Check docker-ce version

```sh
yum --showduplicates list docker-ce
```

## 3.3 Install docker-ce

*NOTE: Use your mirror of dockerhub*

```sh
cat <<EEE > /tmp/install-docker.sh
# Install Docker CE 18.06 from Docker's CentOS repositories:

## Install prerequisites.
yum -y install yum-utils device-mapper-persistent-data lvm2

## Add docker repository.
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

## Install docker.
yum -y install docker-ce-18.06.1.ce-3.el7
systemctl enable docker

# Setup daemon.
mkdir -p /etc/docker/
cat > /etc/docker/daemon.json <<EOF
{
  # NOTE: Use your mirror of dockerhub
  "registry-mirrors": ["https://z7sy3gme.mirror.aliyuncs.com"],
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl restart docker
EEE

ansible swarm-nodes -u echo -b -m script -a '/tmp/install-docker.sh'
```

# 4 Getting started with swarm mode

*[Swarm mode overview](https://docs.docker.com/engine/swarm/)*

*[Swarm mode key concepts](https://docs.docker.com/engine/swarm/key-concepts/)*

## 4.1 Create a new swarm 

*On minon01.k8s:*

```sh
$ sudo docker swarm init --advertise-addr 192.168.122.101
Swarm initialized: current node (3zvaz0q6iz91oe92zsfn79rl9) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-1vf3r7evq3f28kl0jmki57xdo6yfnwpnivyee53y1otjemeu5u-3mrpqzlbdyjiwgqehsjff5cfy 192.168.122.101:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

*On minon02.k8s, minon03.k8s:*

```sh
$ sudo docker swarm join --token SWMTKN-1-1vf3r7evq3f28kl0jmki57xdo6yfnwpnivyee53y1otjemeu5u-3mrpqzlbdyjiwgqehsjff5cfy 192.168.122.101:2377
This node joined a swarm as a worker.
```

### 4.1.1 View the current state of the swarm

```sh
[echo@minion01 ~]$ sudo docker info
... ...
Server Version: 18.06.1-ce
Storage Driver: overlay2
 Backing Filesystem: xfs
 Supports d_type: true
 Native Overlay Diff: true
Logging Driver: json-file
Cgroup Driver: systemd
Plugins:
 Volume: local
 Network: bridge host macvlan null overlay
 Log: awslogs fluentd gcplogs gelf journald json-file logentries splunk syslog
Swarm: active
 NodeID: 3zvaz0q6iz91oe92zsfn79rl9
 Is Manager: true
 ClusterID: 9yfajds9vesoci8h3y6kryftq
 Managers: 1
 Nodes: 3
 ... ...
```

### 4.1.2 View information about nodes

```sh
[echo@minion01 ~]$ sudo docker node ls
ID                            HOSTNAME       STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
3zvaz0q6iz91oe92zsfn79rl9 *   minion01.k8s   Ready               Active              Leader              18.06.1-ce
m4ppispuk9ssenwfb547vlfx7     minion02.k8s   Ready               Active                                  18.06.1-ce
utczs0xf0k8asv5xhk53h8dhw     minion03.k8s   Ready               Active                                  18.06.1-ce
```

*NOTE*: 
- *The `*` next to the node ID indicates that you’re currently connected on this node.*
- *Swarm management commands like `docker node ls` only work on manager nodes.*


## 4.2 Deploy a service  

e.g.

```sh
$ sudo docker service create --replicas 1 --name helloworld cloudecho/hello
vct016qjdzf5vglo6zgjq0w79
overall progress: 1 out of 1 tasks 
1/1: running   [==================================================>] 
verify: Service converged 
```

```
[echo@minion01 ~]$ sudo docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE                    PORTS
vct016qjdzf5        helloworld          replicated          1/1                 cloudecho/hello:latest   
```

## 4.3 Inspect a service on the swarm

e.g. 

```sh
sudo docker service inspect --pretty helloworld
sudo docker service ps helloworld
sudo docker ps
```

*See [docs.docker.com/engine/swarm/swarm-tutorial/inspect-service/](https://docs.docker.com/engine/swarm/swarm-tutorial/inspect-service) for more information.*


## 4.4 Scale the service in the swarm

e.g. 

```sh
[echo@minion01 ~]$ sudo docker service scale helloworld=3
helloworld scaled to 3
overall progress: 3 out of 3 tasks 
1/3: running   [==================================================>] 
2/3: running   [==================================================>] 
3/3: running   [==================================================>] 
verify: Service converged 
```

```
[echo@minion01 ~]$ sudo docker service ps helloworld
ID                  NAME                IMAGE                    NODE           DESIRED STATE       CURRENT STATE               ERROR               PORTS
pejk5rws46iu        helloworld.1        cloudecho/hello:latest   minion01.k8s   Running             Running about an hour ago                       
ayddx4mm23du        helloworld.2        cloudecho/hello:latest   minion02.k8s   Running             Running 8 minutes ago                           
oun32xdz6fi1        helloworld.3        cloudecho/hello:latest   minion03.k8s   Running             Running 7 minutes ago                           
```

*See [docs.docker.com/engine/swarm/swarm-tutorial/scale-service/](https://docs.docker.com/engine/swarm/swarm-tutorial/scale-service/) for more information.*


## 4.5 Delete the service running on the swarm

e.g. 

```sh
sudo docker service rm helloworld
```

## 4.6 Apply rolling updates to a service

*See [docs.docker.com/engine/swarm/swarm-tutorial/rolling-update/](https://docs.docker.com/engine/swarm/swarm-tutorial/rolling-update/)*

## 4.7 Drain a node on the swarm

In earlier steps of the tutorial, all the nodes have been running with ACTIVE availability. The swarm manager can assign tasks to any ACTIVE node, so up to now all nodes have been available to receive tasks.

Sometimes, such as planned maintenance times, you need to set a node to DRAIN availability. DRAIN availability prevents a node from receiving new tasks from the swarm manager. It also means the manager stops tasks running on the node and launches replica tasks on a node with ACTIVE availability.

*See [docs.docker.com/engine/swarm/swarm-tutorial/drain-node/](https://docs.docker.com/engine/swarm/swarm-tutorial/drain-node/) for more information.*

## 4.8 Publish a port for a service

e.g.

```sh
$ sudo docker service create --replicas 1 --name helloworld --publish published=30001,target=8080 cloudecho/hello
```

Publish a port for an existing service:

e.g.

```sh
[echo@minion01 ~]$ sudo docker service update helloworld --publish-add published=30001,target=8080
helloworld
overall progress: 3 out of 3 tasks 
1/3: running   [==================================================>] 
2/3: running   [==================================================>] 
3/3: running   [==================================================>] 
verify: Service converged 
```

```sh
[echo@minion01 ~]$ sudo docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE                    PORTS
vct016qjdzf5        helloworld          replicated          3/3                 cloudecho/hello:latest   *:30001->8080/tcp
```

Have a test using `curl`:

```sh
[echo@minion01 ~]$ curl http://minion02.k8s:30001
Hello, World!
2021-11-09 09:03:59.794006337 +0000 UTC
```

*See [https://docs.docker.com/engine/swarm/ingress/](https://docs.docker.com/engine/swarm/ingress/) for more information.*

# Reference

- [docs.docker.com/engine/swarm/](https://docs.docker.com/engine/swarm/)
- [docs.docker.com/engine/swarm/key-concepts/](https://docs.docker.com/engine/swarm/key-concepts/)
- [docs.docker.com/engine/swarm/swarm-tutorial/](https://docs.docker.com/engine/swarm/swarm-tutorial/)
- [docs.docker.com/engine/swarm/ingress/](https://docs.docker.com/engine/swarm/ingress/)