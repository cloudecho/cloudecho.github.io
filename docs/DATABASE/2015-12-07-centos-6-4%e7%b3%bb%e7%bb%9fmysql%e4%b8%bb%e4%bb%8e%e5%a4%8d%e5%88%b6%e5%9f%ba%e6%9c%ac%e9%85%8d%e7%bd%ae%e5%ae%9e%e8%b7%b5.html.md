---
layout: post
status: publish
published: true
title: CentOS 6.4系统MySQL主从复制基本配置实践


date: '2015-12-07 20:35:44 +0800'
date_gmt: '2015-12-07 12:35:44 +0800'
categories:
- Database
tags: []
comments: []
---
<p><span class="byline"><span class="sep">作者：</span><span class="author vcard"><a class="url fn n" title="查看作者 Yanjun 的全部文章" href="http://shiyanjun.cn/archives/author/yanjun" rel="author">Yanjun</a></span></span></p>
<p>对于MySQL数据库一般用途的主从复制，可以实现数据的备份（如果希望在主节点失效后，能够使从节点自动接管，就需要更加复杂的配置，这里暂时先不考虑），如果主节点出现硬件故障，数据库服务器可以直接手动切换成备份节点（从节点），继续提供服务。基本的主从复制配置起来非常容易，这里我们做个简单的记录总结。<br />
我们选择两台服务器来进行MySQL的主从复制实践，一台m1作为主节点，另一台nn作为从节点。<br />
两台机器上都需要安装MySQL数据库，如果想要卸掉默认安装的，可以执行如下命令：</p>
<div id="highlighter_978149" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>1</code></td>
<td class="content"><code class="functions">sudo</code> <code class="plain">rpm -e --nodeps mysql</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>2</code></td>
<td class="content"><code class="plain">yum list | </code><code class="functions">grep</code> <code class="plain">mysql</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<p>现在可以在CentOS 6.4上直接执行如下命令进行安装：</p>
<div id="highlighter_797361" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>1</code></td>
<td class="content"><code class="functions">sudo</code> <code class="plain">yum </code><code class="functions">install</code> <code class="plain">-y mysql-server mysql mysql-deve</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<p>为root用户设置密码：</p>
<div id="highlighter_453943" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>1</code></td>
<td class="content"><code class="plain">mysqladmin -u root password </code><code class="string">'shiyanjun'</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<p>然后可以直接通过MySQL客户端登录：</p>
<div id="highlighter_644259" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>1</code></td>
<td class="content"><code class="plain">mysql -u root -p</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<p><strong>主节点配置</strong></p>
<p>首先，考虑到数据库的安全，以及便于管理，我们需要在主节点m1上增加一个专用的复制用户，使得任意想要从主节点进行复制从节点都必须使用这个账号：</p>
<div id="highlighter_71235" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>1</code></td>
<td class="content"><code class="keyword">CREATE</code> <code class="color2">USER</code> <code class="plain">repli_user;</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>2</code></td>
<td class="content"><code class="keyword">GRANT</code> <code class="plain">REPLICATION SLAVE </code><code class="keyword">ON</code> <code class="plain">*.* </code><code class="keyword">TO</code> <code class="string">'repli_user'</code><code class="plain">@</code><code class="string">'%'</code> <code class="plain">IDENTIFIED </code><code class="keyword">BY</code> <code class="string">'shiyanjun'</code><code class="plain">;</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<p>这里还进行了操作授权，使用这个换用账号来执行集群复制。如果想要限制IP端段，也可以在这里进行配置授权。<br />
然后，在主节点m1上，修改MySQL配置文件/etc/my.cnf，使其支持Master复制功能，修改后的内容如下所示：</p>
<div id="highlighter_418594" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>01</code></td>
<td class="content"><code class="plain">[mysqld]</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>02</code></td>
<td class="content"><code class="plain">datadir=/var/lib/mysql</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>03</code></td>
<td class="content"><code class="plain">socket=/var/lib/mysql/mysql.sock</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>04</code></td>
<td class="content"><code class="plain">user=mysql</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>05</code></td>
<td class="content"><code class="plain"># Disabling symbolic-links is recommended to prevent assorted security risks</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>06</code></td>
<td class="content"><code class="plain">symbolic-links=0</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1 highlighted">
<table>
<tbody>
<tr>
<td class="number"><code>07</code></td>
<td class="content"><code class="plain">server-id=1</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2 highlighted">
<table>
<tbody>
<tr>
<td class="number"><code>08</code></td>
<td class="content"><code class="plain">log-bin=m-bin</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1 highlighted">
<table>
<tbody>
<tr>
<td class="number"><code>09</code></td>
<td class="content"><code class="plain">log-bin-index=m-bin.index</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>10</code></td>
<td class="content"></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>11</code></td>
<td class="content"><code class="plain">[mysqld_safe]</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>12</code></td>
<td class="content"><code class="plain">log-error=/var/log/mysqld.log</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>13</code></td>
<td class="content"><code class="plain">pid-file=/var/run/mysqld/mysqld.pid</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<p>server-id指明主节点的身份，从节点通过这个server-id来识别该节点是Master节点（复制架构中的源数据库服务器节点）。<br />
如果MySQL当前已经启动，修改完集群复制配置后需要重启服务器：</p>
<div id="highlighter_800" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>1</code></td>
<td class="content"><code class="functions">sudo</code> <code class="plain">service mysqld restart</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<p><strong>从节点配置</strong></p>
<p>接着，类似地进行从节点nn的配置，同样修改MySQL配置文件/etc/my.cnf，使其支持Slave端复制功能，修改后的内容如下所示：</p>
<div id="highlighter_421192" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>01</code></td>
<td class="content"><code class="plain">[mysqld]</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>02</code></td>
<td class="content"><code class="plain">datadir=/var/lib/mysql</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>03</code></td>
<td class="content"><code class="plain">socket=/var/lib/mysql/mysql.sock</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>04</code></td>
<td class="content"><code class="plain">user=mysql</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>05</code></td>
<td class="content"><code class="plain"># Disabling symbolic-links is recommended to prevent assorted security risks</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>06</code></td>
<td class="content"><code class="plain">symbolic-links=0</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1 highlighted">
<table>
<tbody>
<tr>
<td class="number"><code>07</code></td>
<td class="content"><code class="plain">server-id=2</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2 highlighted">
<table>
<tbody>
<tr>
<td class="number"><code>08</code></td>
<td class="content"><code class="plain">relay-log=slave-relay-bin</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1 highlighted">
<table>
<tbody>
<tr>
<td class="number"><code>09</code></td>
<td class="content"><code class="plain">relay-log-index=slave-relay-bin.index</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>10</code></td>
<td class="content"></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>11</code></td>
<td class="content"><code class="plain">[mysqld_safe]</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>12</code></td>
<td class="content"><code class="plain">log-error=/var/log/mysqld.log</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>13</code></td>
<td class="content"><code class="plain">pid-file=/var/run/mysqld/mysqld.pid</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<p>同样，如果MySQL当前已经启动，修改完集群复制配置后需要重启服务器：</p>
<div id="highlighter_26260" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>1</code></td>
<td class="content"><code class="functions">sudo</code> <code class="plain">service mysqld restart</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<p>然后，需要使从节点nn指向主节点，并启动Slave复制，执行如下命令：</p>
<div id="highlighter_315349" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>1</code></td>
<td class="content"><code class="plain">CHANGE MASTER </code><code class="keyword">TO</code> <code class="plain">MASTER_HOST=</code><code class="string">'m1'</code><code class="plain">, MASTER_PORT=3306, MASTER_USER=</code><code class="string">'repli_user'</code><code class="plain">, MASTER_PASSWORD=</code><code class="string">'shiyanjun'</code><code class="plain">;</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>2</code></td>
<td class="content"><code class="plain">START SLAVE;</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<p><strong>验证集群复制</strong></p>
<p>这时，可以在主节点m1上执行相关操作，验证从节点nn同步复制了主节点的数据库中的内容变更。<br />
如果此时，我们已经配置好了主从复制，那么对于主节点m1上MysQL数据库的任何变更都会复制到从节点nn上，包括建库建表、插入更新等操作，下面我们从建库开始：<br />
在主节点m1上建库建表：</p>
<div id="highlighter_553793" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>01</code></td>
<td class="content"><code class="keyword">CREATE</code> <code class="keyword">DATABASE</code> <code class="plain">workflow;</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>02</code></td>
<td class="content"><code class="keyword">CREATE</code> <code class="keyword">TABLE</code> <code class="plain">`workflow`.`project` (</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>03</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">`id` </code><code class="keyword">int</code><code class="plain">(11) </code><code class="color1">NOT</code> <code class="color1">NULL</code> <code class="plain">AUTO_INCREMENT,</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>04</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">`</code><code class="keyword">name</code><code class="plain">` </code><code class="keyword">varchar</code><code class="plain">(100) </code><code class="color1">NOT</code> <code class="color1">NULL</code><code class="plain">,</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>05</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">`type` tinyint(4) </code><code class="color1">NOT</code> <code class="color1">NULL</code> <code class="keyword">DEFAULT</code> <code class="string">'0'</code><code class="plain">,</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>06</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">`description` </code><code class="keyword">varchar</code><code class="plain">(500) </code><code class="keyword">DEFAULT</code> <code class="color1">NULL</code><code class="plain">,</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>07</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">`create_at` </code><code class="keyword">date</code> <code class="keyword">DEFAULT</code> <code class="color1">NULL</code><code class="plain">,</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>08</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">`update_at` </code><code class="keyword">timestamp</code> <code class="color1">NOT</code> <code class="color1">NULL</code> <code class="keyword">DEFAULT</code> <code class="color2">CURRENT_TIMESTAMP</code> <code class="keyword">ON</code> <code class="keyword">UPDATE</code><code class="color2">CURRENT_TIMESTAMP</code><code class="plain">,</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>09</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">`status` tinyint(4) </code><code class="color1">NOT</code> <code class="color1">NULL</code> <code class="keyword">DEFAULT</code> <code class="string">'0'</code><code class="plain">,</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>10</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="keyword">PRIMARY</code> <code class="keyword">KEY</code> <code class="plain">(`id`)</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>11</code></td>
<td class="content"><code class="plain">) ENGINE=InnoDB </code><code class="keyword">DEFAULT</code> <code class="plain">CHARSET=utf8;</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<p>在m1上查看binlog内容，执行命令：</p>
<div id="highlighter_870534" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>1</code></td>
<td class="content"><code class="plain">SHOW BINLOG EVENTS\G</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<p>binlog内容内容如下所示：</p>
<div id="highlighter_793370" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>01</code></td>
<td class="content"><code class="plain">*************************** 1. row ***************************</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>02</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;</code><code class="plain">Log_name: m-bin.000001</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>03</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Pos: 4</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>04</code></td>
<td class="content"><code class="plain">Event_type: Format_desc</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>05</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">Server_id: 1</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>06</code></td>
<td class="content"><code class="plain">End_log_pos: 106</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>07</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Info: Server ver: 5.1.73-log, Binlog ver: 4</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>08</code></td>
<td class="content"><code class="plain">*************************** 2. row ***************************</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>09</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;</code><code class="plain">Log_name: m-bin.000001</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>10</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Pos: 106</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>11</code></td>
<td class="content"><code class="plain">Event_type: Query</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>12</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">Server_id: 1</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>13</code></td>
<td class="content"><code class="plain">End_log_pos: 197</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>14</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Info: CREATE DATABASE workflow</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>15</code></td>
<td class="content"><code class="plain">*************************** 3. row ***************************</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>16</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;</code><code class="plain">Log_name: m-bin.000001</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>17</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Pos: 197</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>18</code></td>
<td class="content"><code class="plain">Event_type: Query</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>19</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">Server_id: 1</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>20</code></td>
<td class="content"><code class="plain">End_log_pos: 671</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>21</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Info: CREATE TABLE `workflow`.`project` (</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>22</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">`id` int(11) NOT NULL AUTO_INCREMENT,</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>23</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">`name` varchar(100) NOT NULL,</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>24</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">`type` tinyint(4) NOT NULL DEFAULT '0',</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>25</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">`description` varchar(500) DEFAULT NULL,</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>26</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">`create_at` date DEFAULT NULL,</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>27</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">`update_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>28</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">`status` tinyint(4) NOT NULL DEFAULT '0',</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>29</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">PRIMARY KEY (`id`)</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>30</code></td>
<td class="content"><code class="plain">) ENGINE=InnoDB DEFAULT CHARSET=utf8</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>31</code></td>
<td class="content"><code class="plain">3 rows in set (0.00 sec)</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<p>通过上述binlog内容，我们大概可以看到MySQL的binlog都记录那些信息，一个事件对应一行记录。这些记录信息的组织结构如下所示：</p>
<ul>
<li>Log_name：日志名称，指定的记录操作的binlog日志名称，这里是m-bin.000001，与我们前面在/etc/my.cnf中配置的相对应</li>
<li>Pos：记录事件的起始位置</li>
<li>Event_type：事件类型</li>
<li>End_log_pos：记录事件的结束位置</li>
<li>Server_id：服务器标识</li>
<li>Info：事件描述信息</li>
</ul>
<p>然后，我们可以查看在从节点nn上复制的情况。通过如下命令查看从节点nn上数据库和表的信息：</p>
<div id="highlighter_619068" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>1</code></td>
<td class="content"><code class="plain">SHOW DATABASES;</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>2</code></td>
<td class="content"><code class="plain">USE workflow;</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>3</code></td>
<td class="content"><code class="plain">SHOW TABLES;</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>4</code></td>
<td class="content"><code class="keyword">DESC</code> <code class="plain">project;</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<p>我们再看一下执行插入语句的情况。在主节点m1上执行如下SQL语句：</p>
<div id="highlighter_948152" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>1</code></td>
<td class="content"><code class="keyword">INSERT</code> <code class="keyword">INTO</code> <code class="plain">`workflow`.`project` </code><code class="keyword">VALUES</code><code class="plain">(1, </code><code class="string">'Avatar-II'</code><code class="plain">, 1, </code><code class="string">'Avatar-II project'</code><code class="plain">,</code><code class="string">'2014-02-16'</code><code class="plain">, </code><code class="string">'2014-02-16 11:09:54'</code><code class="plain">, 0);</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<p>可以在从节点上执行查询，看到从节点nn上复制了主节点m1上执行的INSERT语句的记录：</p>
<div id="highlighter_326256" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>1</code></td>
<td class="content"><code class="keyword">SELECT</code> <code class="plain">* </code><code class="keyword">FROM</code> <code class="plain">workflow.project;</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<p>验证复制成功。</p>
<p><strong>复制常用命令</strong></p>
<p>下面，我们总结了几个在MySQL主从复制场景中常用到的几个相关命令：</p>
<ul>
<ul>
<li>终止主节点复制</li>
</ul>
</ul>
<div id="highlighter_515348" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>1</code></td>
<td class="content"><code class="plain">STOP MASTER;</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<ul>
<ul>
<li>清除主节点复制文件</li>
</ul>
</ul>
<div id="highlighter_581305" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>1</code></td>
<td class="content"><code class="plain">RESET MASTER;</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<ul>
<ul>
<li>终止从节点复制</li>
</ul>
</ul>
<div id="highlighter_959654" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>1</code></td>
<td class="content"><code class="plain">STOP SLAVE;</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<ul>
<ul>
<li>清除从节点复制文件</li>
</ul>
</ul>
<div id="highlighter_478195" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>1</code></td>
<td class="content"><code class="plain">RESET SLAVE;</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<ul>
<ul>
<li>查看主节点复制状态</li>
</ul>
</ul>
<div id="highlighter_848180" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>1</code></td>
<td class="content"><code class="plain">SHOW MASTER STATUS\G;</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<p>结果示例：</p>
<div id="highlighter_727691" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>1</code></td>
<td class="content"><code class="plain">*************************** 1. row ***************************</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>2</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">File: m-bin.000001</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>3</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Position: 956</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>4</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Binlog_Do_DB:</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>5</code></td>
<td class="content"><code class="plain">Binlog_Ignore_DB:</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>6</code></td>
<td class="content"><code class="plain">1 row in set (0.00 sec)</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<ul>
<ul>
<li>查看从节点复制状态</li>
</ul>
</ul>
<div id="highlighter_238688" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>1</code></td>
<td class="content"><code class="plain">SHOW SLAVE STATUS\G;</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<p>结果示例：</p>
<div id="highlighter_564155" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>01</code></td>
<td class="content"><code class="plain">*************************** 1. row ***************************</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>02</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Slave_IO_State: Waiting for master to send event</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>03</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Master_Host: m1</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>04</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Master_User: repli_user</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>05</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Master_Port: 3306</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>06</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Connect_Retry: 60</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>07</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Master_Log_File: m-bin.000001</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>08</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Read_Master_Log_Pos: 956</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>09</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Relay_Log_File: slave-relay-bin.000002</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>10</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Relay_Log_Pos: 1097</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>11</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Relay_Master_Log_File: m-bin.000001</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>12</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Slave_IO_Running: Yes</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>13</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Slave_SQL_Running: Yes</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>14</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Replicate_Do_DB:</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>15</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Replicate_Ignore_DB:</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>16</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Replicate_Do_Table:</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>17</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Replicate_Ignore_Table:</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>18</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Replicate_Wild_Do_Table:</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>19</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;</code><code class="plain">Replicate_Wild_Ignore_Table:</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>20</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Last_Errno: 0</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>21</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Last_Error:</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>22</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Skip_Counter: 0</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>23</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Exec_Master_Log_Pos: 956</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>24</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Relay_Log_Space: 1252</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>25</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Until_Condition: None</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>26</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Until_Log_File:</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>27</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Until_Log_Pos: 0</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>28</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Master_SSL_Allowed: No</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>29</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Master_SSL_CA_File:</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>30</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Master_SSL_CA_Path:</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>31</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Master_SSL_Cert:</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>32</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Master_SSL_Cipher:</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>33</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Master_SSL_Key:</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>34</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Seconds_Behind_Master: 0</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>35</code></td>
<td class="content"><code class="plain">Master_SSL_Verify_Server_Cert: No</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>36</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Last_IO_Errno: 0</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>37</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Last_IO_Error:</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>38</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Last_SQL_Errno: 0</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>39</code></td>
<td class="content"><code class="spaces">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="plain">Last_SQL_Error:</code></td>
</tr>
</tbody>
</table>
</div>
<div class="line alt2">
<table>
<tbody>
<tr>
<td class="number"><code>40</code></td>
<td class="content"><code class="plain">1 row in set (0.00 sec)</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<ul>
<ul>
<li>查看BINLOG列表</li>
</ul>
</ul>
<div id="highlighter_653187" class="syntaxhighlighter  ">
<div class="lines">
<div class="line alt1">
<table>
<tbody>
<tr>
<td class="number"><code>1</code></td>
<td class="content"><code class="plain">SHOW </code><code class="keyword">BINARY</code> <code class="plain">LOGS\G</code></td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
<div id="i_signature"><a href="http://creativecommons.org/licenses/by-nc-sa/4.0" target="_blank" rel="license"><img src="https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png" alt="Creative Commons License" align="left" /></a>本文基于<a title="Attribution-NonCommercial 4.0 Unported" href="http://creativecommons.org/licenses/by-nc-sa/4.0/deed.zh" target="_blank">署名-非商业性使用-相同方式共享 4.0</a>许可协议发布，欢迎转载、使用、重新发布，但务必保留文章署名<a href="http://shiyanjun.cn/" target="_blank">时延军</a>（包含链接），不得用于商业目的，基于本文修改后的作品务必以相同的许可发布。如有任何疑问，请与我<a href="mailto:i@shiyanjun.cn" target="_blank">联系</a>。</p>
</div>
