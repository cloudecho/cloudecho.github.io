---
layout: post
title:  "GlusterFS for Persistent Docker Volumes"
date:   2021-11-30 12:40:00 +0800
categories: Opensource
tags:
- glusterfs
- docker
description: 
---

![docker-and-glusterfs-blog-header.jpg](https://autoize.com/wp-content/uploads/2020/03/docker-and-glusterfs-blog-header.jpg)

## 1. Preparation

### 1.1 KVMs

*6 KVMs*

Hostname       | vCPUs | Memory | Swap | IP              | OS       | sudoer | Data Storage 
---------------|-------|--------|------|-----------------|----------|------- |-------------
*gluster01*    | 2     | 2G     | 0    | 192.168.122.191 | CentOS 7 | echo   | 100G, /data/brick1 
*gluster02*    | 2     | 2G     | 0    | 192.168.122.192 | CentOS 7 | echo   | 100G, /data/brick1 
*gluster03*    | 2     | 2G     | 0    | 192.168.122.193 | CentOS 7 | echo   | 100G, /data/brick1 
*minion01*.k8s | 2     | 8G     | 0    | 192.168.122.101 | CentOS 7 | echo   |
*minion02*.k8s | 2     | 8G     | 0    | 192.168.122.102 | CentOS 7 | echo   |
*minion03*.k8s | 2     | 8G     | 0    | 192.168.122.103 | CentOS 7 | echo   |

??? note "swarm-nodes"

    \# /etc/ansible/hosts<br>
    [swarm-nodes]<br>
    minion01.k8s<br>
    minion02.k8s<br>
    minion03.k8s


### 1.2 Installing GlusterFS and docker swarm

For installing GlusterFS, please refer to 
[Install Glusterfs on Centos 7](/OPENSOURCE/2021-11-29-install-glusterfs-on-centos7/).

For getting started with docker warm, please refer to
[Getting started with docker swarm mode](/OPENSOURCE/2021-11-09-getting-started-with-docker-swarm-mode/).


### 1.3 DNS via hosts file

*From the host server*

```sh
cat <<EOF > /tmp/add-hosts.sh
cat <<EEE >> /etc/hosts 
192.168.122.191 gluster01
192.168.122.192 gluster02
192.168.122.193 gluster03
EEE
EOF

ansible swarm-nodes -u echo -b -m script -a "/tmp/add-hosts.sh"
```

## 2. Creating a GlusterFS volume

### 2.1 Create and start a GlusterFS volume

*From the host server*

```sh
ansible gluster -u echo -b -m shell -a 'mkdir -p /data/brick1/gfs'
```

*From `gluster01`*

Create and start the replicated volume `gfs`:

```sh
sudo gluster volume create gfs replica 3 \
 gluster01:/data/brick1/gfs \
 gluster02:/data/brick1/gfs \
 gluster03:/data/brick1/gfs

sudo gluster volume start gfs

sudo gluster volume info gfs
```

### 2.2 Mount the `gfs` volume locally

On all Gluster hosts, mount the `gfs` volume locally.

*From the host server*

```sh
cat <<EOF > /tmp/mount-gfs.sh
mkdir -p /mnt/gfs

echo 'localhost:/gfs /mnt/gfs glusterfs defaults,_netdev 0 0' >> /etc/fstab
mount -a
EOF

ansible gluster -u echo -b -m script -a '/tmp/mount-gfs.sh'


cat <<EOF > /tmp/fix-mount.sh
mkdir -p /usr/local/sbin

cat <<EEE > /usr/local/sbin/check-gfs.sh
#!/bin/sh
while true; do
  df | grep /mnt/gfs > /dev/null
  if [[ \\\$? -eq 0 ]]; then
    exit 0
  fi

  sleep 3
  mount -a -t glusterfs
done  
EEE

chmod +x /usr/local/sbin/check-gfs.sh

cat <<EEE > /etc/systemd/system/glusterfsmounts.service 
[Unit]
Description=Glustermounting
Requires=glusterd.service

[Service]
Type=simple
RemainAfterExit=true
ExecStartPre=/usr/sbin/gluster volume status gfs
ExecStart=/usr/local/sbin/check-gfs.sh
Restart=on-failure
RestartSec=3

[Install]
WantedBy=multi-user.target
EEE

systemctl daemon-reload
systemctl enable glusterfsmounts
EOF

ansible gluster -u echo -b -m script -a '/tmp/fix-mount.sh'
```

*On gluser01 server*

```sh
$ df -h |grep gfs
localhost:/gfs           100G  1.1G   99G    2% /mnt/gfs
```

## 3. Install the GlusterFS volume plugin for Docker

The GlusterFS plugin for Docker must be installed across all Swarm nodes, one by one.

```sh
cat <<EOF > /tmp/gfs-plugin.sh
docker plugin install --alias glusterfs \
  mochoa/glusterfs-volume-plugin \
  --grant-all-permissions --disable

docker plugin set glusterfs SERVERS=gluster01,gluster02,gluster03
docker plugin enable glusterfs
EOF

ansible swarm-nodes -u echo -b -m script -a '/tmp/gfs-plugin.sh' 
```

## 4. Deploy a stack consisting of 1 simple service with a GlusterFS volume

### 4.1 Create a subdiectory at the root of the GlusterFS volume

From `gluster01` server, create a subdirectory named `vol1` at the root of the GlusterFS volume.

```sh
sudo mkdir -p /mnt/gfs/vol1
```

### 4.2 Deploy a stack

From any Swarm node, create a stack file named `docker-compose.yml`.

```yaml
cat <<EOF > docker-compose.yml
version: "3.7"

services:
  foo:
    image: alpine
    command: ping localhost
    networks:
      - net
    volumes:
      - vol1:/tmp

networks:
  net:
    driver: overlay

volumes:
  vol1:
    driver: glusterfs
    name: "gfs/vol1"
EOF
```

Deploy the stack.

```sh
$ sudo docker stack deploy -c docker-compose.yml test
Creating network test_net
Creating service test_foo
```

Check the stack.

```sh
$ sudo docker stack list
NAME                SERVICES            ORCHESTRATOR
test                1                   Swarm

$ sudo docker stack services test
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
zer9ypz8ghqo        test_foo            replicated          1/1                 alpine:latest       
```

### 4.3 Write some test data to the docker volume backed by GlusterFS

- STEP1. Find out which of the Swarm nodes the `test_foo` service is running on.

```sh
$ sudo docker service ps test_foo
ID                  NAME                IMAGE               NODE           DESIRED STATE       CURRENT STATE           ERROR               PORTS
beqjzsj3yznd        test_foo.1          alpine:latest       minion01.k8s   Running             Running 5 minutes ago         
```              

- STEP2. Switch to the terminal for that Swarm node and find the container ID of the `test_foo` service.

```sh
container_id=$(sudo docker ps | grep test_foo | awk '{print $1}')
```

- STEP3. Exec into the container’s `/bin/sh` shell.

```sh
sudo docker exec -it $container_id /bin/sh
```

- STEP4. Write some test data to `/tmp`

Write 1G of test data to `/tmp`.

```
/ # echo 'dd if=/dev/zero of=/tmp/test.bin bs=1024k count=1000' > test.sh
/ # time sh test.sh
1000+0 records in
1000+0 records out
real	0m 3.35s
user	0m 0.00s
sys	0m 1.02s
```

From any Gluster server (e.g. `gluster01`), list out the test data.

```sh
$ ls -lh /mnt/gfs/vol1/
-rw-r--r--. 1 root root 1000M Nov 30 12:26 test.bin
```

## Reference

- [Install Glusterfs on Centos 7](/OPENSOURCE/2021-11-29-install-glusterfs-on-centos7/)
- [Getting started with docker swarm mode](/OPENSOURCE/2021-11-09-getting-started-with-docker-swarm-mode/)
- [autoize.com/glusterfs-for-persistent-docker-volumes](https://autoize.com/glusterfs-for-persistent-docker-volumes/)
- [github.com/marcelo-ochoa/docker-volume-plugins](https://github.com/marcelo-ochoa/docker-volume-plugins/tree/master/glusterfs-volume-plugin)
- [serverfault.com/questions/800494/glusterfs-mount-on-boot-on-clustered-servers-rhel-7](https://serverfault.com/questions/800494/glusterfs-mount-on-boot-on-clustered-servers-rhel-7)
