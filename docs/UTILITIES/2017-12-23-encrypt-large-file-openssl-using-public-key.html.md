---
layout: post
status: publish
published: true
title: How to encrypt a large file in openssl using public key


date: '2017-12-23 10:52:30 +0800'
date_gmt: '2017-12-23 02:52:30 +0800'
categories:
- Util
- Opensource
tags:
- openssl
- encrypt
comments: []
---
<p>See:&nbsp;https://stackoverflow.com/questions/7143514/how-to-encrypt-a-large-file-in-openssl-using-public-key</p>
<div class="post-text">
<blockquote><p>Generate a symmetric key because you can encrypt large files with it</p>
<pre><code>openssl rand -base64 32 > key.bin
</code></pre>
<p>Encrypt the large file using the symmetric key</p>
<pre><code>openssl enc -aes-256-cbc -salt -in myLargeFile.xml \
  -out myLargeFile.xml.enc -pass file:./key.bin
</code></pre>
<p>Encrypt the symmetric key so you can safely send it to the other person</p>
<pre><code>openssl rsautl -encrypt -inkey public.pem -pubin -in key.bin -out key.bin.enc
</code></pre>
<p>Destroy the un-encrypted symmetric key so nobody finds it</p>
<pre><code>shred -u key.bin
or: gshred -u key.bin </code></pre>
<p>At this point, you send the encrypted symmetric key (<code>key.bin.enc</code>) and the encrypted large file (<code>myLargeFile.xml.enc</code>) to the other person</p>
<p>The other person can then decrypt the symmetric key with their private key using</p>
<pre><code>openssl rsautl -decrypt -inkey private.pem -in key.bin.enc -out key.bin
</code></pre>
<p>Now they can use the symmetric key to decrypt the file</p>
<pre><code>openssl enc -d -aes-256-cbc -in myLargeFile.xml.enc \
  -out myLargeFile.xml -pass file:./key.bin
</code></pre>
</blockquote>
<p>And you're done. The other person has the decrypted file and it was safely sent.</p>
</div>
<p>&nbsp;</p>
