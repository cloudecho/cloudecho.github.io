---
layout: post
status: publish
published: true
title: Secure cookie with HttpOnly and Secure flag in Apache


date: '2016-01-16 20:40:58 +0800'
date_gmt: '2016-01-16 12:40:58 +0800'
categories:
- Opensource
tags:
- apache2
- XSS
comments: []
---
<h3>Secure Apache Web Server from XSS Attack</h3>
<p>Do you know you can mitigate most common XSS attack using <a href="https://www.owasp.org/index.php/HttpOnly" target="_blank" rel="nofollow">HttpOnly</a> and Secure flag with your cookie? <a href="https://www.owasp.org/index.php/Cross-site_Scripting_(XSS)" target="_blank" rel="nofollow">XSS</a> is dangerous, very dangerous. By looking at increasing number of XSS attack on daily basis, you must secure you web applications.</p>
<p>Without having <strong>HttpOnly</strong> and <strong>Secure</strong> flag in HTTP response header, it is possible to steal or manipulate web application session and cookies. It&rsquo;s good practice to set HttpOnly and Secure flag in application code by developers. However, due to bad programming or developers&rsquo; unawareness it comes to Web Infrastructures.</p>
<p>I will not talk about how to set these at code level. You can refer <a href="http://www.owasp.org/index.php/HttpOnly" target="_blank" rel="nofollow">here</a>.</p>
<p>While performing <a href="http://geekflare.com/scan-security-vulnerabilities-to-secure-website/">security test</a> on web applications, it&rsquo;s expected that you will have to fix these to pass the penetration test. This is how you can fix these in Apache Web Server.</p>
<h3>Implement in Apache:</h3>
<p>1.&nbsp;&nbsp;&nbsp;&nbsp; Ensure you have <strong>mod_headers.so</strong> enabled in Apache instance</p>
<p>2.&nbsp;&nbsp;&nbsp;&nbsp; Add following entry in <strong>httpd.conf</strong></p>
<pre>Header edit Set-Cookie ^(.*)$ $1;HttpOnly;Secure</pre>
<p>3.&nbsp;&nbsp;&nbsp;&nbsp; Restart Apache Web Server</p>
<p><strong>Note:</strong> Header edit is not compatible with <a href="http://httpd.apache.org/docs/2.2/mod/mod_headers.html" target="_blank" rel="nofollow">lower than Apache 2.2.4 version</a>. You can use following to set HttpOnly and Secure flag in lower than 2.2.4 version. Thanks to Ytse for sharing this information.</p>
<pre>Header set Set-Cookie HttpOnly;Secure</pre>
<h3>Verification:</h3>
<p>Open your website with HTTP Watch, Live HTTP Header or <a href="http://tools.geekflare.com/seo/tool.php?id=check-headers">HTTP Header Online tool</a>.</p>
<p>Check HTTP response header, you should see as highlighted</p>
<p><img class="alignnone" src="http://geekflare.com/images/technical/cookie-httponly-secure.png" alt="" width="754" height="144" /></p>
<div class="nc_socialPanel sw_flatFresh sw_d_fullColor sw_i_fullColor sw_o_fullColor notMobile sw_three" data-position="both" data-float="floatBottom" data-count="4" data-floatcolor="#ffffff" data-scale="1.2" data-align="fullWidth"></div>
<div class="nc_socialPanel sw_flatFresh sw_d_fullColor sw_i_fullColor sw_o_fullColor notMobile sw_three" data-position="both" data-float="floatBottom" data-count="4" data-floatcolor="#ffffff" data-scale="1.2" data-align="fullWidth">摘自「http://geekflare.com/httponly-secure-cookie-apache/」</div>
