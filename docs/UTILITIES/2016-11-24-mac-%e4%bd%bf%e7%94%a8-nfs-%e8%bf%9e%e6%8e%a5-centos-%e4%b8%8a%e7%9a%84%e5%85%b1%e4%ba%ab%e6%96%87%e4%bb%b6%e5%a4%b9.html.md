---
layout: post
status: publish
published: true
title: Mac 使用 NFS 连接 Centos 上的共享文件夹


date: '2016-11-24 22:58:54 +0800'
date_gmt: '2016-11-24 14:58:54 +0800'
categories:
- Util
tags:
- nfs
comments: []
---
<h2>Centos端配置</h2>
<pre class="prettyprint hljs vim"><code>rpm -<span class="hljs-keyword">qa</span>|<span class="hljs-keyword">grep</span> nfs
</code>检测是否已安装NFS</pre>
<pre class="prettyprint hljs vim"><code>[root@localhost ~]# rpm -<span class="hljs-keyword">qa</span>|<span class="hljs-keyword">grep</span> nfs
nfs-utils-lib-<span class="hljs-number">1.0</span>.<span class="hljs-number">8</span>-<span class="hljs-number">7.2</span>.z2
nfs-utils-<span class="hljs-number">1.0</span>.<span class="hljs-number">9</span>-<span class="hljs-number">40</span>.el5
<span class="hljs-built_in">system</span>-config-nfs-<span class="hljs-number">1.3</span>.<span class="hljs-number">23</span>-<span class="hljs-number">1</span>.el5

</code></pre>
<p>则已安装了nfs软件包。若未安装则需手动安装后继续</p>
<p>接着配置 <code class="prettyprint">/etc/exports</code> 文件：</p>
<pre class="prettyprint hljs verilog"><code>/<span class="hljs-keyword">var</span>/www <span class="hljs-number">192</span><span class="hljs-variable">.168</span><span class="hljs-variable">.100</span><span class="hljs-variable">.222</span>(rw,sync,no_root_squash,insecure)
</code></pre>
<pre class="prettyprint hljs scheme"><code>[<span class="hljs-name">要共享的目录</span>] [<span class="hljs-name">共享给客户端IP</span>(<span class="hljs-name">选项</span>)] [<span class="hljs-name">客户端2</span> ...
</code></pre>
<p>配置文件的详细使用说明请参见： <a href="http://www.centos.org/docs/5/html/Deployment_Guide-en-US/s1-nfs-server-config-exports.html" rel="nofollow">这里</a></p>
<p>如果连接时 Centos 端提示</p>
<p><code class="prettyprint">nfsd: request from insecure port (192.168.7.130:49232)!</code></p>
<p>则将'选项'配置成 <code class="prettyprint">(rw,async,insecure)</code> 即可</p>
<p>启动(或重启)NFS服务器（先 portmap ，后 nfs 两个服务。停止时候停 nfs 就好，portmap 可能会被其他服务所需要）</p>
<pre class="prettyprint hljs lisp"><code>service nfs start(<span class="hljs-name">restart</span>)
</code></pre>
<p>设置两个服务开机自动启动。</p>
<pre class="prettyprint hljs nginx"><code>chkconfig --level <span class="hljs-number">35</span> nfs <span class="hljs-literal">on</span>
</code></pre>
<p>根据实际需要更改下要共享的文件夹的权限</p>
<pre class="prettyprint hljs nginx"><code><span class="hljs-attribute">chmod</span> -R <span class="hljs-number">777</span> /var/www
</code></pre>
<h2>Mac端配置</h2>
<pre class="prettyprint hljs nginx"><code><span class="hljs-attribute">showmount</span> -e IP\Domain
</code></pre>
<p>来查看 Centos 主机的共享状态</p>
<pre class="prettyprint hljs ruby"><code>$ sudo mount -o rw -t nfs <span class="hljs-number">192.168</span>.<span class="hljs-number">100.222</span><span class="hljs-symbol">:/var/www</span> /private/nfs</code></pre>
<p>注:如果需要写权限，在sever的相应目录上执行 chmod o+w</p>
<p>摘自『http://www.tuicool.com/articles/Av6Nn2』</p>
