---
layout: post
status: publish
published: true
title: maven 发布artifact到中央库


date: '2015-11-27 09:07:14 +0800'
date_gmt: '2015-11-27 01:07:14 +0800'
categories:
- Opensource
tags:
- maven
comments: []
---
<p>步骤一：注册账号，申请ticket。<br />
注册在这里：<a href="https://issues.sonatype.org/" target="_blank">https://issues.sonatype.org</a><br />
申请ticket：创建一个issue，注意这里要选OSSRH，且是PROJECT而不是TASK，group id要慎重写，不能写你没有权限的，不然服务人员会让你重写（半天左右）。<br />
申请成功后会提示：Configuration has been prepared, now you can:please comment on this ticket when you promoted your first release, thanks<br />
步骤二：GPG，签名和加密用。<br />
下载：<a href="https://www.gnupg.org/download/index.html" target="_blank">https://www.gnupg.org/download/index.html</a><br />
注意：签名的名字，邮箱和步骤一的一样，记住passphrase用于下面步骤。<br />
步骤三：编译和提交文件。<br />
注意事项：</p>
<p>1）.m2\settings.xml文件中要加入：</p>
<div class="dp-highlighter bg_html">
<div class="bar">
<div class="tools"><b>[html]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/afirsraftgarrier/article/details/46452935#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/afirsraftgarrier/article/details/46452935#">copy</a></p>
<div><embed id="ZeroClipboardMovie_1" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_1"></embed></div>
</div>
</div>
<ol class="dp-xml" start="1">
<li class="alt"><span class="tag"><</span><span class="tag-name">servers</span><span class="tag">></span></li>
<li class="">&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">server</span><span class="tag">></span></li>
<li class="alt">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">id</span><span class="tag">></span>sonatype-nexus-snapshots<span class="tag"></</span><span class="tag-name">id</span><span class="tag">></span></li>
<li class="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">username</span><span class="tag">></span>your-jira-username<span class="tag"></</span><span class="tag-name">username</span><span class="tag">></span></li>
<li class="alt">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">password</span><span class="tag">></span>your-jira-password<span class="tag"></</span><span class="tag-name">password</span><span class="tag">></span></li>
<li class="">&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"></</span><span class="tag-name">server</span><span class="tag">></span></li>
<li class="alt">&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">server</span><span class="tag">></span></li>
<li class="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">id</span><span class="tag">></span>sonatype-nexus-staging<span class="tag"></</span><span class="tag-name">id</span><span class="tag">></span></li>
<li class="alt">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">username</span><span class="tag">></span>your-jira-username<span class="tag"></</span><span class="tag-name">username</span><span class="tag">></span></li>
<li class="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">password</span><span class="tag">></span>your-jira-password<span class="tag"></</span><span class="tag-name">password</span><span class="tag">></span></li>
<li class="alt">&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"></</span><span class="tag-name">server</span><span class="tag">></span></li>
<li class=""><span class="tag"></</span><span class="tag-name">servers</span><span class="tag">></span></li>
</ol>
</div>
<p>2) &nbsp;pom.xml文件中要加入（project标签下）：</p>
<div class="dp-highlighter bg_html">
<div class="bar">
<div class="tools"><b>[html]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/afirsraftgarrier/article/details/46452935#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/afirsraftgarrier/article/details/46452935#">copy</a></p>
<div><embed id="ZeroClipboardMovie_2" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_2"></embed></div>
</div>
</div>
<ol class="dp-xml" start="1">
<li class="alt"><span class="tag"><</span><span class="tag-name">parent</span><span class="tag">></span></li>
<li class="">&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">groupId</span><span class="tag">></span>org.sonatype.oss<span class="tag"></</span><span class="tag-name">groupId</span><span class="tag">></span></li>
<li class="alt">&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">artifactId</span><span class="tag">></span>oss-parent<span class="tag"></</span><span class="tag-name">artifactId</span><span class="tag">></span></li>
<li class="">&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">version</span><span class="tag">></span>7<span class="tag"></</span><span class="tag-name">version</span><span class="tag">></span></li>
<li class="alt"><span class="tag"></</span><span class="tag-name">parent</span><span class="tag">></span></li>
</ol>
</div>
<p>3）如果出现javadoc编译不通过的可以在javadoc插件下加入：</p>
<div class="dp-highlighter bg_html">
<div class="bar">
<div class="tools"><b>[html]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/afirsraftgarrier/article/details/46452935#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/afirsraftgarrier/article/details/46452935#">copy</a></p>
<div><embed id="ZeroClipboardMovie_3" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_3"></embed></div>
</div>
</div>
<ol class="dp-xml" start="1">
<li class="alt"><span class="tag"><</span><span class="tag-name">configuration</span><span class="tag">></span></li>
<li class="">&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">additionalparam</span><span class="tag">></span>-Xdoclint:none<span class="tag"></</span><span class="tag-name">additionalparam</span><span class="tag">></span></li>
<li class="alt"><span class="tag"></</span><span class="tag-name">configuration</span><span class="tag">></span></li>
</ol>
</div>
<p>4） 注意如过时release要加入：</p>
<div class="dp-highlighter bg_html">
<div class="bar">
<div class="tools"><b>[html]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/afirsraftgarrier/article/details/46452935#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/afirsraftgarrier/article/details/46452935#">copy</a></p>
<div><embed id="ZeroClipboardMovie_4" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_4"></embed></div>
</div>
</div>
<ol class="dp-xml" start="1">
<li class="alt"><span class="tag"><</span><span class="tag-name">plugin</span><span class="tag">></span></li>
<li class="">&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">groupId</span><span class="tag">></span>org.apache.maven.plugins<span class="tag"></</span><span class="tag-name">groupId</span><span class="tag">></span></li>
<li class="alt">&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">artifactId</span><span class="tag">></span>maven-gpg-plugin<span class="tag"></</span><span class="tag-name">artifactId</span><span class="tag">></span></li>
<li class="">&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">version</span><span class="tag">></span>${maven-gpg-plugin.version}<span class="tag"></</span><span class="tag-name">version</span><span class="tag">></span></li>
<li class="alt">&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">executions</span><span class="tag">></span></li>
<li class="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">execution</span><span class="tag">></span></li>
<li class="alt">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">phase</span><span class="tag">></span>verify<span class="tag"></</span><span class="tag-name">phase</span><span class="tag">></span></li>
<li class="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">goals</span><span class="tag">></span></li>
<li class="alt">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">goal</span><span class="tag">></span>sign<span class="tag"></</span><span class="tag-name">goal</span><span class="tag">></span></li>
<li class="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"></</span><span class="tag-name">goals</span><span class="tag">></span></li>
<li class="alt">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"></</span><span class="tag-name">execution</span><span class="tag">></span></li>
<li class="">&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"></</span><span class="tag-name">executions</span><span class="tag">></span></li>
<li class="alt"><span class="tag"></</span><span class="tag-name">plugin</span><span class="tag">></span></li>
</ol>
</div>
<p>5) 如果是java web项目，javadoc可能会报错：找不到类javax.servlet.ServletContext，可以添加依赖：</p>
<div class="dp-highlighter bg_html">
<div class="bar">
<div class="tools"><b>[html]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/afirsraftgarrier/article/details/46452935#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/afirsraftgarrier/article/details/46452935#">copy</a></p>
<div><embed id="ZeroClipboardMovie_5" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_5"></embed></div>
</div>
</div>
<ol class="dp-xml" start="1">
<li class="alt"><span class="tag"><</span><span class="tag-name">dependency</span><span class="tag">></span></li>
<li class="">&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">groupId</span><span class="tag">></span>javax.servlet<span class="tag"></</span><span class="tag-name">groupId</span><span class="tag">></span></li>
<li class="alt">&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">artifactId</span><span class="tag">></span>javax.servlet-api<span class="tag"></</span><span class="tag-name">artifactId</span><span class="tag">></span></li>
<li class="">&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">version</span><span class="tag">></span>3.0.1<span class="tag"></</span><span class="tag-name">version</span><span class="tag">></span></li>
<li class="alt">&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag"><</span><span class="tag-name">scope</span><span class="tag">></span>provided<span class="tag"></</span><span class="tag-name">scope</span><span class="tag">></span></li>
<li class=""><span class="tag"></</span><span class="tag-name">dependency</span><span class="tag">></span></li>
</ol>
</div>
<p>6) POM编写可参考<a href="https://github.com/ACC-GIT/ACCWeb/blob/master/pom.xml" target="_blank">https://github.com/ACC-GIT/ACCWeb/blob/master/pom.xml</a></p>
<p>步骤四：release和提示同步。<br />
先在<a href="https://oss.sonatype.org/#stagingRepositories" target="_blank">https://oss.sonatype.org/#stagingRepositories</a>进行close,release等操作（注意这里会检测）<br />
然后在issue中回复服务人员，提出同步到中央库（半天左右）。</p>
<p>摘自「互联网」</p>
