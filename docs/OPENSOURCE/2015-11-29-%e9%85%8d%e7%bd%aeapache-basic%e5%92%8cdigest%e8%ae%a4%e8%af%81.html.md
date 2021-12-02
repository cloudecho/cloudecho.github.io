---
layout: post
status: publish
published: true
title: 配置Apache Basic和Digest认证


date: '2015-11-29 10:50:10 +0800'
date_gmt: '2015-11-29 02:50:10 +0800'
categories:
- Opensource
tags:
- apache2
- httpd
comments: []
---
<p>Apache常见的用户认证可以分为下面三种：</p>
<ul>
<li>基于IP，子网的访问控制(ACL)</li>
<li>基本用户验证(Basic Authentication)</li>
<li>消息摘要式身份验证(Digest Authentication)</li>
</ul>
<h3></h3>
<h3>基本身份验证</h3>
<p>原理：<br />
一个页面访问请求</p>
<div>
<div id="highlighter_622056" class="syntaxhighlighter notranslate text">
<table border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td class="gutter">
<div class="line number1 index0 alt2">1</div>
<div class="line number2 index1 alt1">2</div>
</td>
<td class="code">
<div class="container">
<div class="line number1 index0 alt2"><code class="text plain">GET /auth/basic/ HTTP/1.1</code></div>
<div class="line number2 index1 alt1"><code class="text plain">Host: target</code></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>Web服务器要求用书输入用户凭据（服务器返回401响应头和&rsquo;realm&rsquo;）</p>
<div>
<div id="highlighter_918943" class="syntaxhighlighter notranslate text">
<table border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td class="gutter">
<div class="line number1 index0 alt2">1</div>
<div class="line number2 index1 alt1">2</div>
<div class="line number3 index2 alt2">3</div>
<div class="line number4 index3 alt1">4</div>
<div class="line number5 index4 alt2">5</div>
<div class="line number6 index5 alt1">6</div>
<div class="line number7 index6 alt2">7</div>
</td>
<td class="code">
<div class="container">
<div class="line number1 index0 alt2"><code class="text plain">HTTP/1.1 401 Authorization Required</code></div>
<div class="line number2 index1 alt1"><code class="text plain">Date: Sat, 08 Jun 2013 12:52:40 GMT</code></div>
<div class="line number3 index2 alt2"><code class="text plain">WWW-Authenticate: Basic realm="Basic auth Dir"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </code></div>
<div class="line number4 index3 alt1"><code class="text plain">Content-Length: 401</code></div>
<div class="line number5 index4 alt2"><code class="text plain">Keep-Alive: timeout=15, max=100</code></div>
<div class="line number6 index5 alt1"><code class="text plain">Connection: Keep-Alive</code></div>
<div class="line number7 index6 alt2"><code class="text plain">Content-Type: text/html; charset=iso-8859-1</code></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>浏览器弹出登录窗口(包含&rsquo;realm&rsquo;)，要求用提供用户名/密码</p>
<div>
<div id="highlighter_480004" class="syntaxhighlighter notranslate text">
<table border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td class="gutter">
<div class="line number1 index0 alt2">1</div>
<div class="line number2 index1 alt1">2</div>
<div class="line number3 index2 alt2">3</div>
</td>
<td class="code">
<div class="container">
<div class="line number1 index0 alt2"><code class="text plain">GET /auth/basic/ HTTP/1.1</code></div>
<div class="line number2 index1 alt1"><code class="text plain">Host: target</code></div>
<div class="line number3 index2 alt2"><code class="text plain">Authorization: Basic TGVuZ1dhOjEyMzQ1Ng==&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //Basic后面就是LengWa:123456经过Base64编码后的字符串</code></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>服务器将用户输入的凭据和服务器端的凭据进行比较。如果一直则返回所请求页面的响应。</p>
<p>配置: &ndash; 以保护/data/www/auth/basic为例</p>
<p>Step 1： 创建密码文件，并添加第一个用户。</p>
<div>
<div id="highlighter_575777" class="syntaxhighlighter notranslate text">
<table border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td class="gutter">
<div class="line number1 index0 alt2">1</div>
<div class="line number2 index1 alt1">2</div>
<div class="line number3 index2 alt2">3</div>
<div class="line number4 index3 alt1">4</div>
</td>
<td class="code">
<div class="container">
<div class="line number1 index0 alt2"><code class="text plain">/usr/local/apache/bin> ./htpasswd -c /data/www/auth/basic/user.txt LengWa </code></div>
<div class="line number2 index1 alt1"><code class="text plain">New password:&nbsp; </code></div>
<div class="line number3 index2 alt2"><code class="text plain">Re-type new password:&nbsp;&nbsp; </code></div>
<div class="line number4 index3 alt1"><code class="text plain">Adding password for user LengWa</code></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>-c = create file</p>
<p>常规添加不要使用-c选项，因为它会覆盖现有的文件。</p>
<p>设置文件所有权和权限（root可以进行读写，Apache Group只可以读取）</p>
<div>
<div id="highlighter_357952" class="syntaxhighlighter notranslate text">
<table border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td class="gutter">
<div class="line number1 index0 alt2">1</div>
<div class="line number2 index1 alt1">2</div>
</td>
<td class="code">
<div class="container">
<div class="line number1 index0 alt2"><code class="text plain">/data/www/auth/basic > ls -l </code></div>
<div class="line number2 index1 alt1"><code class="text plain">-rw-r-----&nbsp;&nbsp; 1 root&nbsp;&nbsp;&nbsp;&nbsp; httpd&nbsp;&nbsp;&nbsp; ...&nbsp;&nbsp; user.txt</code></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>注意： 在密码文件中，密码是加密存贮的(eg: LengWa:$apr1$MBvROZKM$wP.pdlMonB0P4xGZwl.8G0)。但是在网络中是明文传输的。</p>
<p>Step 2： 配置httpd.conf</p>
<div>
<div id="highlighter_828752" class="syntaxhighlighter notranslate text">
<table border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td class="gutter">
<div class="line number1 index0 alt2">1</div>
<div class="line number2 index1 alt1">2</div>
<div class="line number3 index2 alt2">3</div>
<div class="line number4 index3 alt1">4</div>
<div class="line number5 index4 alt2">5</div>
<div class="line number6 index5 alt1">6</div>
</td>
<td class="code">
<div class="container">
<div class="line number1 index0 alt2"><code class="text plain"><Directory "/data/www/auth/basic"></code></div>
<div class="line number2 index1 alt1"><code class="text spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="text plain">Options Indexes FollowSymLinks</code></div>
<div class="line number3 index2 alt2"><code class="text spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="text plain">allowoverride authconfig</code></div>
<div class="line number4 index3 alt1"><code class="text spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="text plain">order allow,deny</code></div>
<div class="line number5 index4 alt2"><code class="text spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="text plain">allow from all</code></div>
<div class="line number6 index5 alt1"><code class="text plain"></Directory></code></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>Step3: 编辑/data/www/auth/basic/.htaccess</p>
<div>
<div id="highlighter_471976" class="syntaxhighlighter notranslate text">
<table border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td class="gutter">
<div class="line number1 index0 alt2">1</div>
<div class="line number2 index1 alt1">2</div>
<div class="line number3 index2 alt2">3</div>
<div class="line number4 index3 alt1">4</div>
</td>
<td class="code">
<div class="container">
<div class="line number1 index0 alt2"><code class="text plain">AuthName "Basic Auth Dir"</code></div>
<div class="line number2 index1 alt1"><code class="text plain">AuthType Basic</code></div>
<div class="line number3 index2 alt2"><code class="text plain">AuthUserFile /data/www/auth/basic/user.txt</code></div>
<div class="line number4 index3 alt1"><code class="text plain">require valid-user</code></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>重新启动Apache服务器，访问 http://127.0.0.1/auth/basic/ 验证加密。</p>
<p>我前面说过这种加密在网络中传输时是明文传输 Base64 编码，我不认为这是一种加密算法)的。如果你感兴趣，可以抓包看看。</p>
<p>&nbsp;</p>
<h3>消息摘要式身份验证(Digest Authentication)</h3>
<p>原理：</p>
<p>Digest Authentication在基本身份验证上面扩展了安全性. 服务器为每一连接生成一个唯一的随机数, 客户端对用这个随机数对密码进行MD5加密. 然后发送到服务器. 服务器端也用此随机数对密码加密, 然后和客户端传送过来的加密数据进行比较.</p>
<p>一个页面访问请求</p>
<div>
<div id="highlighter_839966" class="syntaxhighlighter notranslate text">
<table border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td class="gutter">
<div class="line number1 index0 alt2">1</div>
<div class="line number2 index1 alt1">2</div>
</td>
<td class="code">
<div class="container">
<div class="line number1 index0 alt2"><code class="text plain">GET /auth/basic/&nbsp; HTTP/1.1</code></div>
<div class="line number2 index1 alt1"><code class="text plain">Host: target</code></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>Web服务器要求用书输入用户凭据(服务器返回401响应头和&rsquo;realm&rsquo;)</p>
<div>
<div id="highlighter_713581" class="syntaxhighlighter notranslate text">
<table border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td class="gutter">
<div class="line number1 index0 alt2">1</div>
<div class="line number2 index1 alt1">2</div>
<div class="line number3 index2 alt2">3</div>
<div class="line number4 index3 alt1">4</div>
<div class="line number5 index4 alt2">5</div>
<div class="line number6 index5 alt1">6</div>
<div class="line number7 index6 alt2">7</div>
</td>
<td class="code">
<div class="container">
<div class="line number1 index0 alt2"><code class="text plain">HTTP/1.1 401 Unauthorized</code></div>
<div class="line number2 index1 alt1"><code class="text plain">WWW-Authenticate: Digest realm="Digest Encrypt", </code></div>
<div class="line number3 index2 alt2"><code class="text plain">nonce="nmeEHKLeBAA=aa6ac7ab3cae8f1b73b04e1e3048179777a174b3", </code></div>
<div class="line number4 index3 alt1"><code class="text plain">opaque="0000000000000000", \</code></div>
<div class="line number5 index4 alt2"><code class="text plain">stale=false, </code></div>
<div class="line number6 index5 alt1"><code class="text plain">algorithm=MD5, </code></div>
<div class="line number7 index6 alt2"><code class="text plain">qop="auth"</code></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>浏览器弹出登录窗口(包含&rsquo;realm&rsquo;), 要求用提供用户名/密码</p>
<div>
<div id="highlighter_29271" class="syntaxhighlighter notranslate text">
<table border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td class="gutter">
<div class="line number1 index0 alt2">1</div>
<div class="line number2 index1 alt1">2</div>
<div class="line number3 index2 alt2">3</div>
<div class="line number4 index3 alt1">4</div>
<div class="line number5 index4 alt2">5</div>
<div class="line number6 index5 alt1">6</div>
<div class="line number7 index6 alt2">7</div>
<div class="line number8 index7 alt1">8</div>
<div class="line number9 index8 alt2">9</div>
<div class="line number10 index9 alt1">10</div>
<div class="line number11 index10 alt2">11</div>
<div class="line number12 index11 alt1">12</div>
</td>
<td class="code">
<div class="container">
<div class="line number1 index0 alt2"><code class="text plain">GET /auth/digest/ HTTP/1.1</code></div>
<div class="line number2 index1 alt1"><code class="text plain">Accept: */*</code></div>
<div class="line number3 index2 alt2"><code class="text plain">Authorization:&nbsp; Digest username="LengWa", </code></div>
<div class="line number4 index3 alt1"><code class="text plain">realm="Digest Encrypt", </code></div>
<div class="line number5 index4 alt2"><code class="text plain">qop="auth", </code></div>
<div class="line number6 index5 alt1"><code class="text plain">algorithm="MD5", </code></div>
<div class="line number7 index6 alt2"><code class="text plain">uri="/auth/digest/", </code></div>
<div class="line number8 index7 alt1"><code class="text plain">nonce="nmeEHKLeBAA=aa6ac7ab3cae8f1b73b04e1e3048179777a174b3", </code></div>
<div class="line number9 index8 alt2"><code class="text plain">nc=00000001, </code></div>
<div class="line number10 index9 alt1"><code class="text plain">cnonce="6092d3a53e37bb44b3a6e0159974108b", </code></div>
<div class="line number11 index10 alt2"><code class="text plain">opaque="0000000000000000", </code></div>
<div class="line number12 index11 alt1"><code class="text plain">response="652b2f336aeb085d8dd9d887848c3314"</code></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>服务器将用户输入加密后的凭据和服务器端加密后的的凭据进行比较.如果一致则返回所请求页面的响应.</p>
<p><strong>配置</strong>:</p>
<p>Step 1: 创建密码文件</p>
<p>语法:</p>
<div>
<div id="highlighter_868748" class="syntaxhighlighter notranslate text">
<table border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td class="gutter">
<div class="line number1 index0 alt2">1</div>
<div class="line number2 index1 alt1">2</div>
<div class="line number3 index2 alt2">3</div>
<div class="line number4 index3 alt1">4</div>
<div class="line number5 index4 alt2">5</div>
<div class="line number6 index5 alt1">6</div>
</td>
<td class="code">
<div class="container">
<div class="line number1 index0 alt2"><code class="text plain">htdiget [-c] passwordfile realm username</code></div>
<div class="line number2 index1 alt1"></div>
<div class="line number3 index2 alt2"><code class="text plain">/usr/local/apache/bin> ./htdigest -c /data/www/auth/digest/user.txt "Digest Encrypt" LengWa</code></div>
<div class="line number4 index3 alt1"><code class="text plain">Adding password for LengWa in realm "Digest Encrypt" .</code></div>
<div class="line number5 index4 alt2"><code class="text plain">New password:</code></div>
<div class="line number6 index5 alt1"><code class="text plain">Re-type new password:</code></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>-c = create file</p>
<p>常规添加不要使用-c选项, 因为它会覆盖现有的文件.</p>
<p>设置文件所有权和权限(root可以进行读写, Apache Group只可以读取)</p>
<div>
<div id="highlighter_460509" class="syntaxhighlighter notranslate text">
<table border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td class="gutter">
<div class="line number1 index0 alt2">1</div>
<div class="line number2 index1 alt1">2</div>
</td>
<td class="code">
<div class="container">
<div class="line number1 index0 alt2"><code class="text plain">/data/www/auth/digest/ > ls -l </code></div>
<div class="line number2 index1 alt1"><code class="text plain">-rw-r-----&nbsp;&nbsp; 1 root&nbsp;&nbsp;&nbsp;&nbsp; httpd&nbsp;&nbsp;&nbsp; ...&nbsp;&nbsp; user.txt</code></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>user.txt格式: LengWa:Digest Encrypt:d95ea4412b0fb517b25c4c46f32e5a2b</p>
<p>Step2: 配置httpd.conf</p>
<div>
<div id="highlighter_963765" class="syntaxhighlighter notranslate text ">
<table border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td class="gutter">
<div class="line number1 index0 alt2">1</div>
<div class="line number2 index1 alt1">2</div>
<div class="line number3 index2 alt2">3</div>
<div class="line number4 index3 alt1">4</div>
<div class="line number5 index4 alt2">5</div>
<div class="line number6 index5 alt1">6</div>
<div class="line number7 index6 alt2">7</div>
<div class="line number8 index7 alt1">8</div>
</td>
<td class="code">
<div class="container">
<div class="container">
<div class="line number1 index0 alt2"><code class="text plain"><Directory "/data/www/auth/digest"></code></div>
<div class="line number2 index1 alt1"><code class="text spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="text plain">Options Indexes FollowSymLinks</code></div>
<div class="line number3 index2 alt2"><code class="text spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="text plain">AuthType Digest</code></div>
<div class="line number4 index3 alt1"><code class="text spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="text plain">AuthName "Digest Encrypt"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //注意这里的AuthName和上面的realm必须一致(而Basic验证则可以不同). 否则你输入正确的用户密码也无法通过认证</code></div>
<div class="line number5 index4 alt2"><code class="text spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="text plain">AuthDigestProvider file</code></div>
<div class="line number6 index5 alt1"><code class="text spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="text plain">AuthUserFile /data/www/auth/digest/user.txt</code></div>
<div class="line number7 index6 alt2"><code class="text spaces">&nbsp;&nbsp;&nbsp;&nbsp;</code><code class="text plain">require valid-user</code></div>
<div class="line number8 index7 alt1"><code class="text plain"></Directory></code></div>
<div class="line number8 index7 alt1"></div>
</div>
</div>
<div class="container">
<div class="line number8 index7 alt1">
<p class="p1"><span class="s1"><strong>注</strong>：这里的Directory 也可用 Location 。</span></p>
</div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>现在基于Digest的验证环境就搭建好了.</p>
<p>注: 在Basic验证中. 我使用了.htaccess 而在Digest验证中我没有使用. 只是为了个人的需要. 你可以根据自己需要进行配置.</p>
<p>疑惑: 对于在配置Digest httpd.conf时, AuthName 必须和上面的realm还是不是很明白. 为什么必须一致. 如果有哪位大神知道. 望不吝赐教。</p>
<p>&nbsp;</p>
<h3>总结:</h3>
<p>Basic验证方式配置相对简单，但是安全性太低，不适合一些加密要求比较高的站点。</p>
<p>Digest则相反，加密性是很高，但是配置起来还是有一点难度的，所以大家根据自己需要，选择不同的加密方式。</p>
<p>摘自『http://blog.jobbole.com/41519/』</p>
