---
layout: post
status: publish
published: true
title: Turn any Linux computer into SOCKS5 proxy in one command


date: '2015-09-26 08:58:26 +0800'
date_gmt: '2015-09-26 00:58:26 +0800'
categories:
- Util
tags: []
comments: []
---
<div></div>
<div>I thought I'd do a shorter article on catonmat this time. It goes hand in hand with my upcoming article series on "100% technical guide to anonymity" and it's much easier to write larger articles in smaller pieces. Then I can edit them together and produce the final article.</div>
<div>
<p>This article will be interesting for those who didn't know it already -- you can turn any Linux computer into a SOCKS5 (and SOCKS4) proxy in just one command:</p>
<pre>ssh -N -D 0.0.0.0:1080 localhost</pre>
<p>And it doesn't require root privileges. The&nbsp;<code>ssh</code>&nbsp;command starts up dynamic&nbsp;<code>-D</code>&nbsp;port forwarding on port<code>1080</code>&nbsp;and talks to the clients via SOCSK5 or SOCKS4 protocols, just like a regular SOCKS5 proxy would! The&nbsp;<code>-N</code>&nbsp;option makes sure ssh stays idle and doesn't execute any commands on localhost.</p>
<p>If you also wish the command to go into background as a daemon, then add&nbsp;<code>-f</code>&nbsp;option:</p>
<pre><strong>ssh -f -N -D 0.0.0.0:1080 localhost</strong></pre>
<p>To use it, just make your software use SOCKS5 proxy on your Linux computer's IP, port 1080, and you're done, all your requests now get proxied.</p>
<p>Access control can be implemented via&nbsp;<code>iptables</code>. For example, to allow only people from the ip<code>1.2.3.4</code>&nbsp;to use the SOCKS5 proxy, add the following&nbsp;<code>iptables</code>&nbsp;rules:</p>
<pre>iptables -A INPUT --src 1.2.3.4 -p tcp --dport 1080 -j ACCEPT
iptables -A INPUT -p tcp --dport 1080 -j REJECT
</pre>
<p>The first rule says, allow anyone from&nbsp;<code>1.2.3.4</code>&nbsp;to connect to port&nbsp;<code>1080</code>, and the other rule says, deny everyone else from connecting to port&nbsp;<code>1080</code>.</p>
<p>Surely, executing&nbsp;<code>iptables</code>&nbsp;requires root privileges. If you don't have root privileges, and you don't want to leave your proxy open (and you really don't want to do that), you'll have to use some kind of a simple TCP proxy wrapper to do access control.</p>
<p>Here, I wrote one in Perl. It's called&nbsp;<code>tcp-proxy.pl</code>&nbsp;and it uses&nbsp;<code>IO::Socket::INET</code>&nbsp;to abstract sockets, and&nbsp;<code>IO::Select</code>&nbsp;to do connection multiplexing.</p>
<div class="highlight">
<pre class="lotsofcode"><span class="c1">#!/usr/bin/perl</span> <span class="c1">#</span> <span class="k">use</span> <span class="n">warnings</span><span class="p">;</span> <span class="k">use</span> <span class="n">strict</span><span class="p">;</span> <span class="k">use</span> <span class="nn">IO::Socket::</span><span class="n">INET</span><span class="p">;</span> <span class="k">use</span> <span class="nn">IO::</span><span class="n">Select</span><span class="p">;</span> <span class="k">my</span> <span class="nv">@allowed_ips</span> <span class="o">=</span> <span class="p">(</span><span class="s">'1.2.3.4'</span><span class="p">,</span> <span class="s">'5.6.7.8'</span><span class="p">,</span> <span class="s">'127.0.0.1'</span><span class="p">,</span> <span class="s">'192.168.1.2'</span><span class="p">);</span> <span class="k">my</span> <span class="nv">$ioset</span> <span class="o">=</span> <span class="nn">IO::</span><span class="n">Select</span><span class="o">-></span><span class="k">new</span><span class="p">;</span> <span class="k">my</span> <span class="nv">%socket_map</span><span class="p">;</span> <span class="k">my</span> <span class="nv">$debug</span> <span class="o">=</span> <span class="mi">1</span><span class="p">;</span> <span class="k">sub </span><span class="nf">new_conn</span> <span class="p">{</span> <span class="k">my</span> <span class="p">(</span><span class="nv">$host</span><span class="p">,</span> <span class="nv">$port</span><span class="p">)</span> <span class="o">=</span> <span class="nv">@_</span><span class="p">;</span> <span class="k">return</span> <span class="nn">IO::Socket::</span><span class="n">INET</span><span class="o">-></span><span class="k">new</span><span class="p">(</span> <span class="n">PeerAddr</span> <span class="o">=></span> <span class="nv">$host</span><span class="p">,</span> <span class="n">PeerPort</span> <span class="o">=></span> <span class="nv">$port</span> <span class="p">)</span> <span class="o">||</span> <span class="nb">die</span> <span class="s">"Unable to connect to $host:$port: $!"</span><span class="p">;</span> <span class="p">}</span> <span class="k">sub </span><span class="nf">new_server</span> <span class="p">{</span> <span class="k">my</span> <span class="p">(</span><span class="nv">$host</span><span class="p">,</span> <span class="nv">$port</span><span class="p">)</span> <span class="o">=</span> <span class="nv">@_</span><span class="p">;</span> <span class="k">my</span> <span class="nv">$server</span> <span class="o">=</span> <span class="nn">IO::Socket::</span><span class="n">INET</span><span class="o">-></span><span class="k">new</span><span class="p">(</span> <span class="n">LocalAddr</span> <span class="o">=></span> <span class="nv">$host</span><span class="p">,</span> <span class="n">LocalPort</span> <span class="o">=></span> <span class="nv">$port</span><span class="p">,</span> <span class="n">ReuseAddr</span> <span class="o">=></span> <span class="mi">1</span><span class="p">,</span> <span class="n">Listen</span> <span class="o">=></span> <span class="mi">100</span> <span class="p">)</span> <span class="o">||</span> <span class="nb">die</span> <span class="s">"Unable to listen on $host:$port: $!"</span><span class="p">;</span> <span class="p">}</span> <span class="k">sub </span><span class="nf">new_connection</span> <span class="p">{</span> <span class="k">my</span> <span class="nv">$server</span> <span class="o">=</span> <span class="nb">shift</span><span class="p">;</span> <span class="k">my</span> <span class="nv">$client</span> <span class="o">=</span> <span class="nv">$server</span><span class="o">-></span><span class="nb">accept</span><span class="p">;</span> <span class="k">my</span> <span class="nv">$client_ip</span> <span class="o">=</span> <span class="n">client_ip</span><span class="p">(</span><span class="nv">$client</span><span class="p">);</span> <span class="k">unless</span> <span class="p">(</span><span class="n">client_allowed</span><span class="p">(</span><span class="nv">$client</span><span class="p">))</span> <span class="p">{</span> <span class="k">print</span> <span class="s">"Connection from $client_ip denied.\n"</span> <span class="k">if</span> <span class="nv">$debug</span><span class="p">;</span> <span class="nv">$client</span><span class="o">-></span><span class="nb">close</span><span class="p">;</span> <span class="k">return</span><span class="p">;</span> <span class="p">}</span> <span class="k">print</span> <span class="s">"Connection from $client_ip accepted.\n"</span> <span class="k">if</span> <span class="nv">$debug</span><span class="p">;</span> <span class="k">my</span> <span class="nv">$remote</span> <span class="o">=</span> <span class="n">new_conn</span><span class="p">(</span><span class="s">'localhost'</span><span class="p">,</span> <span class="mi">55555</span><span class="p">);</span> <span class="nv">$ioset</span><span class="o">-></span><span class="n">add</span><span class="p">(</span><span class="nv">$client</span><span class="p">);</span> <span class="nv">$ioset</span><span class="o">-></span><span class="n">add</span><span class="p">(</span><span class="nv">$remote</span><span class="p">);</span> <span class="nv">$socket_map</span><span class="p">{</span><span class="nv">$client</span><span class="p">}</span> <span class="o">=</span> <span class="nv">$remote</span><span class="p">;</span> <span class="nv">$socket_map</span><span class="p">{</span><span class="nv">$remote</span><span class="p">}</span> <span class="o">=</span> <span class="nv">$client</span><span class="p">;</span> <span class="p">}</span> <span class="k">sub </span><span class="nf">close_connection</span> <span class="p">{</span> <span class="k">my</span> <span class="nv">$client</span> <span class="o">=</span> <span class="nb">shift</span><span class="p">;</span> <span class="k">my</span> <span class="nv">$client_ip</span> <span class="o">=</span> <span class="n">client_ip</span><span class="p">(</span><span class="nv">$client</span><span class="p">);</span> <span class="k">my</span> <span class="nv">$remote</span> <span class="o">=</span> <span class="nv">$socket_map</span><span class="p">{</span><span class="nv">$client</span><span class="p">};</span> <span class="nv">$ioset</span><span class="o">-></span><span class="n">remove</span><span class="p">(</span><span class="nv">$client</span><span class="p">);</span> <span class="nv">$ioset</span><span class="o">-></span><span class="n">remove</span><span class="p">(</span><span class="nv">$remote</span><span class="p">);</span> <span class="nb">delete</span> <span class="nv">$socket_map</span><span class="p">{</span><span class="nv">$client</span><span class="p">};</span> <span class="nb">delete</span> <span class="nv">$socket_map</span><span class="p">{</span><span class="nv">$remote</span><span class="p">};</span> <span class="nv">$client</span><span class="o">-></span><span class="nb">close</span><span class="p">;</span> <span class="nv">$remote</span><span class="o">-></span><span class="nb">close</span><span class="p">;</span> <span class="k">print</span> <span class="s">"Connection from $client_ip closed.\n"</span> <span class="k">if</span> <span class="nv">$debug</span><span class="p">;</span> <span class="p">}</span> <span class="k">sub </span><span class="nf">client_ip</span> <span class="p">{</span> <span class="k">my</span> <span class="nv">$client</span> <span class="o">=</span> <span class="nb">shift</span><span class="p">;</span> <span class="k">return</span> <span class="n">inet_ntoa</span><span class="p">(</span><span class="nv">$client</span><span class="o">-></span><span class="n">sockaddr</span><span class="p">);</span> <span class="p">}</span> <span class="k">sub </span><span class="nf">client_allowed</span> <span class="p">{</span> <span class="k">my</span> <span class="nv">$client</span> <span class="o">=</span> <span class="nb">shift</span><span class="p">;</span> <span class="k">my</span> <span class="nv">$client_ip</span> <span class="o">=</span> <span class="n">client_ip</span><span class="p">(</span><span class="nv">$client</span><span class="p">);</span> <span class="k">return</span> <span class="nb">grep</span> <span class="p">{</span> <span class="nv">$_</span> <span class="ow">eq</span> <span class="nv">$client_ip</span> <span class="p">}</span> <span class="nv">@allowed_ips</span><span class="p">;</span> <span class="p">}</span> <span class="k">print</span> <span class="s">"Starting a server on 0.0.0.0:1080\n"</span><span class="p">;</span> <span class="k">my</span> <span class="nv">$server</span> <span class="o">=</span> <span class="n">new_server</span><span class="p">(</span><span class="s">'0.0.0.0'</span><span class="p">,</span> <span class="mi">1080</span><span class="p">);</span> <span class="nv">$ioset</span><span class="o">-></span><span class="n">add</span><span class="p">(</span><span class="nv">$server</span><span class="p">);</span> <span class="k">while</span> <span class="p">(</span><span class="mi">1</span><span class="p">)</span> <span class="p">{</span> <span class="k">for</span> <span class="k">my</span> <span class="nv">$socket</span> <span class="p">(</span><span class="nv">$ioset</span><span class="o">-></span><span class="n">can_read</span><span class="p">)</span> <span class="p">{</span> <span class="k">if</span> <span class="p">(</span><span class="nv">$socket</span> <span class="o">==</span> <span class="nv">$server</span><span class="p">)</span> <span class="p">{</span> <span class="n">new_connection</span><span class="p">(</span><span class="nv">$server</span><span class="p">);</span> <span class="p">}</span> <span class="k">else</span> <span class="p">{</span> <span class="k">next</span> <span class="k">unless</span> <span class="nb">exists</span> <span class="nv">$socket_map</span><span class="p">{</span><span class="nv">$socket</span><span class="p">};</span> <span class="k">my</span> <span class="nv">$remote</span> <span class="o">=</span> <span class="nv">$socket_map</span><span class="p">{</span><span class="nv">$socket</span><span class="p">};</span> <span class="k">my</span> <span class="nv">$buffer</span><span class="p">;</span> <span class="k">my</span> <span class="nv">$read</span> <span class="o">=</span> <span class="nv">$socket</span><span class="o">-></span><span class="nb">sysread</span><span class="p">(</span><span class="nv">$buffer</span><span class="p">,</span> <span class="mi">4096</span><span class="p">);</span> <span class="k">if</span> <span class="p">(</span><span class="nv">$read</span><span class="p">)</span> <span class="p">{</span> <span class="nv">$remote</span><span class="o">-></span><span class="nb">syswrite</span><span class="p">(</span><span class="nv">$buffer</span><span class="p">);</span> <span class="p">}</span> <span class="k">else</span> <span class="p">{</span> <span class="n">close_connection</span><span class="p">(</span><span class="nv">$socket</span><span class="p">);</span> <span class="p">}</span> <span class="p">}</span> <span class="p">}</span> <span class="p">}</span></pre>
</div>
<p>To use it, you'll have to make a change to the previous configuration. Instead of running ssh SOCKS5 proxy on&nbsp;<code>0.0.0.0:1080</code>, you'll need to run it on&nbsp;<code>localhost:55555</code>,</p>
<pre>ssh -f -N -D 55555 localhost</pre>
<p>After that, run the&nbsp;<code>tcp-proxy.pl</code>,</p>
<pre>perl tcp-proxy.pl &amp;</pre>
<p>The TCP proxy will start listening on&nbsp;<code>0.0.0.0:1080</code>&nbsp;and will redirect only the allowed IPs in<code>@allowed_ips</code>&nbsp;list to&nbsp;<code>localhost:55555</code>.</p>
<p>Another possibility is to use another computer instead of your own as exit node. What I mean is you can do the following:</p>
<pre>ssh -f -N -D 1080 other_computer.com</pre>
<p>This will set up a SOCKS5 proxy on&nbsp;<code>localhost:1080</code>&nbsp;but when you use it, ssh will automatically tunnel your requests (encrypted) via&nbsp;<code>other_computer.com</code>. This way you can hide what you're doing on the Internet from anyone who might be sniffing your link. They will see that you're doing something but the traffic will be encrypted so they won't be able to tell what you're doing.</p>
<p>That's it. You're now the proxy king!</p>
<div class="download">
<div class="download-title">
<p>Download tcp-proxy.pl</p>
</div>
<p>Download link:&nbsp;<a title="Download "tcp proxy (tcp-proxy.pl)"" href="http://www.catonmat.net/download/tcp-proxy.pl" data-ke-src="http://www.catonmat.net/download/tcp-proxy.pl">tcp proxy (tcp-proxy.pl)</a><br />
Download URL:&nbsp;<code>http://www.catonmat.net/download/tcp-proxy.pl</code><br />
Downloaded: 6262 times</p>
<p>I also pushed the tcp-proxy.pl to GitHub:&nbsp;<a href="http://github.com/pkrumins/perl-tcp-proxy" data-ke-src="http://github.com/pkrumins/perl-tcp-proxy">tcp-proxy.pl on GitHub</a>. This project is also pretty nifty to generalize and make a program that redirects between any number of hosts:ports, not just two.</p>
</div>
<p>PS. I will probably also write "A definitive guide to ssh port forwarding" some time in the future because it's an interesting but little understood topic.</p>
</div>
<div>『摘自』http://blog.urfix.com/25-ssh-commands-tricks/</div>
<p>&nbsp;</p>