---
layout: post
status: publish
published: true
title: fdisk+mount+fstab 命令说明


date: '2015-09-25 16:48:32 +0800'
date_gmt: '2015-09-25 08:48:32 +0800'
categories:
- Util
tags: []
comments: []
---
<h3>一、fdisk 操作硬盘的命令</h3>
<p><strong>[root@localhost]# fdisk 设备</strong></p>
<p>例如我们通过 fdisk -l 得知 &nbsp;/dev/sda设备；我们如果想再添加或者删除一些分区，可以用</p>
<p>[root@localhost]# fdisk /dev/sda</p>
<h4>1、fdisk 的说明</h4>
<p>当我们通过 fdisk 设备，进入相应设备的操作时，会发现有如下的提示</p>
<p>[root@localhost]# fdisk /dev/sda<br />
Command (m for help): 在这里按m ，就会输出帮助；<br />
Command action<br />
a toggle a bootable flag<br />
b edit bsd disklabel<br />
c toggle the dos compatibility flag<br />
d delete a partition 注：这是删除一个分区的动作；<br />
l list known partition types 注：l是列出分区类型，以供我们设置相应分区的类型；<br />
m print this menu 注：m 是列出帮助信息；<br />
n add a new partition 注：添加一个分区；<br />
o create a new empty DOS partition table<br />
p print the partition table 注：p列出分区表；<br />
q quit without saving changes 注：不保存退出；<br />
s create a new empty Sun disklabel<br />
t change a partition's system id 注：t 改变分区类型；<br />
u change display/entry units<br />
v verify the partition table<br />
w write table to disk and exit 注：把分区表写入硬盘并退出；<br />
x extra functionality (experts only) 注：扩展应用，专家功能；</p>
<h4>2、列出当前操作硬盘的分区情况，用p</h4>
<p>Command (m for help): p<br />
Disk /dev/sda: 1035 MB, 1035730944 bytes<br />
256 heads, 63 sectors/track, 125 cylinders<br />
Units = cylinders of 16128 * 512 = 8257536 bytes<br />
Device Boot Start End Blocks Id System<br />
/dev/sda1 1 25 201568+ c W95 FAT32 (LBA)<br />
/dev/sda2 26 125 806400 5 Extended<br />
/dev/sda5 26 50 201568+ 83 Linux<br />
/dev/sda6 51 76 200781 83 Linux</p>
<h3>3、通过fdisk的d指令来删除一个分区</h3>
<p>Command (m for help): p 注：列出分区情况；<br />
Disk /dev/sda: 1035 MB, 1035730944 bytes<br />
256 heads, 63 sectors/track, 125 cylinders<br />
Units = cylinders of 16128 * 512 = 8257536 bytes<br />
Device Boot Start End Blocks Id System<br />
/dev/sda1 1 25 201568+ c W95 FAT32 (LBA)<br />
/dev/sda2 26 125 806400 5 Extended<br />
/dev/sda5 26 50 201568+ 83 Linux<br />
/dev/sda6 51 76 200781 83 Linux<br />
Command (m for help): d 注：执行删除分区指定；<br />
Partition number (1-6): 6 注：我想删除 sda6 ，就在这里输入 6 ；<br />
Command (m for help): p 注：再查看一下硬盘分区情况，看是否删除了？<br />
Disk /dev/sda: 1035 MB, 1035730944 bytes<br />
256 heads, 63 sectors/track, 125 cylinders<br />
Units = cylinders of 16128 * 512 = 8257536 bytes<br />
Device Boot Start End Blocks Id System<br />
/dev/sda1 1 25 201568+ c W95 FAT32 (LBA)<br />
/dev/sda2 26 125 806400 5 Extended<br />
/dev/sda5 26 50 201568+ 83 Linux<br />
Command (m for help):</p>
<p><span style="color: #993300;"><strong>警告</strong></span>：删除分区时要小心，请看好分区的序号，如果您删除了扩展分区，扩展分区之下的逻辑分区都会删除；所以操作时一定要小心；如果知道自己操作错了，请不要惊慌，用q不保存退出；切记切记！！！！在分区操作错了之时，千万不要输入w保存退出！！！</p>
<h4>4、通过fdisk的n指令增加一个分区</h4>
<p>Command (m for help): p<br />
Disk /dev/sda: 1035 MB, 1035730944 bytes<br />
256 heads, 63 sectors/track, 125 cylinders<br />
Units = cylinders of 16128 * 512 = 8257536 bytes<br />
Device Boot Start End Blocks Id System<br />
/dev/sda1 1 25 201568+ c W95 FAT32 (LBA)<br />
/dev/sda2 26 125 806400 5 Extended<br />
/dev/sda5 26 50 201568+ 83 Linux<br />
Command (m for help): n 注：增加一个分区；<br />
Command action<br />
l logical (5 or over) 注：增加逻辑分区，分区编号要大于5；为什么要大于5，因为已经有sda5了；<br />
p primary partition (1-4) 注：增加一个主分区；编号从 1-4 ；但sda1 和sda2都被占用，所以只能从3开始；<br />
p<br />
Partition number (1-4): 3<br />
No free sectors available 注：失败中，为什么失败？</p>
<p>注：我试图增加一个主分区，看来是失败了，为什么失败？因为我们看到主分区+扩展分区把整个磁盘都用光了，看扩展分区的End的值，再看一下 p输出信息中有125 cylinders；</p>
<p>所以我们只能增加逻辑分区了</p>
<p>Command (m for help): n<br />
Command action<br />
l logical (5 or over)<br />
p primary partition (1-4)<br />
l 注：在这里输入l，就进入划分逻辑分区阶段了；<br />
First cylinder (51-125, default 51): 注：这个就是分区的Start 值；这里最好直接按回车，如果您输入了一个非默认的数字，会造成空间浪费；<br />
Using default value 51<br />
Last cylinder or +size or +sizeM or +sizeK (51-125, default 125): +200M 注：这个是定义分区大小的，+200M 就是大小为200M ；当然您也可以根据p提示的单位cylinder的大小来算，然后来指定 End的数值。回头看看是怎么算的；还是用+200M这个办法来添加，这样能直观一点。如果您想添加一个10G左右大小的分区，请输入 +10000M ；<br />
Command (m for help):</p>
<h4>5、通过fdisk的t指令指定分区类型</h4>
<p>Command (m for help): t 注：通过t来指定分区类型；<br />
Partition number (1-6): 6 注：要改变哪个分区类型呢？我指定了6，其实也就是sda6<br />
Hex code (type L to list codes):L 注：在这里输入L，就可以查看分区类型的id了；<br />
Hex code (type L to list codes): b 注：如果我想让这个分区是 W95 FAT32 类型的，通过L查看得知 b是表示的是，所以输入了b；<br />
Changed system type of partition 6 to b (W95 FAT32) 注：系统信息，改变成功；是否是改变了，请用p查看；<br />
Command (m for help): p<br />
Disk /dev/sda: 1035 MB, 1035730944 bytes<br />
256 heads, 63 sectors/track, 125 cylinders<br />
Units = cylinders of 16128 * 512 = 8257536 bytes<br />
Device Boot Start End Blocks Id System<br />
/dev/sda1 1 25 201568+ c W95 FAT32 (LBA)<br />
/dev/sda2 26 125 806400 5 Extended<br />
/dev/sda5 26 50 201568+ 83 Linux<br />
/dev/sda6 51 75 201568+ b W95 FAT32</p>
<h4>6、fdisk 的退出，用q或者 w</h4>
<p>其中 q是 不保存退出，w是保存退出</p>
<p>Command (m for help): w<br />
或<br />
Command (m for help): q</p>
<h3>二、一个添加分区的例子</h3>
<p>本例中我们会添加两个200M的主分区，其它为扩展分区，在扩展分区中我们添加两个200M大小的逻辑分区</p>
<p>Command (m for help): p 注：列出分区表；<br />
Disk /dev/sda: 1035 MB, 1035730944 bytes<br />
256 heads, 63 sectors/track, 125 cylinders<br />
Units = cylinders of 16128 * 512 = 8257536 bytes<br />
Device Boot Start End Blocks Id System<br />
Command (m for help): n 注：添加分区；<br />
Command action<br />
e extended<br />
p primary partition (1-4)<br />
p 注：添加主分区；<br />
Partition number (1-4): 1 注：添加主分区1；<br />
First cylinder (1-125, default 1): 注：直接回车，主分区1的起始位置；默认为1,默认就好；<br />
Using default value 1<br />
Last cylinder or +size or +sizeM or +sizeK (1-125, default 125): +200M 注：指定分区大小，用+200M来指定大小为200M<br />
Command (m for help): n 注：添加新分区；<br />
Command action<br />
e extended<br />
p primary partition (1-4)<br />
p 注：添加主分区<br />
Partition number (1-4): 2 注：添加主分区2；<br />
First cylinder (26-125, default 26):<br />
Using default value 26<br />
Last cylinder or +size or +sizeM or +sizeK (26-125, default 125): +200M 注：指定分区大小，用+200M来指定大小为200M<br />
Command (m for help): n<br />
Command action<br />
e extended<br />
p primary partition (1-4)<br />
e 注：添加扩展分区；<br />
Partition number (1-4): 3 注：指定为3 ，因为主分区已经分了两个了，这个也算主分区，从3开始；<br />
First cylinder (51-125, default 51): 注：直接回车；<br />
Using default value 51<br />
Last cylinder or +size or +sizeM or +sizeK (51-125, default 125): 注：直接回车，把其余的所有空间都给扩展分区；<br />
Using default value 125<br />
Command (m for help): p<br />
Disk /dev/sda: 1035 MB, 1035730944 bytes<br />
256 heads, 63 sectors/track, 125 cylinders<br />
Units = cylinders of 16128 * 512 = 8257536 bytes<br />
Device Boot Start End Blocks Id System<br />
/dev/sda1 1 25 201568+ 83 Linux<br />
/dev/sda2 26 50 201600 83 Linux<br />
/dev/sda3 51 125 604800 5 Extended<br />
Command (m for help): n<br />
Command action<br />
l logical (5 or over)<br />
p primary partition (1-4)<br />
l 注：添加逻辑分区；<br />
First cylinder (51-125, default 51):<br />
Using default value 51<br />
Last cylinder or +size or +sizeM or +sizeK (51-125, default 125): +200M 注：添加一个大小为200M大小的分区；<br />
Command (m for help): n<br />
Command action<br />
l logical (5 or over)<br />
p primary partition (1-4)<br />
l 注：添加一个逻辑分区；<br />
First cylinder (76-125, default 76):<br />
Using default value 76<br />
Last cylinder or +size or +sizeM or +sizeK (76-125, default 125): +200M 注：添加一个大小为200M大小的分区；<br />
Command (m for help): p 列出分区表；<br />
Disk /dev/sda: 1035 MB, 1035730944 bytes<br />
256 heads, 63 sectors/track, 125 cylinders<br />
Units = cylinders of 16128 * 512 = 8257536 bytes<br />
Device Boot Start End Blocks Id System<br />
/dev/sda1 1 25 201568+ 83 Linux<br />
/dev/sda2 26 50 201600 83 Linux<br />
/dev/sda3 51 125 604800 5 Extended<br />
/dev/sda5 51 75 201568+ 83 Linux<br />
/dev/sda6 76 100 201568+ 83 Linux</p>
<p>然后我们根据前面所说通过t指令来改变分区类型；</p>
<p>最后不要忘记w保存退出</p>
<p>格式化分区&amp;挂载</p>
<h3>三、对分区进行格式化，以及加载</h3>
<p>先提示一下；用 mkfs.bfs mkfs.ext2 mkfs.jfs mkfs.msdos mkfs.vfatmkfs.cramfs mkfs.ext3 mkfs.ext4 &nbsp;mkfs.minix mkfs.reiserfs mkfs.xfs 等命令来格式化分区，比如我想格式化 sda6为ext4文件系统，则输入；</p>
<p>[root@localhost]# mkfs.ext4 /dev/sda6</p>
<p>如果我想加载 sda6到目前系统来存取文件，应该有mount 命令，但首先您得建一个挂载目录；比如 /mnt/sda6 ；</p>
<p>[root@localhost]# mkdir /mnt/sda6<br />
[root@localhost]# mount /dev/sda6 /mnt/sda6<br />
[root@localhost]# df -lh<br />
Filesystem 容量 已用 可用 已用% 挂载点<br />
/dev/hda8 11G 8.4G 2.0G 81% /<br />
/dev/shm 236M 0 236M 0% /dev/shm<br />
/dev/hda10 16G 6.9G 8.3G 46% /mnt/hda10<br />
/dev/sda6 191M 5.6M 176M 4% /mnt/sda6</p>
<p>这样我们就能进入 /mnt/sda6目录，然后存取文件了。</p>
<h3>四、挂载和卸载</h3>
<h4>Linux系统在使用光盘、软盘或U盘时，必须先执行挂载（mount）命令。挂载命令会将这些存储介质指定成系统中的某个目录，以后直接访问相应目录即可读写存储介质上的数据。<br />
1.挂载光盘</h4>
<p>挂载光盘的命令如下：</p>
<p># mount -t is09660 /dev/cdrom /mnt/cdrom</p>
<p>该命令将光盘挂载到/mnt/cdrom目录，使用&ldquo;ls /mnt/cdrom&rdquo;命令即可显示光盘中数据和文件。</p>
<p>卸载光盘的命令如下：</p>
<p># umount /mnt/cdrom</p>
<h4>2.挂载软盘</h4>
<p>将软盘挂载到/mnt/floppy目录的命令如下：</p>
<p># mount /dev/fd0 /mnt/floppy</p>
<p>卸载软盘的命令如下：</p>
<p>#umount /mnt/floppy</p>
<h4>3.挂载U盘</h4>
<p>挂载U盘相对复杂一些。</p>
<p>首先使用&ldquo;fdisk -l&rdquo;命令查看外挂闪存的设备号，一般为/dev/sda1。然后用&ldquo;mkdir /mnt/usb&rdquo;命令建立一个挂载U盘用的目录。之后使用如下命令挂载FAT格式的U盘：</p>
<p># mount -t msdos /dev/sda1 /mnt/usb</p>
<p>使用如下命令挂载FAT32格式的U盘：</p>
<p># mount -t vfat /dev/sda1 /mnt/usb</p>
<h4>4.挂载外挂硬盘分区</h4>
<p>挂载外挂硬盘分区（FAT32格式）同样需要先用&ldquo;fdisk -1&rdquo;查看外挂的硬盘分区设备号，假设为/dev/hda1。建立/mnt/vfat挂载目录后，使用如下命令进行挂载：</p>
<p># mount -t vfat /dev/hda1 /mnt/vfat</p>
<p>注意，默认情况下Linux只允许root用户执行mount命令。如果想让一般用户也能挂载，并且希望在系统启动时自动挂载光盘或软盘，需要修改/etc/fstab配置文件，加入以下内容：</p>
<p>LABEL=/ /　ext3　　　defaults　　1 1<br />
/dev/cdrom/mnt/cdrom iSo9660 auto,owner,kudzu,ro,user 0 0<br />
/dev/fdo　/mnt/floppy auto　auto,owner,kudzu,ro,user 0 0</p>
<p>其中，&ldquo;user&rdquo;表示将mount命令赋予一般用户使用。</p>
<p>/etc/fstab文件在Linux的帮助手册中讲得很详细，读者不妨看一看。</p>
<h3>五、fstab说明</h3>
<p>fstab中存放了与分区有关的重要信息，其中每一行为一个分区记录，每一行又可分为六个部份，下面以/dev/hda7 / ext2 defaults 1 1为例逐个说明：<br />
1. 第一项是您想要mount的储存装置的实体位置，如hdb或如上例的/dev/hda7。</p>
<p>2. 第二项就是您想要将其加入至哪个目录位置，如/home或如上例的/,这其实就是在安装时提示的挂入点。</p>
<p>3. 第三项就是所谓的local filesystem，其包含了以下格式：如ext、ext2、msdos、iso9660、nfs、swap等，或如上例的ext2，可以参见/proc/filesystems说明。</p>
<p>4. 第四项就是您mount时，所要设定的状态，如ro（只读）或如上例的defaults（包括了其它参数如rw、suid、exec、auto、nouser、async），可以参见「mount nfs」。</p>
<p>5. 第五项是提供DUMP功能，在系统DUMP时是否需要BACKUP的标志位，其内定值是0。</p>
<p>6. 第六项是设定此filesystem是否要在开机时做check的动作，除了root的filesystem其必要的check为1之外，其它皆可视需要设定，内定值是0。</p>
<p>附完整的fstab示例：<br />
[root@localhost ~]# cat /etc/fstab<br />
#<br />
# /etc/fstab<br />
# Created by anaconda on Thu Aug 14 21:16:42 2014<br />
#<br />
# Accessible filesystems, by reference, are maintained under '/dev/disk'<br />
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info<br />
#<br />
UUID=94e4e384-0ace-437f-bc96-057dd64f42ee / ext4 defaults,barrier=0 1 1<br />
tmpfs /dev/shm tmpfs defaults 0 0<br />
devpts /dev/pts devpts gid=5,mode=620 0 0<br />
sysfs /sys sysfs defaults 0 0<br />
proc /proc proc defaults 0 0<br />
<span style="color: #993300;">/dev/xvdb1 /data ext4 defaults 0 0</span></p>
<p>『摘自』互联网</p>
