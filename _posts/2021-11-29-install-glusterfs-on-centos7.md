---
layout: post
title:  "Install Glusterfs on Centos 7"
date:   2021-11-29 19:22:00 +0800
categories: Opensource
tags:
- glusterfs
- centos
summary: 
---

# 1. Preparation

## 1.1 KVMs

*3 KVMs*

Hostname       | vCPUs | Memory | Swap | IP              | OS       | sudoer | Data Storage 
---------------|-------|--------|------|-----------------|----------|------- |-------------
*gluster01*    | 2     | 2G     | 0    | 192.168.122.191 | CentOS 7 | echo   | 100G 
*gluster02*    | 2     | 2G     | 0    | 192.168.122.192 | CentOS 7 | echo   | 100G
*gluster03*    | 2     | 2G     | 0    | 192.168.122.193 | CentOS 7 | echo   | 100G


Attach a disk image on those KVMs accordingly if needed. Here are the steps.

- STEP 1. Create the new disk images

*On the host server*

```sh
# Where your disk images store in
cd /data/vm_storage/

# Create the new disk image
sudo qemu-img create -f raw gluster01-disk1-100G 100G
sudo qemu-img create -f raw gluster02-disk1-100G 100G
sudo qemu-img create -f raw gluster03-disk1-100G 100G

sudo chown qemu:qemu gluster{01,02,03}-disk1-100G
```

- STEP 2. Attach the disk to the virtual machine

```sh
sudo virsh attach-disk gluster01 /data/vm_storage/gluster01-disk1-100G vdb --cache none
sudo virsh attach-disk gluster02 /data/vm_storage/gluster02-disk1-100G vdb --cache none
sudo virsh attach-disk gluster03 /data/vm_storage/gluster03-disk1-100G vdb --cache none
```

NOTE: If you already have a `/dev/vdb` disk you need to<br>
&nbsp;change vdb to a free device like `/dev/vdc` and so on

- STEP 3. Partitioning the disk drive in VMs

*On KVM gluster{01,02,03}*

Login into KVM gluster{01,02,03}.

```sh
sudo fdisk -l | grep /dev/vd

sudo fdisk /dev/vdb
```

- Type **n** for a new partition. 
- Type **p** for a primary partition. 
- Choose an available partition number **1**. 
- Enter the default first cylinder by pressing **Enter**. 
- Choose the entire disk is allocated by pressing **Enter**. 
- Finally type **p** to verify new partition. 
- Enter **w** to write changes and quit. 


## 1.2 Install Ansible on the host machine

```sh
# Install ansible on host machine
sudo yum install ansible
```

## 1.3 Password free configuration

```sh
cat <<EOF | sudo tee -a /etc/hosts
192.168.122.191 gluster01
192.168.122.192 gluster02
192.168.122.193 gluster03
EOF

cat <<EOF | sudo tee -a /etc/ansible/hosts
[gluster]
gluster01
gluster02
gluster03
EOF

# Have a test 
ansible gluster --ask-pass -u echo -m shell -a 'echo ok'

# Password free for login
ansible gluster --ask-pass -u echo -m file -a "path=.ssh state=directory mode=700"
ansible gluster --ask-pass -u echo -m copy -a "src=~/.ssh/id_rsa.pub dest=.ssh/authorized_keys mode=600"

# Password free for sudo
ansible gluster --ask-pass -u echo -b -m shell -a "echo 'echo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"

# Now we can have a test as below
ansible gluster -u echo -m shell -a 'echo ok'
```

## 1.4 DNS via hosts file

```sh
cat <<EOF > /tmp/add-hosts.sh
cat <<EEE >> /etc/hosts 
192.168.122.191 gluster01
192.168.122.192 gluster02
192.168.122.193 gluster03
EEE
EOF

ansible gluster -u echo -b -m script -a "/tmp/add-hosts.sh"
```

# 2. Configure the firewall

Ensure that TCP and UDP ports 24007 and 24008 are open on all Gluster servers. 
Apart from these ports, you need to open one port for each brick 
starting from port 49152 (instead of 24009 onwards as with previous releases).

```sh
cat <<EOF > /tmp/required-ports.sh
firewall-cmd --permanent --add-port=24007-24008/tcp --add-port=24007-24008/udp
firewall-cmd --permanent --add-port=49152-50151/tcp 
firewall-cmd --reload
EOF

ansible gluster -u echo -b -m script -a '/tmp/required-ports.sh'
```

# 3. Format and mount the device of gluster brick

NOTE: Assume that the brick will be residing on `/dev/vdb1`.

On the host server:

```sh
cat <<EOF > /tmp/mount-brick.sh
mkfs.xfs -i size=512 /dev/vdb1
mkdir -p /data/brick1
echo '/dev/vdb1 /data/brick1 xfs defaults 1 2' >> /etc/fstab
mount -a
EOF

ansible gluster -u echo -b -m script -a '/tmp/mount-brick.sh'
```

# 4. Installing GlusterFS

## 4.1 Install the software

*On the host server*

Lookup centos glusterfs software packages

```
yum search centos-release-gluster
```

Install Gluster 9 packages (`centos-release-gluster9`)

```sh
cat <<EOF > /tmp/install-gluster.sh
yum install centos-release-gluster9 -y
yum install glusterfs gluster-cli glusterfs-libs glusterfs-server -y
EOF

ansible gluster -u echo -b -m script -a '/tmp/install-gluster.sh'
```

*Login into gluster01*

Check the installed software packages.

```
$ rpm -qa |grep gluster
libglusterfs0-9.4-1.el7.x86_64
glusterfs-9.4-1.el7.x86_64
glusterfs-server-9.4-1.el7.x86_64
centos-release-gluster9-1.0-1.el7.noarch
glusterfs-client-xlators-9.4-1.el7.x86_64
libglusterd0-9.4-1.el7.x86_64
glusterfs-fuse-9.4-1.el7.x86_64
glusterfs-cli-9.4-1.el7.x86_64
```

## 4.2 Enable & start the glusterd service

```sh
cat <<EOF > /tmp/start-glusterd.sh
systemctl enable glusterd.service
systemctl start glusterd.service
EOF

ansible gluster -u echo -b -m script -a '/tmp/start-glusterd.sh'
```

## 4.3 Configure the trusted pool

*From `gluster01`*

```sh
sudo gluster peer probe gluster02
sudo gluster peer probe gluster03
```

Check the peer status

```sh
$ sudo gluster peer status
Number of Peers: 2

Hostname: gluster02
Uuid: 3313ad84-ca67-4b8b-8aa3-a0aaa104591e
State: Peer in Cluster (Connected)

Hostname: gluster03
Uuid: 3ed0ee52-9af5-4f81-a15b-f841c5ab1754
State: Peer in Cluster (Connected)
```

# 5. Set up a GlusterFS volume

## 5.1 Set up a volume named `gv0`

*On the host server*

```sh
ansible gluster -u echo -b -m shell -a 'mkdir -p /data/brick1/gv0'
```

*From `gluster01`*

Create a replicated volume by specifing the parameter `replica` to be 3:

```sh
sudo gluster volume create gv0 replica 3 \
 gluster01:/data/brick1/gv0 \
 gluster02:/data/brick1/gv0 \
 gluster03:/data/brick1/gv0
#OUTPUT: 
#volume create: gv0: success: please start the volume to access data

sudo gluster volume start gv0
#OUTPUT:
#volume start: gv0: success

```

Confirm that the volume shows "`Started`":

```
$ sudo gluster volume info
 
Volume Name: gv0
Type: Replicate
Volume ID: cd783e4a-a569-4cf2-894e-98cf1a7f180b
Status: Started
Snapshot Count: 0
Number of Bricks: 1 x 3 = 3
Transport-type: tcp
Bricks:
Brick1: gluster01:/data/brick1/gv0
Brick2: gluster02:/data/brick1/gv0
Brick3: gluster03:/data/brick1/gv0
Options Reconfigured:
cluster.granular-entry-heal: on
storage.fips-mode-rchecksum: on
transport.address-family: inet
nfs.disable: on
performance.client-io-threads: off
```

NOTE: If the volume does not show "`Started`", <br>
&nbsp;the files under `/var/log/glusterfs/glusterd.log`  <br>
&nbsp;should be checked in order to debug and diagnose the situation.  <br>
&nbsp;These logs can be looked at on one or, all the servers configured.


## 5.2 Testing the volume

*From `gluster01`*

```sh
sudo mkdir -p /mnt/gv0
sudo mount -t glusterfs gluster01:/gv0 /mnt/gv0

for i in `seq -w 1 10`; do sudo cp -rp /etc/hosts /mnt/gv0/copy-test-$i; done
```

First, check the client mount point:

```sh
ls -lA /mnt/gv0/copy* | wc -l
```

You should see 10 files returned. <br>
Next, check the GlusterFS brick mount points on each server (`gluster{01,02,03}`):

```sh
ls -lA /data/brick1/gv0/copy*
```

NOTE: Typically, you would do this from an external machine, known as a "client". <br>
It requires additional packages to be installed on the client machine. e.g.

```sh
sudo yum install centos-release-gluster9 -y
sudo yum install glusterfs glusterfs-fuse -y
```

# Reference

- [how-to-add-disk-image-to-kvm-virtual-machine-with-virsh-command](https://www.cyberciti.biz/faq/how-to-add-disk-image-to-kvm-virtual-machine-with-virsh-command/)
- [Quick-Start-Guide/Quickstart](https://docs.gluster.org/en/latest/Quick-Start-Guide/Quickstart/)
- [Quick-Start-Guide/Architecture](https://docs.gluster.org/en/latest/Quick-Start-Guide/Architecture/)
- [Administrator-Guide/Setting-Up-Clients](https://docs.gluster.org/en/latest/Administrator-Guide/Setting-Up-Clients/)
- [Administrator-Guide/Split-brain-and-ways-to-deal-with-it](https://docs.gluster.org/en/latest/Administrator-Guide/Split-brain-and-ways-to-deal-with-it/)