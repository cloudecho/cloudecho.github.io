---
layout: post
status: publish
published: true
title: zookeeper集群配置


date: '2015-11-29 21:44:02 +0800'
date_gmt: '2015-11-29 13:44:02 +0800'
categories:
- Opensource
tags:
- zookeeper
comments: []
---
<p>ZooKeeper是一个分布式开源框架，提供了协调分布式应用的基本服务，它向外部应用暴露一组通用服务&mdash;&mdash;分布式同步（Distributed Synchronization）、命名服务（Naming Service）、集群维护（Group Maintenance）等，简化分布式应用协调及其管理的难度，提供高性能的分布式服务。ZooKeeper本身可以以Standalone模式安装运行，不过它的长处在于通过分布式ZooKeeper集群（一个Leader，多个Follower），基于一定的策略来保证ZooKeeper集群的稳定性和可用性，从而实现分布式应用的可靠性。</p>
<p>有关ZooKeeper的介绍，网上很多，也可以参考文章后面，我整理的一些相关链接。</p>
<p>下面，我们简单说明一下ZooKeeper的配置。</p>
<h2>ZooKeeper Standalone模式</h2>
<p>从Apache网站上（zookeeper.apache.org）下载ZooKeeper软件包，我选择了3.3.4版本的（zookeeper-3.3.4.tar.gz），在一台Linux机器上安装非常容易，只需要解压缩后，简单配置一下即可以启动ZooKeeper服务器进程。</p>
<p>将zookeeper-3.3.4/conf目录下面的 zoo_sample.cfg修改为zoo.cfg，配置文件内容如下所示：</p>
<div>
<div><strong>[plain]</strong>&nbsp;<a title="view plain" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">view plain</a><a title="copy" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">copy</a></div>
<ol>
<li>tickTime=2000</li>
<li>dataDir=/home/hadoop/storage/zookeeper</li>
<li>clientPort=2181</li>
<li>initLimit=5</li>
<li>syncLimit=2</li>
</ol>
</div>
<p>上面各个配置参数的含义也非常简单，引用如下所示：</p>
<div>
<div><strong>[plain]</strong>&nbsp;<a title="view plain" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">view plain</a><a title="copy" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">copy</a></div>
<ol>
<li>tickTime&nbsp;&mdash;&mdash;&nbsp;the&nbsp;basic&nbsp;time&nbsp;unit&nbsp;in&nbsp;milliseconds&nbsp;used&nbsp;by&nbsp;ZooKeeper.&nbsp;It&nbsp;is&nbsp;used&nbsp;to&nbsp;do&nbsp;heartbeats&nbsp;and&nbsp;the&nbsp;minimum&nbsp;session&nbsp;timeout&nbsp;will&nbsp;be&nbsp;twice&nbsp;the&nbsp;tickTime.</li>
<li>dataDir&nbsp;&mdash;&mdash;&nbsp;the&nbsp;location&nbsp;to&nbsp;store&nbsp;the&nbsp;in-memory&nbsp;database&nbsp;snapshots&nbsp;and,&nbsp;unless&nbsp;specified&nbsp;otherwise,&nbsp;the&nbsp;transaction&nbsp;log&nbsp;of&nbsp;updates&nbsp;to&nbsp;the&nbsp;database.</li>
<li>clientPort&nbsp;&mdash;&mdash;&nbsp;the&nbsp;port&nbsp;to&nbsp;listen&nbsp;for&nbsp;client&nbsp;connections</li>
</ol>
</div>
<p>下面启动ZooKeeper服务器进程：</p>
<div>
<div><strong>[plain]</strong>&nbsp;<a title="view plain" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">view plain</a><a title="copy" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">copy</a></div>
<ol>
<li>cd&nbsp;zookeeper-3.3.4/</li>
<li>bin/zkServer.sh&nbsp;start</li>
</ol>
</div>
<p>通过jps命令可以查看ZooKeeper服务器进程，名称为QuorumPeerMain。</p>
<p>在客户端连接ZooKeeper服务器，执行如下命令：</p>
<div>
<div><strong>[plain]</strong>&nbsp;<a title="view plain" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">view plain</a><a title="copy" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">copy</a></div>
<ol>
<li>bin/zkCli.sh&nbsp;-server&nbsp;dynamic:2181</li>
</ol>
</div>
<p>上面dynamic是我的主机名，如果在本机执行，则执行如下命令即可：</p>
<div>
<div><strong>[plain]</strong>&nbsp;<a title="view plain" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">view plain</a><a title="copy" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">copy</a></div>
<ol>
<li>bin/zkCli.sh</li>
</ol>
</div>
<p>客户端连接信息如下所示：&nbsp;接着，可以使用help查看Zookeeper客户端可以使用的基本操作命令。</p>
<div>
<h2>ZooKeeper Distributed模式</h2>
<p>ZooKeeper分布式模式安装（ZooKeeper集群）也比较容易，这里说明一下基本要点。</p>
<p>首先要明确的是，ZooKeeper集群是一个独立的分布式协调服务集群，&ldquo;独立&rdquo;的含义就是说，如果想使用ZooKeeper实现分布式应用的协调与管理，简化协调与管理，任何分布式应用都可以使用，这就要归功于Zookeeper的数据模型（Data Model）和层次命名空间（Hierarchical Namespace）结构，详细可以参考<a href="http://zookeeper.apache.org/doc/trunk/zookeeperOver.html" data-ke-src="http://zookeeper.apache.org/doc/trunk/zookeeperOver.html">http://zookeeper.apache.org/doc/trunk/zookeeperOver.html</a>。在设计你的分布式应用协调服务时，首要的就是考虑如何组织层次命名空间。</p>
<p>下面说明分布式模式的安装配置，过程如下所示：</p>
<p><strong>第一步：主机名称到IP地址映射配置</strong></p>
<p>ZooKeeper集群中具有两个关键的角色：Leader和Follower。集群中所有的结点作为一个整体对分布式应用提供服务，集群中每个结点之间都互相连接，所以，在配置的ZooKeeper集群的时候，每一个结点的host到IP地址的映射都要配置上集群中其它结点的映射信息。</p>
<p>例如，我的ZooKeeper集群中每个结点的配置，以slave-01为例，/etc/hosts内容如下所示：</p>
<div>
<div><strong>[plain]</strong><a title="view plain" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">view plain</a><a title="copy" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">copy</a></div>
<ol>
<li>192.168.0.179&nbsp;&nbsp;&nbsp;slave-01</li>
<li>192.168.0.178&nbsp;&nbsp;&nbsp;slave-02</li>
<li>192.168.0.177&nbsp;&nbsp;&nbsp;slave-03</li>
</ol>
</div>
<p>ZooKeeper采用一种称为Leader election的选举算法。在整个集群运行过程中，只有一个Leader，其他的都是Follower，如果ZooKeeper集群在运行过程中Leader出了问题，系统会采用该算法重新选出一个Leader。因此，各个结点之间要能够保证互相连接，必须配置上述映射。</p>
<p>ZooKeeper集群启动的时候，会首先选出一个Leader，在Leader election过程中，某一个满足选举算的结点就能成为Leader。整个集群的架构可以参考<a href="http://zookeeper.apache.org/doc/trunk/zookeeperOver.html#sc_designGoals" data-ke-src="http://zookeeper.apache.org/doc/trunk/zookeeperOver.html#sc_designGoals">http://zookeeper.apache.org/doc/trunk/zookeeperOver.html#sc_designGoals</a>。</p>
<p><strong>第二步：修改ZooKeeper配置文件</strong></p>
<p>在其中一台机器（slave-01）上，解压缩zookeeper-3.3.4.tar.gz，修改配置文件conf/zoo.cfg，内容如下所示：</p>
<div>
<div><strong>[plain]</strong><a title="view plain" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">view plain</a><a title="copy" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">copy</a></div>
<ol>
<li>tickTime=2000</li>
<li>dataDir=/home/hadoop/storage/zookeeper</li>
<li>clientPort=2181</li>
<li>initLimit=5</li>
<li>syncLimit=2</li>
<li>server.1=slave-01:2888:3888</li>
<li>server.2=slave-02:2888:3888</li>
<li>server.3=slave-03:2888:3888</li>
</ol>
</div>
<p>上述配置内容说明，可以参考<a href="http://zookeeper.apache.org/doc/trunk/zookeeperStarted.html#sc_RunningReplicatedZooKeeper" data-ke-src="http://zookeeper.apache.org/doc/trunk/zookeeperStarted.html#sc_RunningReplicatedZooKeeper">http://zookeeper.apache.org/doc/trunk/zookeeperStarted.html#sc_RunningReplicatedZooKeeper</a>。<strong>第三步：远程复制分发安装文件</strong></p>
<p>上面已经在一台机器slave-01上配置完成ZooKeeper，现在可以将该配置好的安装文件远程拷贝到集群中的各个结点对应的目录下：</p>
<div>
<div><strong>[plain]</strong><a title="view plain" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">view plain</a><a title="copy" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">copy</a></div>
<ol>
<li>cd&nbsp;/home/hadoop/installation/</li>
<li>scp&nbsp;-r&nbsp;zookeeper-3.3.4/&nbsp;hadoop@slave-02:/home/hadoop/installation/</li>
<li>scp&nbsp;-r&nbsp;zookeeper-3.3.4/&nbsp;hadoop@slave-03:/home/hadoop/installation/</li>
</ol>
</div>
<p><strong>第四步：设置myid</strong>在我们配置的dataDir指定的目录下面，创建一个myid文件，里面内容为一个数字，用来标识当前主机，conf/zoo.cfg文件中配置的server.X中X为什么数字，则myid文件中就输入这个数字，例如：</p>
<div>
<div><strong>[plain]</strong><a title="view plain" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">view plain</a><a title="copy" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">copy</a></div>
<ol>
<li>hadoop@slave-01:~/installation/zookeeper-3.3.4$&nbsp;echo&nbsp;"1"&nbsp;>&nbsp;/home/hadoop/storage/zookeeper/myid</li>
<li>hadoop@slave-02:~/installation/zookeeper-3.3.4$&nbsp;echo&nbsp;"2"&nbsp;>&nbsp;/home/hadoop/storage/zookeeper/myid</li>
<li>hadoop@slave-03:~/installation/zookeeper-3.3.4$&nbsp;echo&nbsp;"3"&nbsp;>&nbsp;/home/hadoop/storage/zookeeper/myid</li>
</ol>
</div>
<p>按照上述进行配置即可。<strong>第五步：启动ZooKeeper集群</strong></p>
<p>在ZooKeeper集群的每个结点上，执行启动ZooKeeper服务的脚本，如下所示：</p>
<div>
<div><strong>[plain]</strong><a title="view plain" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">view plain</a><a title="copy" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">copy</a></div>
<ol>
<li>hadoop@slave-01:~/installation/zookeeper-3.3.4$&nbsp;bin/zkServer.sh&nbsp;start</li>
<li>hadoop@slave-02:~/installation/zookeeper-3.3.4$&nbsp;bin/zkServer.sh&nbsp;start</li>
<li>hadoop@slave-03:~/installation/zookeeper-3.3.4$&nbsp;bin/zkServer.sh&nbsp;start</li>
</ol>
</div>
<p>以结点slave-01为例，日志如下所示：</p>
<div>
<div><strong>[plain]</strong><a title="view plain" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">view plain</a><a title="copy" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">copy</a></div>
<ol>
<li></li>
<li>2012-01-08&nbsp;06:51:23,210&nbsp;-&nbsp;INFO&nbsp;&nbsp;[QuorumPeer:/0:0:0:0:0:0:0:0:2181:Environment@97]&nbsp;-&nbsp;Server&nbsp;environment:java.io.tmpdir=/tmp</li>
<li>2012-01-08&nbsp;06:51:23,212&nbsp;-&nbsp;INFO&nbsp;&nbsp;[QuorumPeer:/0:0:0:0:0:0:0:0:2181:Environment@97]&nbsp;-&nbsp;Server&nbsp;environment:java.compiler=<NA></li>
<li>2012-01-08&nbsp;06:51:23,212&nbsp;-&nbsp;INFO&nbsp;&nbsp;[QuorumPeer:/0:0:0:0:0:0:0:0:2181:Environment@97]&nbsp;-&nbsp;Server&nbsp;environment:os.name=Linux</li>
<li>2012-01-08&nbsp;06:51:23,212&nbsp;-&nbsp;INFO&nbsp;&nbsp;[QuorumPeer:/0:0:0:0:0:0:0:0:2181:Environment@97]&nbsp;-&nbsp;Server&nbsp;environment:os.arch=i386</li>
<li>2012-01-08&nbsp;06:51:23,213&nbsp;-&nbsp;INFO&nbsp;&nbsp;[QuorumPeer:/0:0:0:0:0:0:0:0:2181:Environment@97]&nbsp;-&nbsp;Server&nbsp;environment:os.version=3.0.0-14-</li>
<li></li>
<li>我启动的顺序是slave-01>slave-02>slave-03，由于ZooKeeper集群启动的时候，每个结点都试图去连接集群中的其它结点，先启动的肯定连不上后面还没启动的，所以上面日志前面部分的异常是可以忽略的。通过后面部分可以看到，集群在选出一个Leader后，最后稳定了。</li>
</ol>
</div>
<p>其他结点可能也出现类似问题，属于正常。</p>
<p><strong>第六步：安装验证</strong></p>
<p>可以通过ZooKeeper的脚本来查看启动状态，包括集群中各个结点的角色（或是Leader，或是Follower），如下所示，是在ZooKeeper集群中的每个结点上查询的结果：</p>
<div>
<div><strong>[plain]</strong><a title="view plain" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">view plain</a><a title="copy" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">copy</a></div>
<ol>
<li>hadoop@slave-01:~/installation/zookeeper-3.3.4$&nbsp;bin/zkServer.sh&nbsp;status</li>
<li>JMX&nbsp;enabled&nbsp;by&nbsp;default</li>
<li>Using&nbsp;config:&nbsp;/home/hadoop/installation/zookeeper-3.3.4/bin/../conf/zoo.cfg</li>
<li>Mode:&nbsp;follower</li>
<li>hadoop@slave-02:~/installation/zookeeper-3.3.4$&nbsp;&nbsp;bin/zkServer.sh&nbsp;status</li>
<li>JMX&nbsp;enabled&nbsp;by&nbsp;default</li>
<li>Using&nbsp;config:&nbsp;/home/hadoop/installation/zookeeper-3.3.4/bin/../conf/zoo.cfg</li>
<li>Mode:&nbsp;leader</li>
<li>hadoop@slave-03:~/installation/zookeeper-3.3.4$&nbsp;&nbsp;bin/zkServer.sh&nbsp;status</li>
<li>JMX&nbsp;enabled&nbsp;by&nbsp;default</li>
<li>Using&nbsp;config:&nbsp;/home/hadoop/installation/zookeeper-3.3.4/bin/../conf/zoo.cfg</li>
<li>Mode:&nbsp;follower</li>
</ol>
</div>
<p>通过上面状态查询结果可见，slave-02是集群的Leader，其余的两个结点是Follower。<br />
另外，可以通过客户端脚本，连接到ZooKeeper集群上。对于客户端来说，ZooKeeper是一个整体（ensemble），连接到ZooKeeper集群实际上感觉在独享整个集群的服务，所以，你可以在任何一个结点上建立到服务集群的连接，例如：</p>
<div>
<div><strong>[plain]</strong><a title="view plain" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">view plain</a><a title="copy" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">copy</a></div>
<ol>
<li>hadoop@slave-03:~/installation/zookeeper-3.3.4$&nbsp;bin/zkCli.sh&nbsp;-server&nbsp;slave-01:2181</li>
<li>Connecting&nbsp;to&nbsp;slave-01:2181</li>
<li>2012-01-08&nbsp;07:14:21,068&nbsp;-&nbsp;INFO&nbsp;&nbsp;[main:Environment@97]&nbsp;-&nbsp;Client&nbsp;environment:zookeeper.version=3.3.3-1203054,&nbsp;built&nbsp;on&nbsp;11/17/2011&nbsp;05:47&nbsp;GMT</li>
<li></li>
<li></li>
</ol>
</div>
<p>当前根路径为/zookeeper。</p>
<h2>总结说明</h2>
<p><strong>主机名与IP地址映射配置问题</strong></p>
<p>启动ZooKeeper集群时，如果ZooKeeper集群中slave-01结点的日志出现如下错误：</p>
<div>
<div><strong>[plain]</strong><a title="view plain" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">view plain</a><a title="copy" href="http://blog.csdn.net/shirdrn/article/details/7183503#" data-ke-src="http://blog.csdn.net/shirdrn/article/details/7183503#">copy</a></div>
<ol>
<li>java.net.SocketTimeoutException</li>
<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;at&nbsp;sun.nio.ch.SocketAdaptor.connect(SocketAdaptor.java:109)</li>
<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;at&nbsp;org.apache.zookeeper.server.quorum.QuorumCnxManager.connectOne(QuorumCnxManager.java:371)</li>
<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;at&nbsp;org.apache.zookeeper.server.quorum.QuorumCnxManager.connectAll(QuorumCnxManager.java:404)</li>
<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;at&nbsp;org.apache.zookeeper.server.quorum.FastLeaderElection.lookForLeader(FastLeaderElection.java:688)</li>
<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;at&nbsp;org.apache.zookeeper.server.quorum.QuorumPeer.run(QuorumPeer.java:622)</li>
<li>2012-01-08&nbsp;06:37:46,026&nbsp;-&nbsp;INFO&nbsp;&nbsp;[QuorumPeer:/0:0:0:0:0:0:0:0:2181:FastLeaderElection@697]&nbsp;-&nbsp;Notification&nbsp;time&nbsp;out:&nbsp;6400</li>
<li>2012-01-08&nbsp;06:37:57,431&nbsp;-&nbsp;WARN&nbsp;&nbsp;[QuorumPeer:/0:0:0:0:0:0:0:0:2181:QuorumCnxManager@384]&nbsp;-&nbsp;Cannot&nbsp;open&nbsp;channel&nbsp;to&nbsp;2&nbsp;at&nbsp;election&nbsp;address&nbsp;slave-02/202.106.199.35:3888</li>
<li>java.net.SocketTimeoutException</li>
<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;at&nbsp;sun.nio.ch.SocketAdaptor.connect(SocketAdaptor.java:109)</li>
<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;at&nbsp;org.apache.zookeeper.server.quorum.QuorumCnxManager.connectOne(QuorumCnxManager.java:371)</li>
<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;at&nbsp;org.apache.zookeeper.server.quorum.QuorumCnxManager.connectAll(QuorumCnxManager.java:404)</li>
<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;at&nbsp;org.apache.zookeeper.server.quorum.FastLeaderElection.lookForLeader(FastLeaderElection.java:688)</li>
</ol>
</div>
<p>很显然，slave-01在启动时连接集群中其他结点（slave-02、slave-03）时，主机名映射的IP与我们实际配置的不一致，所以集群中各个结点之间无法建立链路，整个ZooKeeper集群启动是失败的。</p>
<p>上面错误日志中slave-02/202.106.199.35:3888实际应该是slave-02/202.192.168.0.178:3888就对了，但是在进行域名解析的时候映射有问题，修改每个结点的/etc/hosts文件，将ZooKeeper集群中所有结点主机名到IP地址的映射配置上</p>
</div>
<p>摘自『互联网』</p>
