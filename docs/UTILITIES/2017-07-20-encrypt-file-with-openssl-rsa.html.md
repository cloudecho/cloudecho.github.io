---
layout: post
status: publish
published: true
title: Encrypt file with openssl RSA


date: '2017-07-20 10:54:15 +0800'
date_gmt: '2017-07-20 02:54:15 +0800'
categories:
- Util
tags:
- openssl
- rsa
- encrypt
comments: []
---
<p><strong>生成一个密钥：</strong></p>
<div class="cnblogs_code">
<pre>openssl genrsa -out test.key 1024</pre>
</div>
<p>这里-out指定生成文件的。需要注意的是这个文件包含了<strong>公钥和密钥两部分</strong>，也就是说这个文件即可用来加密也可以用来解密。后面的1024是生成密钥的长度。</p>
<p><strong>openssl可以将这个文件中的公钥提取出来：</strong></p>
<div class="cnblogs_code">
<pre>openssl rsa -in test.key -pubout -out test_pub.key</pre>
</div>
<p>-in指定输入文件，-out指定提取生成公钥的文件名。至此，我们手上就有了一个公钥，一个私钥（包含公钥）。现在可以将用公钥来加密文件了。</p>
<p>我在目录中创建一个hello的文本文件，然后利用此前<strong>生成的公钥加密文件</strong>：</p>
<div class="cnblogs_code">
<pre>openssl rsautl -encrypt -in hello -inkey test_pub.key -pubin -out hello.en</pre>
</div>
<p>-in指定要加密的文件，-inkey指定密钥，-pubin表明是用纯公钥文件加密，-out为加密后的文件。</p>
<p><strong>解密文件：</strong></p>
<div class="cnblogs_code">
<pre>openssl rsautl -decrypt -in hello.en -inkey test.key -out hello.de</pre>
</div>
<p>-in指定被加密的文件，-inkey指定私钥文件，-out为解密后的文件。</p>
<p>&nbsp;</p>
<p>Source:&nbsp;https://www.cnblogs.com/alittlebitcool/archive/2011/09/22/2185418.html</p>
