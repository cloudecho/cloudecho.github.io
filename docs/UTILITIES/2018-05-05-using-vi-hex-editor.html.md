---
layout: post
status: publish
published: true
title: Using vi as a hex editor


date: '2018-05-05 14:30:17 +0800'
date_gmt: '2018-05-05 06:30:17 +0800'
categories:
- Util
tags:
- vi
- hex
- editor
comments: []
---
<div>Source: http://www.kevssite.com/using-vi-as-a-hex-editor/</div>
<div class="date">Written on April 21, 2009 by Kev</div>
<div class="entry">
Sometimes I find it useful to switch to hex mode when editing a file in vi. The command for switching is not very obvious so thought I&rsquo;d share&hellip;</p>
<p>So, open a file in vi as usual. To switch into hex mode hit escape and type:</p>
<figure class="highlight">
<pre><code class="language-bash" data-lang="bash">:%!xxd</code></pre>
</figure>
<p>And when your done and want to exit from hex mode hit escape again and type:</p>
<figure class="highlight">
<pre><code class="language-bash" data-lang="bash">:%!xxd -r</code></pre>
</figure>
<p>Okay, so this isn&rsquo;t actaully switching to vi&rsquo;s &lsquo;hex mode&rsquo;; vi doesn&rsquo;t have one. What the above actually does is to stream vi&rsquo;s buffer through the external program &lsquo;xxd&rsquo;.</p>
</div>
<p><audio style="display: none;" controls="controls"></audio></p>
