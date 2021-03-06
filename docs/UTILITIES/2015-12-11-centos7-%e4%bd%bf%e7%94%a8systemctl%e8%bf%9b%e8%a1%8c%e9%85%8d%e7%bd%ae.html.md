---
layout: post
status: publish
published: true
title: CentOS7 使用systemctl进行配置


date: '2015-12-11 21:47:05 +0800'
date_gmt: '2015-12-11 13:47:05 +0800'
categories:
- Util
tags:
- centos
- systemctl
- service
comments: []
---
<h1>1，centos7 使用 systemctl 替换了 service命令</h1>
<div>参考：redhat文档：</div>
<div><a href="https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/System_Administrators_Guide/sect-Managing_Services_with_systemd-Services.html#sect-Managing_Services_with_systemd-Services-List" target="_blank">https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/System_Administrators_Guide/sect-Managing_Services_with_systemd-Services.html#sect-Managing_Services_with_systemd-Services-List</a></div>
<p>查看全部服务命令：<br />
systemctl list-unit-files --type service<br />
查看服务<br />
systemctl status name.service<br />
启动服务<br />
systemctl start name.service<br />
停止服务<br />
systemctl stop name.service<br />
重启服务<br />
systemctl restart name.service增加开机启动<br />
systemctl enable name.service<br />
删除开机启动<br />
systemctl disable name.service<br />
其中.service 可以省略。</p>
<h1><a name="t1"></a></h1>
<h1><a name="t2"></a>2，tomcat增加启动参数</h1>
<div></div>
<p>tomcat 需要增加一个pid文件</p>
<p>在tomca/bin 目录下面，增加&nbsp;setenv.sh 配置，catalina.sh启动的时候会调用，同时配置java内存参数。</p>
<div class="dp-highlighter bg_plain">
<div class="bar">
<div class="tools"><b>[plain]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/freewebsys/article/details/41646081#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/freewebsys/article/details/41646081#">copy</a><a class="PrintSource" title="print" href="http://blog.csdn.net/freewebsys/article/details/41646081#">print</a><a class="About" title="?" href="http://blog.csdn.net/freewebsys/article/details/41646081#">?</a><a title="在CODE上查看代码片" href="https://code.csdn.net/snippets/538184" target="_blank"><img src="https://code.csdn.net/assets/CODE_ico.png" alt="在CODE上查看代码片" width="12" height="12" /></a><a title="派生到我的代码片" href="https://code.csdn.net/snippets/538184/fork" target="_blank"><img src="https://code.csdn.net/assets/ico_fork.svg" alt="派生到我的代码片" width="12" height="12" /></a></p>
<div><embed id="ZeroClipboardMovie_1" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="29" height="15" align="middle" name="ZeroClipboardMovie_1"></embed></div>
</div>
</div>
<ol start="1">
<li class="alt">#add&nbsp;tomcat&nbsp;pid</li>
<li class="">CATALINA_PID="$CATALINA_BASE/tomcat.pid"</li>
<li class="alt">#add&nbsp;java&nbsp;opts</li>
<li class="">JAVA_OPTS="-server&nbsp;-XX:PermSize=256M&nbsp;-XX:MaxPermSize=1024m&nbsp;-Xms512M&nbsp;-Xmx1024M&nbsp;-XX:MaxNewSize=256m"</li>
</ol>
</div>
<p>&nbsp;</p>
<h1><a name="t3"></a>3，增加tomcat.service</h1>
<p>在/usr/lib/systemd/system目录下增加tomcat.service，目录必须是绝对目录。</p>
<div class="dp-highlighter bg_plain">
<div class="bar">
<div class="tools"><b>[plain]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/freewebsys/article/details/41646081#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/freewebsys/article/details/41646081#">copy</a><a class="PrintSource" title="print" href="http://blog.csdn.net/freewebsys/article/details/41646081#">print</a><a class="About" title="?" href="http://blog.csdn.net/freewebsys/article/details/41646081#">?</a><a title="在CODE上查看代码片" href="https://code.csdn.net/snippets/538184" target="_blank"><img src="https://code.csdn.net/assets/CODE_ico.png" alt="在CODE上查看代码片" width="12" height="12" /></a><a title="派生到我的代码片" href="https://code.csdn.net/snippets/538184/fork" target="_blank"><img src="https://code.csdn.net/assets/ico_fork.svg" alt="派生到我的代码片" width="12" height="12" /></a></p>
<div><embed id="ZeroClipboardMovie_2" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="29" height="15" align="middle" name="ZeroClipboardMovie_2"></embed></div>
</div>
</div>
<ol start="1">
<li class="alt">[Unit]</li>
<li class="">Description=Tomcat</li>
<li class="alt">After=syslog.target&nbsp;network.target&nbsp;remote-fs.target&nbsp;nss-lookup.target</li>
<li class=""></li>
<li class="alt">[Service]</li>
<li class="">Type=forking</li>
<li class="alt">PIDFile=/data/tomcat/tomcat.pid</li>
<li class="">ExecStart=/data/tomcat/bin/startup.sh</li>
<li class="alt">ExecReload=/bin/kill&nbsp;-s&nbsp;HUP&nbsp;$MAINPID</li>
<li class="">ExecStop=/bin/kill&nbsp;-s&nbsp;QUIT&nbsp;$MAINPID</li>
<li class="alt">PrivateTmp=true</li>
<li class=""></li>
<li class="alt">[Install]</li>
<li class="">WantedBy=multi-user.target</li>
</ol>
</div>
<p>[unit]配置了服务的描述，规定了在network启动之后执行。[service]配置服务的pid，服务的启动，停止，重启。[install]配置了使用用户。</p>
<h1><a name="t4"></a>4，使用tomcat.service</h1>
<p>配置开机启动</p>
<p>systemctl enable tomcat</p>
<p>启动tomcat<br />
systemctl start tomcat<br />
停止tomcat<br />
systemctl stop tomcat<br />
重启tomcat<br />
systemctl restart tomcat</p>
<p>因为配置pid，在启动的时候会再tomcat根目录生成tomcat.pid文件，停止之后删除。</p>
<p>同时tomcat在启动时候，执行start不会启动两个tomcat，保证始终只有一个tomcat服务在运行。</p>
<p>多个tomcat可以配置在多个目录下，互不影响。</p>
<p>摘自『http://blog.csdn.net/freewebsys/article/details/41646081』</p>
