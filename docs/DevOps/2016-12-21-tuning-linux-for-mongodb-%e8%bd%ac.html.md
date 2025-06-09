---
layout: post
status: publish
published: true
title: Tuning Linux for MongoDB -- 转


date: '2016-12-21 19:52:41 +0800'
date_gmt: '2016-12-21 11:52:41 +0800'
categories:
- Database
- Opensource
tags:
- mongodb
- nosql
- 大数据
comments: []
---
<header class="entry-header">
<h1 class="entry-title display-1">Tuning Linux for MongoDB</h1>
<p class="text-left meta-block"><a class="author url fn" title="Posts by Tim Vaillancourt" href="https://www.percona.com/blog/author/tim-vaillancourt/" rel="author">Tim Vaillancourt</a> &nbsp;|&nbsp;August 12, 2016&nbsp;|&nbsp; Posted In: <a href="https://www.percona.com/blog/category/mongodb/" rel="category tag">MongoDB</a></p>
</header>
<div class="entry-content">
<p><a href="https://www.percona.com/blog/wp-content/uploads/2016/03/tuning-Linux-for-MongoDB.png" target="_blank" data-slb-active="1" data-slb-asset="1301279218" data-slb-internal="0" data-slb-group="36990"><img class="alignright size-full wp-image-37361" src="https://www.percona.com/blog/wp-content/uploads/2016/03/tuning-Linux-for-MongoDB.png" sizes="(max-width: 272px) 100vw, 272px" srcset="https://www.percona.com/blog/wp-content/uploads/2016/03/tuning-Linux-for-MongoDB.png 272w, https://www.percona.com/blog/wp-content/uploads/2016/03/tuning-Linux-for-MongoDB-136x150.png 136w" alt="tuning Linux for MongoDB" width="272" height="300" /></a>In this post, we&rsquo;ll discuss tuning Linux for MongoDB deployments.</p>
<p>By far the most common operating system you&rsquo;ll see MongoDB running on is Linux 2.6 and 3.x. Linux flavors such as CentOS and Debian do a fantastic job of being a stable, general-purpose operating system. Linux runs software on hardware ranging from tiny computers like&nbsp;the Raspberry Pi up to massive data center servers. To make this flexibility work, however, Linux defaults to some &ldquo;lowest common denominator&rdquo; tunings so that the OS will boot&nbsp;on anything.</p>
<p>Working with databases, we often focus on the queries, patterns and tunings that happen inside the database process itself. This means we sometimes forget that the operating system below it is the life-support of database, the air that it breathes so-to-speak.&nbsp;Of course, a highly-scalable database such as MongoDB runs fine on these general-purpose defaults without complaints, but the efficiency can be&nbsp;equivalent to running in regular shoes&nbsp;instead of&nbsp;sleek&nbsp;runners. At small scale, you might not notice the lost efficiency, but at large scale (<em>especially when data exceeds RAM</em>) improved&nbsp;tunings equate&nbsp;to fewer servers and less operational costs. For all use cases and scale, good OS tunings also provide some improvement in response times and removes extra &ldquo;what if&hellip;?&rdquo; questions when troubleshooting.</p>
<p>Overall, memory, network and disk are the system resources important to MongoDB. This article&nbsp;covers how to optimize each of these areas. Of course, while we have successfully deployed&nbsp;these tunings to many live systems, it&rsquo;s always best to test before applying changes to your&nbsp;servers.</p>
<p>If you plan on applying these changes, I suggest performing them&nbsp;with one full reboot of the host. Some of these changes don&rsquo;t require a reboot, but test that they get re-applied if you reboot in the future. MongoDB&rsquo;s clustered nature should make this&nbsp;relatively painless, plus it might be a good time to do that dreaded &ldquo;<em>yum upgrade</em>&rdquo; / &ldquo;<em>aptitude upgrade</em>&ldquo;, too.</p>
<h5><strong>Linux Ulimit</strong></h5>
<p>To prevent&nbsp;a single user from impacting the entire&nbsp;system, Linux has a facility to implement some system resource constraints on processes, file handles and other system resources on a per-user-basis. For medium-high-usage MongoDB deployments, the default limits are almost always too low. Considering MongoDB generally uses dedicated hardware, it makes sense to allow the Linux user running MongoDB (<em>e.g., &ldquo;mongod&rdquo;</em>) to use a majority of the available resources.</p>
<p>Now you might be thinking: &ldquo;Why not disable the limit (<em>or set it to unlimited</em>)?&rdquo; This is a common recommendation for database servers.&nbsp;I think you should avoid this for two reasons:</p>
<ul>
<li>If you hit a problem, a lack of a limit on system resources can allow a relatively smaller problem to spiral out of control, often bringing down other services (such as SSH) crucial to solving the original problem.</li>
<li>All systems DO&nbsp;have an upper-limit, and understanding those limitations instead of masking them is an important exercise.</li>
</ul>
<p>In most cases, a limit of 64,000 &ldquo;max user processes&rdquo; and 64,000 &ldquo;open files&rdquo; (<em>both have defaults of 1024</em>) will suffice. To be more exact you need to do some math on the number of applications/clients, the maximum size of their connection pools and some case-by-case tuning for the number of inter-node connections between replica set members and sharding processes. (We might address this in a future blog post.)</p>
<p>You can deploy these limits by adding a file in &ldquo;<em>/etc/security/limits.d&rdquo;</em>&nbsp;(<em>or appending to &ldquo;/etc/security/limits.conf&rdquo; i</em>f there is no<em>&nbsp;&ldquo;limits.d&rdquo;)</em>. Below is an example file for the Linux user &ldquo;<em>mongod&rdquo;</em>, raising open-file and max-user-process limits to 64,000:</p>
<div id="crayon-585a44bc91167481632746" class="crayon-syntax crayon-theme-familiar crayon-font-monaco crayon-os-pc print-yes notranslate" data-settings=" minimize scroll-mouseover">
<div class="crayon-toolbar" data-settings=" show"><span class="crayon-title">/etc/security/limits.d/mongod.conf</span></p>
<div class="crayon-tools">
<div class="crayon-button crayon-nums-button crayon-pressed" title="Toggle Line Numbers"></div>
<div class="crayon-button crayon-plain-button" title="Toggle Plain Code"></div>
<div class="crayon-button crayon-wrap-button" title="Toggle Line Wrap"></div>
<div class="crayon-button crayon-copy-button" title="Copy"></div>
<div class="crayon-button crayon-popup-button" title="Open Code In New Window"></div>
<p><span class="crayon-language">Shell</span></div>
</div>
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-585a44bc91167481632746-1">1</div>
<div class="crayon-num crayon-striped-num" data-line="crayon-585a44bc91167481632746-2">2</div>
<div class="crayon-num" data-line="crayon-585a44bc91167481632746-3">3</div>
<div class="crayon-num crayon-striped-num" data-line="crayon-585a44bc91167481632746-4">4</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-585a44bc91167481632746-1" class="crayon-line"><span class="crayon-i">mongod</span> &nbsp; &nbsp; &nbsp; <span class="crayon-i">soft</span> &nbsp; &nbsp; &nbsp; &nbsp;<span class="crayon-i">nproc</span> &nbsp; &nbsp; &nbsp; &nbsp;<span class="crayon-cn">64000</span></div>
<div id="crayon-585a44bc91167481632746-2" class="crayon-line crayon-striped-line"><span class="crayon-i">mongod</span> &nbsp; &nbsp; &nbsp; <span class="crayon-i">hard</span> &nbsp; &nbsp; &nbsp; &nbsp;<span class="crayon-i">nproc</span> &nbsp; &nbsp; &nbsp; &nbsp;<span class="crayon-cn">64000</span></div>
<div id="crayon-585a44bc91167481632746-3" class="crayon-line"><span class="crayon-i">mongod</span> &nbsp; &nbsp; &nbsp; <span class="crayon-i">soft</span> &nbsp; &nbsp; &nbsp; &nbsp;<span class="crayon-i">nofile</span> &nbsp; &nbsp; &nbsp; <span class="crayon-cn">64000</span></div>
<div id="crayon-585a44bc91167481632746-4" class="crayon-line crayon-striped-line"><span class="crayon-i">mongod</span> &nbsp; &nbsp; &nbsp; <span class="crayon-i">hard</span> &nbsp; &nbsp; &nbsp; &nbsp;<span class="crayon-i">nofile</span> &nbsp; &nbsp; &nbsp; <span class="crayon-cn">64000</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p><em>Note: this change only applies to new shells, meaning you must restart &ldquo;mongod&rdquo; or &ldquo;mongos&rdquo; to apply this change!</em></p>
<h5><strong>Virtual Memory</strong></h5>
<h6>Dirty Ratio</h6>
<p>The &ldquo;dirty_ratio&rdquo; is the percentage of total system memory that can hold dirty pages. The default on most Linux hosts is&nbsp;between 20-30%. When you exceed the limit the dirty pages are committed&nbsp;to disk, creating a small pause. To avoid this hard pause there is a second ratio: &ldquo;dirty_background_ratio&rdquo; (<em>default 10-15%</em>) which tells the kernel to start flushing dirty pages to disk in the background without any pause.</p>
<p>20-30% is a good general default for &ldquo;dirty_ratio&rdquo;, but on large-memory database servers this can be a lot of memory! For example, on a 128GB-memory host this can allow up to 38.4GB of dirty pages. The background ratio won&rsquo;t kick in until 12.8GB! We recommend that you&nbsp;lower this setting and monitor the impact to query performance and disk IO. The goal is&nbsp;reducing&nbsp;memory usage without impacting query performance negatively. Reducing caches sizes also guarantees data gets written to disk in smaller batches more frequently, which increases disk throughput (than huge&nbsp;bulk writes less often).</p>
<p>A recommended setting for dirty ratios on large-memory (<em>64GB+ perhaps</em>) database servers is: &ldquo;<em>vm.dirty_ratio = 15&Prime;</em>&nbsp;and <em>&ldquo;</em><em>vm.dirty_background_ratio = 5&Prime;</em>, or possibly less. (<em>Red Hat recommends lower ratios of</em>&nbsp;<em>10 and 3 for high-performance/large-memory servers.</em>)</p>
<p>You&nbsp;can set this&nbsp;by adding the following lines to <em>&ldquo;</em><em>/etc/sysctl.conf&rdquo;</em>:</p>
<div id="crayon-585a44bc9117e939361894" class="crayon-syntax crayon-theme-familiar crayon-font-monaco crayon-os-pc print-yes notranslate" data-settings=" minimize scroll-mouseover">
<div class="crayon-toolbar" data-settings=" show">
<div class="crayon-tools">
<div class="crayon-button crayon-nums-button crayon-pressed" title="Toggle Line Numbers"></div>
<div class="crayon-button crayon-plain-button" title="Toggle Plain Code"></div>
<div class="crayon-button crayon-wrap-button" title="Toggle Line Wrap"></div>
<div class="crayon-button crayon-copy-button" title="Copy"></div>
<div class="crayon-button crayon-popup-button" title="Open Code In New Window"></div>
<p><span class="crayon-language">Shell</span></div>
</div>
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-585a44bc9117e939361894-1">1</div>
<div class="crayon-num crayon-striped-num" data-line="crayon-585a44bc9117e939361894-2">2</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-585a44bc9117e939361894-1" class="crayon-line"><span class="crayon-v">vm</span><span class="crayon-e">.dirty_ratio</span> <span class="crayon-o">=</span> <span class="crayon-cn">15</span></div>
<div id="crayon-585a44bc9117e939361894-2" class="crayon-line crayon-striped-line"><span class="crayon-v">vm</span><span class="crayon-e">.dirty_background_ratio</span> <span class="crayon-o">=</span> <span class="crayon-cn">5</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>To check these current running values:</p>
<div id="crayon-585a44bc91187272776590" class="crayon-syntax crayon-theme-familiar crayon-font-monaco crayon-os-pc print-yes notranslate" data-settings=" minimize scroll-mouseover">
<div class="crayon-toolbar" data-settings=" show">
<div class="crayon-tools">
<div class="crayon-button crayon-nums-button crayon-pressed" title="Toggle Line Numbers"></div>
<div class="crayon-button crayon-plain-button" title="Toggle Plain Code"></div>
<div class="crayon-button crayon-wrap-button" title="Toggle Line Wrap"></div>
<div class="crayon-button crayon-copy-button" title="Copy"></div>
<div class="crayon-button crayon-popup-button" title="Open Code In New Window"></div>
<p><span class="crayon-language">Shell</span></div>
</div>
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-585a44bc91187272776590-1">1</div>
<div class="crayon-num crayon-striped-num" data-line="crayon-585a44bc91187272776590-2">2</div>
<div class="crayon-num" data-line="crayon-585a44bc91187272776590-3">3</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-585a44bc91187272776590-1" class="crayon-line"><span class="crayon-sy">$</span> <span class="crayon-v">sysctl</span> <span class="crayon-o">-</span><span class="crayon-v">a</span> <span class="crayon-o">|</span> <span class="crayon-r">egrep</span> <span class="crayon-s">"vm.dirty.*_ratio"</span></div>
<div id="crayon-585a44bc91187272776590-2" class="crayon-line crayon-striped-line"><span class="crayon-v">vm</span><span class="crayon-e">.dirty_background_ratio</span> <span class="crayon-o">=</span> <span class="crayon-cn">5</span></div>
<div id="crayon-585a44bc91187272776590-3" class="crayon-line"><span class="crayon-v">vm</span><span class="crayon-e">.dirty_ratio</span> <span class="crayon-o">=</span> <span class="crayon-cn">15</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<h6>Swappiness</h6>
<p><a href="https://en.wikipedia.org/wiki/Swappiness" target="_blank" rel="nofollow">&ldquo;Swappiness&rdquo;</a> is a Linux kernel setting that influences the behavior&nbsp;of the Virtual Memory manager when it needs to allocate a swap, ranging from 0-100. A setting of <em>&ldquo;</em>0<em>&ldquo;</em> tells the kernel to swap only to avoid out-of-memory problems. A setting of 100 tells it to swap aggressively to disk. The Linux default is usually 60, which is not ideal for database usage.</p>
<p>It is common to see a setting of <em>&ldquo;</em><em>0&Prime;&nbsp;</em>(<em>or sometimes &ldquo;10&rdquo;</em>) on database servers, telling the kernel to prefer to swap to memory for&nbsp;better response times. However, Ovais Tariq details a known bug (<em>or feature</em>) when using a setting of <em>&ldquo;</em>0<em>&ldquo;</em>&nbsp;in this blog post:&nbsp;<a href="https://www.percona.com/blog/2014/04/28/oom-relation-vm-swappiness0-new-kernel/" target="_blank">https://www.percona.com/blog/2014/04/28/oom-relation-vm-swappiness0-new-kernel/</a>.</p>
<p>Due to this bug, we&nbsp;recommended using&nbsp;a setting of <em>&ldquo;</em><em>1&Prime;&nbsp;</em>(<em>or &ldquo;10&rdquo; if you &nbsp;prefer some disk swapping</em>) by adding the following to your <em>&ldquo;</em><em>/etc/sysctl.conf&rdquo;</em>:</p>
<div id="crayon-585a44bc91190189704696" class="crayon-syntax crayon-theme-familiar crayon-font-monaco crayon-os-pc print-yes notranslate" data-settings=" minimize scroll-mouseover">
<div class="crayon-toolbar" data-settings=" show"><span class="crayon-title">/etc/sysctl.conf</span></p>
<div class="crayon-tools">
<div class="crayon-button crayon-nums-button crayon-pressed" title="Toggle Line Numbers"></div>
<div class="crayon-button crayon-plain-button" title="Toggle Plain Code"></div>
<div class="crayon-button crayon-wrap-button" title="Toggle Line Wrap"></div>
<div class="crayon-button crayon-copy-button" title="Copy"></div>
<div class="crayon-button crayon-popup-button" title="Open Code In New Window"></div>
<p><span class="crayon-language">Shell</span></div>
</div>
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-585a44bc91190189704696-1">1</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-585a44bc91190189704696-1" class="crayon-line"><span class="crayon-v">vm</span><span class="crayon-e">.swappiness</span> <span class="crayon-o">=</span> <span class="crayon-cn">1</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>To check the current swappiness:</p>
<div id="crayon-585a44bc91197306939295" class="crayon-syntax crayon-theme-familiar crayon-font-monaco crayon-os-pc print-yes notranslate" data-settings=" minimize scroll-mouseover">
<div class="crayon-toolbar" data-settings=" show">
<div class="crayon-tools">
<div class="crayon-button crayon-nums-button crayon-pressed" title="Toggle Line Numbers"></div>
<div class="crayon-button crayon-plain-button" title="Toggle Plain Code"></div>
<div class="crayon-button crayon-wrap-button" title="Toggle Line Wrap"></div>
<div class="crayon-button crayon-copy-button" title="Copy"></div>
<div class="crayon-button crayon-popup-button" title="Open Code In New Window"></div>
<p><span class="crayon-language">Shell</span></div>
</div>
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-585a44bc91197306939295-1">1</div>
<div class="crayon-num crayon-striped-num" data-line="crayon-585a44bc91197306939295-2">2</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-585a44bc91197306939295-1" class="crayon-line"><span class="crayon-sy">$</span> <span class="crayon-e">sysctl </span><span class="crayon-v">vm</span><span class="crayon-e">.swappiness</span></div>
<div id="crayon-585a44bc91197306939295-2" class="crayon-line crayon-striped-line"><span class="crayon-v">vm</span><span class="crayon-e">.swappiness</span> <span class="crayon-o">=</span> <span class="crayon-cn">1</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p><em>Note: you must run the&nbsp;command &ldquo;/sbin/sysctl -p&rdquo; as root/sudo (or reboot) to&nbsp;apply a dirty_ratio or swappiness change!</em></p>
<h5><strong>Transparent HugePages</strong></h5>
<p><em>*Does not apply to Debian/Ubuntu or CentOS/RedHat 5 and lower*</em></p>
<p><a href="https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Performance_Tuning_Guide/s-memory-transhuge.html" target="_blank" rel="nofollow">Transparent HugePages</a> is an optimization introduced in CentOS/RedHat 6.0, with the goal&nbsp;of reducing&nbsp;overhead on systems with large amounts of memory. However, due to the way MongoDB uses memory, this feature actually does more harm than good as memory access are rarely contiguous.</p>
<p>Disabled THP entirely by adding the following flag below to your Linux kernel boot options:</p>
<div id="crayon-585a44bc9119f761212633" class="crayon-syntax crayon-theme-familiar crayon-font-monaco crayon-os-pc print-yes notranslate" data-settings=" minimize scroll-mouseover">
<div class="crayon-toolbar" data-settings=" show">
<div class="crayon-tools">
<div class="crayon-button crayon-nums-button crayon-pressed" title="Toggle Line Numbers"></div>
<div class="crayon-button crayon-plain-button" title="Toggle Plain Code"></div>
<div class="crayon-button crayon-wrap-button" title="Toggle Line Wrap"></div>
<div class="crayon-button crayon-copy-button" title="Copy"></div>
<div class="crayon-button crayon-popup-button" title="Open Code In New Window"></div>
<p><span class="crayon-language">Shell</span></div>
</div>
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-585a44bc9119f761212633-1">1</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-585a44bc9119f761212633-1" class="crayon-line"><span class="crayon-v">transparent_hugepage</span><span class="crayon-o">=</span><span class="crayon-v">never</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>Usually this requires changes to the GRUB boot-loader config in the directory <em>&ldquo;</em><em>/boot/grub&rdquo;</em>&nbsp;or <em>&ldquo;</em><em>/etc/grub.d&rdquo;&nbsp;</em>on newer systems. Red Hat covers this in more detail in this article (same method on CentOS):&nbsp;<a href="https://access.redhat.com/solutions/46111" target="_blank" rel="nofollow">https://access.redhat.com/solutions/46111</a>.</p>
<p><em>Note: We&nbsp;recommended rebooting&nbsp;the system to clear out any&nbsp;previous huge pages and validate that the setting will persist on reboot.</em></p>
<p><strong>NUMA (Non-Uniform Memory Access) Architecture</strong></p>
<p><a href="https://en.wikipedia.org/wiki/Non-uniform_memory_access" target="_blank" rel="nofollow">Non-Uniform Memory Access</a>&nbsp;is a recent&nbsp;memory architecture that takes into account the locality of caches and CPUs for lower latency. Unfortunately, MongoDB is not &ldquo;NUMA-aware&rdquo; and leaving NUMA setup in the default behavior can cause severe memory in-balance.</p>
<p>There are two ways to disable NUMA: one is via an on/off switch in the system BIOS config, the 2nd is using the <em>&ldquo;</em><em>numactl&rdquo;</em>&nbsp;command to set NUMA-interleaved-mode (<em>similar effect to disabling NUMA</em>) when starting MongoDB. Both methods achieve the same result. I&nbsp;lean towards using&nbsp;the <em>&ldquo;</em><em>numactl&rdquo;</em>&nbsp;command due to future-proofing yourself for the mostly inevitable addition of NUMA awareness.&nbsp;On CentOS 7+ you may need to install the <em>&ldquo;</em><em>numactl&rdquo;</em>&nbsp;yum/rpm package.</p>
<p>To make mongod start using interleaved-mode, add <em>&ldquo;</em><em>numactl &ndash;interleave=all&rdquo;</em>&nbsp;before your regular <em>&ldquo;</em><em>mongod&rdquo;</em>&nbsp;command:</p>
<div id="crayon-585a44bc911a9865639417" class="crayon-syntax crayon-theme-familiar crayon-font-monaco crayon-os-pc print-yes notranslate" data-settings=" minimize scroll-mouseover">
<div class="crayon-toolbar" data-settings=" show">
<div class="crayon-tools">
<div class="crayon-button crayon-nums-button crayon-pressed" title="Toggle Line Numbers"></div>
<div class="crayon-button crayon-plain-button" title="Toggle Plain Code"></div>
<div class="crayon-button crayon-wrap-button" title="Toggle Line Wrap"></div>
<div class="crayon-button crayon-copy-button" title="Copy"></div>
<div class="crayon-button crayon-popup-button" title="Open Code In New Window"></div>
<p><span class="crayon-language">Shell</span></div>
</div>
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-585a44bc911a9865639417-1">1</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-585a44bc911a9865639417-1" class="crayon-line"><span class="crayon-sy">$</span> <span class="crayon-v">numactl</span> <span class="crayon-o">--</span><span class="crayon-v">interleave</span><span class="crayon-o">=</span><span class="crayon-e">all </span><span class="crayon-v">mongod</span> <span class="crayon-o"><</span><span class="crayon-e">options </span><span class="crayon-v">here</span><span class="crayon-o">></span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>To check mongod&rsquo;s NUMA setting:</p>
<div id="crayon-585a44bc911b0838741479" class="crayon-syntax crayon-theme-familiar crayon-font-monaco crayon-os-pc print-yes notranslate" data-settings=" minimize scroll-mouseover">
<div class="crayon-toolbar" data-settings=" show">
<div class="crayon-tools">
<div class="crayon-button crayon-nums-button crayon-pressed" title="Toggle Line Numbers"></div>
<div class="crayon-button crayon-plain-button" title="Toggle Plain Code"></div>
<div class="crayon-button crayon-wrap-button" title="Toggle Line Wrap"></div>
<div class="crayon-button crayon-copy-button" title="Copy"></div>
<div class="crayon-button crayon-popup-button" title="Open Code In New Window"></div>
<p><span class="crayon-language">Shell</span></div>
</div>
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-585a44bc911b0838741479-1">1</div>
<div class="crayon-num crayon-striped-num" data-line="crayon-585a44bc911b0838741479-2">2</div>
<div class="crayon-num" data-line="crayon-585a44bc911b0838741479-3">3</div>
<div class="crayon-num crayon-striped-num" data-line="crayon-585a44bc911b0838741479-4">4</div>
<div class="crayon-num" data-line="crayon-585a44bc911b0838741479-5">5</div>
<div class="crayon-num crayon-striped-num" data-line="crayon-585a44bc911b0838741479-6">6</div>
<div class="crayon-num" data-line="crayon-585a44bc911b0838741479-7">7</div>
<div class="crayon-num crayon-striped-num" data-line="crayon-585a44bc911b0838741479-8">8</div>
<div class="crayon-num" data-line="crayon-585a44bc911b0838741479-9">9</div>
<div class="crayon-num crayon-striped-num" data-line="crayon-585a44bc911b0838741479-10">10</div>
<div class="crayon-num" data-line="crayon-585a44bc911b0838741479-11">11</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-585a44bc911b0838741479-1" class="crayon-line"><span class="crayon-sy">$</span> <span class="crayon-e">sudo </span><span class="crayon-v">numastat</span> <span class="crayon-o">-</span><span class="crayon-i">p</span> <span class="crayon-sy">$</span><span class="crayon-sy">(</span><span class="crayon-e">pidof </span><span class="crayon-v">mongod</span><span class="crayon-sy">)</span></div>
<div id="crayon-585a44bc911b0838741479-2" class="crayon-line crayon-striped-line"></div>
<div id="crayon-585a44bc911b0838741479-3" class="crayon-line"><span class="crayon-v">Per</span><span class="crayon-o">-</span><span class="crayon-e">node </span><span class="crayon-e">process </span><span class="crayon-e">memory </span><span class="crayon-e">usage</span> <span class="crayon-sy">(</span><span class="crayon-st">in</span> <span class="crayon-v">MBs</span><span class="crayon-sy">)</span> <span class="crayon-st">for</span> <span class="crayon-i">PID</span> <span class="crayon-cn">7516</span> <span class="crayon-sy">(</span><span class="crayon-v">mongod</span><span class="crayon-sy">)</span></div>
<div id="crayon-585a44bc911b0838741479-4" class="crayon-line crayon-striped-line"><span class="crayon-h">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><span class="crayon-i">Node</span> <span class="crayon-cn">0</span><span class="crayon-h">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><span class="crayon-v">Total</span></div>
<div id="crayon-585a44bc911b0838741479-5" class="crayon-line"><span class="crayon-h">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">-</span> <span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">-</span></div>
<div id="crayon-585a44bc911b0838741479-6" class="crayon-line crayon-striped-line"><span class="crayon-i">Huge</span><span class="crayon-h">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><span class="crayon-cn">0.00</span><span class="crayon-h">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="crayon-cn">0.00</span></div>
<div id="crayon-585a44bc911b0838741479-7" class="crayon-line"><span class="crayon-i">Heap</span><span class="crayon-h">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="crayon-cn">28.53</span><span class="crayon-h">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><span class="crayon-cn">28.53</span></div>
<div id="crayon-585a44bc911b0838741479-8" class="crayon-line crayon-striped-line"><span class="crayon-i">Stack</span><span class="crayon-h">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="crayon-cn">0.20</span><span class="crayon-h">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="crayon-cn">0.20</span></div>
<div id="crayon-585a44bc911b0838741479-9" class="crayon-line"><span class="crayon-i">Private</span><span class="crayon-h">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="crayon-cn">7.55</span><span class="crayon-h">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="crayon-cn">7.55</span></div>
<div id="crayon-585a44bc911b0838741479-10" class="crayon-line crayon-striped-line"><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-h">&nbsp;&nbsp;</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">-</span> <span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">--</span><span class="crayon-o">-</span></div>
<div id="crayon-585a44bc911b0838741479-11" class="crayon-line"><span class="crayon-i">Total</span><span class="crayon-h">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><span class="crayon-cn">36.29</span><span class="crayon-h">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><span class="crayon-cn">36.29</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>If you see only 1 x NUMA-node column (<em>&ldquo;Node0&rdquo;</em>) NUMA is disabled. If you see more than 1 x NUMA-node, make sure the metric numbers (<em>&ldquo;</em><em>Heap&rdquo;, etc</em>.) are balanced between nodes. Otherwise, NUMA is NOT&nbsp;in &ldquo;interleave&rdquo; mode.</p>
<p><em>Note: some MongoDB packages already ship logic to disable NUMA in the init/startup script. Check for this using &ldquo;grep&rdquo;&nbsp;first. Your hardware or BIOS manual should cover disabling NUMA via the system BIOS.</em></p>
<h5><strong>Block Device IO Scheduler and Read-Ahead</strong></h5>
<p>For tuning flexibility, we recommended that MongoDB data sits on its own disk volume, preferably with its own dedicated disks/RAID array. While it may complicate backups, for the best performance you can also dedicate a separate volume for the MongoDB journal to separate it&rsquo;s disk activity&nbsp;noise&nbsp;from the main data set. The journal does not yet have it&rsquo;s own config/command-line setting, so you&rsquo;ll need to mount a volume to the <em>&ldquo;</em><em>journal&rdquo;</em>&nbsp;directory inside the dbPath. For example, <em>&ldquo;</em><em>/var/lib/mongo/journal&rdquo;</em>&nbsp;would be the journal mount-path if the dbPath was set to <em>&ldquo;</em><em>/var/lib/mongo&rdquo;</em>.</p>
<p>Aside from good hardware, the block device MongoDB stores its data on can benefit from 2 x major adjustments:</p>
<h6>IO Scheduler</h6>
<p>The <a href="https://en.wikipedia.org/wiki/I/O_scheduling" target="_blank" rel="nofollow">IO scheduler</a> is an algorithm the kernel will use to commit reads and writes to disk. By default most Linux installs use the <a href="https://en.wikipedia.org/wiki/CFQ" target="_blank" rel="nofollow">CFQ (<em>Completely-Fair Queue</em>)</a> scheduler. This is designed to work well for many general use cases, but with little latency guarantees. Two other popular schedulers are <em>&ldquo;</em><a href="https://en.wikipedia.org/wiki/Deadline_scheduler" target="_blank" rel="nofollow"><em>deadline&rdquo;</em></a>&nbsp;and <em>&ldquo;</em><em><a href="https://en.wikipedia.org/wiki/Noop_scheduler" target="_blank" rel="nofollow">noop&rdquo;</a>. </em>Deadline excels at latency-sensitive use cases (<em>like databases</em>) and noop&nbsp;is closer to&nbsp;no scheduling at all.</p>
<p>We generally suggest using the <em>&ldquo;</em><em>deadline&rdquo;</em>&nbsp;IO scheduler for cases where you have real, non-virtualised disks under MongoDB. (For example, a &ldquo;bare metal&rdquo; server.) In some cases I&rsquo;ve seen <em>&ldquo;</em><em>noop&rdquo;</em>&nbsp;perform better with certain hardware RAID controllers, however. The difference between <em>&ldquo;</em><em>deadline&rdquo;</em>&nbsp;and <em>&ldquo;</em><em>cfq&rdquo;</em>&nbsp;can be massive for disk-bound deployments.</p>
<p>If you are running MongoDB inside a VM (<em>which has it&rsquo;s own IO scheduler beneath it</em>) it is best to use <em>&ldquo;</em><em>noop&rdquo;</em>&nbsp;and let the virtualization layer take care of the IO scheduling itself.</p>
<h6>Read-Ahead</h6>
<p><a href="https://en.wikipedia.org/wiki/Readahead" target="_blank" rel="nofollow">Read-ahead</a> is a per-block device performance tuning in Linux that causes data ahead of a requested block on disk&nbsp;to be read and then cached&nbsp;into the filesystem cache. Read-ahead assumes that there is a sequential read pattern and something will benefit from those extra blocks being cached. MongoDB tends to have very random disk&nbsp;patterns and&nbsp;often does not benefit from the default read-ahead setting, wasting memory that could be used for more hot data. Most Linux systems have a default setting of 128KB/256 sectors (<em>128KB = 256 x&nbsp;512-byte sectors</em>). This means if MongoDB&nbsp;fetches a 64kb document from disk, 128kb of filesystem cache is used and maybe the extra 64kb is never accessed later, wasting memory.</p>
<p>For this setting, we suggest a starting-point of 32 sectors (=<em>16KB</em>) for most MongoDB workloads. From there you can test increasing/reducing this setting and then monitor a combination of query performance, cached memory usage and disk read activity to find a better balance. You should aim to use as little cached memory as possible without dropping the query performance or causing significant disk activity.</p>
<p>Both the IO scheduler and read-ahead can be changed by adding a file to the udev configuration at <em>&ldquo;</em><em>/etc/udev/rules.</em>d&rdquo;. In this example I am assuming the block device serving mongo data is named <em>&ldquo;</em><em>/dev/sda&rdquo;</em>&nbsp;and I am setting &ldquo;<em>deadline</em>&rdquo; as the IO scheduler and 16kb/32-sectors as read-ahead:</p>
<div id="crayon-585a44bc911bd610055080" class="crayon-syntax crayon-theme-familiar crayon-font-monaco crayon-os-pc print-yes notranslate" data-settings=" minimize scroll-mouseover">
<div class="crayon-toolbar" data-settings=" show"><span class="crayon-title">/etc/udev/rules.d/60-sda.rules</span></p>
<div class="crayon-tools">
<div class="crayon-button crayon-nums-button crayon-pressed" title="Toggle Line Numbers"></div>
<div class="crayon-button crayon-plain-button" title="Toggle Plain Code"></div>
<div class="crayon-button crayon-wrap-button" title="Toggle Line Wrap"></div>
<div class="crayon-button crayon-copy-button" title="Copy"></div>
<div class="crayon-button crayon-popup-button" title="Open Code In New Window"></div>
<p><span class="crayon-language">Shell</span></div>
</div>
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-585a44bc911bd610055080-1">1</div>
<div class="crayon-num crayon-striped-num" data-line="crayon-585a44bc911bd610055080-2">2</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-585a44bc911bd610055080-1" class="crayon-line"><span class="crayon-c"># set deadline scheduler and 16kb read-ahead for /dev/sda</span></div>
<div id="crayon-585a44bc911bd610055080-2" class="crayon-line crayon-striped-line"><span class="crayon-v">ACTION</span><span class="crayon-o">==</span><span class="crayon-s">"add|change"</span><span class="crayon-sy">,</span> <span class="crayon-v">KERNEL</span><span class="crayon-o">==</span><span class="crayon-s">"sda"</span><span class="crayon-sy">,</span> <span class="crayon-e">ATTR</span><span class="crayon-sy">{</span><span class="crayon-v">queue</span><span class="crayon-o">/</span><span class="crayon-v">scheduler</span><span class="crayon-sy">}</span><span class="crayon-o">=</span><span class="crayon-s">"deadline"</span><span class="crayon-sy">,</span> <span class="crayon-e">ATTR</span><span class="crayon-sy">{</span><span class="crayon-v">bdi</span><span class="crayon-o">/</span><span class="crayon-v">read_ahead_kb</span><span class="crayon-sy">}</span><span class="crayon-o">=</span><span class="crayon-s">"16"</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>To check the IO&nbsp;scheduler was applied (<em>[square-brackets] = enabled scheduler</em>):</p>
<div id="crayon-585a44bc911c6986677327" class="crayon-syntax crayon-theme-familiar crayon-font-monaco crayon-os-pc print-yes notranslate" data-settings=" minimize scroll-mouseover">
<div class="crayon-toolbar" data-settings=" show">
<div class="crayon-tools">
<div class="crayon-button crayon-nums-button crayon-pressed" title="Toggle Line Numbers"></div>
<div class="crayon-button crayon-plain-button" title="Toggle Plain Code"></div>
<div class="crayon-button crayon-wrap-button" title="Toggle Line Wrap"></div>
<div class="crayon-button crayon-copy-button" title="Copy"></div>
<div class="crayon-button crayon-popup-button" title="Open Code In New Window"></div>
<p><span class="crayon-language">Shell</span></div>
</div>
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-585a44bc911c6986677327-1">1</div>
<div class="crayon-num crayon-striped-num" data-line="crayon-585a44bc911c6986677327-2">2</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-585a44bc911c6986677327-1" class="crayon-line"><span class="crayon-sy">$</span> <span class="crayon-r">cat</span> <span class="crayon-o">/</span><span class="crayon-v">sys</span><span class="crayon-o">/</span><span class="crayon-v">block</span><span class="crayon-o">/</span><span class="crayon-v">sda</span><span class="crayon-o">/</span><span class="crayon-v">queue</span><span class="crayon-o">/</span><span class="crayon-e">scheduler </span></div>
<div id="crayon-585a44bc911c6986677327-2" class="crayon-line crayon-striped-line"><span class="crayon-i">noop</span> <span class="crayon-sy">[</span><span class="crayon-v">deadline</span><span class="crayon-sy">]</span> <span class="crayon-v">cfq</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>To check the current read-ahead setting:</p>
<div id="crayon-585a44bc911cd772670057" class="crayon-syntax crayon-theme-familiar crayon-font-monaco crayon-os-pc print-yes notranslate" data-settings=" minimize scroll-mouseover">
<div class="crayon-toolbar" data-settings=" show">
<div class="crayon-tools">
<div class="crayon-button crayon-nums-button crayon-pressed" title="Toggle Line Numbers"></div>
<div class="crayon-button crayon-plain-button" title="Toggle Plain Code"></div>
<div class="crayon-button crayon-wrap-button" title="Toggle Line Wrap"></div>
<div class="crayon-button crayon-copy-button" title="Copy"></div>
<div class="crayon-button crayon-popup-button" title="Open Code In New Window"></div>
<p><span class="crayon-language">Shell</span></div>
</div>
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-585a44bc911cd772670057-1">1</div>
<div class="crayon-num crayon-striped-num" data-line="crayon-585a44bc911cd772670057-2">2</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-585a44bc911cd772670057-1" class="crayon-line"><span class="crayon-sy">$</span> <span class="crayon-e">sudo </span><span class="crayon-v">blockdev</span> <span class="crayon-o">--</span><span class="crayon-v">getra</span> <span class="crayon-o">/</span><span class="crayon-v">dev</span><span class="crayon-o">/</span><span class="crayon-i">sda</span></div>
<div id="crayon-585a44bc911cd772670057-2" class="crayon-line crayon-striped-line"><span class="crayon-cn">32</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p><em>Note: this change should be applied and tested with a full system reboot!</em></p>
<h5><strong>Filesystem and Options</strong></h5>
<p>It is recommended that MongoDB uses only the <a href="https://en.wikipedia.org/wiki/Ext4" target="_blank" rel="nofollow">ext4</a> or <a href="https://en.wikipedia.org/wiki/XFS" target="_blank" rel="nofollow">XFS</a> filesystems for on-disk database data.&nbsp;<a href="https://en.wikipedia.org/wiki/Ext3" target="_blank" rel="nofollow">ext3</a> should be avoided due to its poor pre-allocation performance. If you&rsquo;re using WiredTiger (<em>MongoDB 3.0+</em>) as a storage engine, it is strongly advised that you ONLY&nbsp;use XFS due to serious stability issues on&nbsp;ext4.</p>
<p>Each time you read a file, the filesystems perform an access-time metadata update by default. However, MongoDB (<em>and most applications</em>) does not use&nbsp;this access-time information. This means you can disable access-time updates on MongoDB&rsquo;s data volume. A small amount of&nbsp;disk IO activity that the access-time updates cause stops in this case.</p>
<p>You can disable access-time updates by adding the flag <em>&ldquo;</em><em>noatime&rdquo;</em>&nbsp;to the filesystem options field&nbsp;in the file <em>&ldquo;</em><em>/etc/fstab&rdquo;&nbsp;</em>(<em>4th field</em>) for the disk serving MongoDB data:</p>
<div id="crayon-585a44bc911d6025176235" class="crayon-syntax crayon-theme-familiar crayon-font-monaco crayon-os-pc print-yes notranslate" data-settings=" minimize scroll-mouseover">
<div class="crayon-toolbar" data-settings=" show">
<div class="crayon-tools">
<div class="crayon-button crayon-nums-button crayon-pressed" title="Toggle Line Numbers"></div>
<div class="crayon-button crayon-plain-button" title="Toggle Plain Code"></div>
<div class="crayon-button crayon-wrap-button" title="Toggle Line Wrap"></div>
<div class="crayon-button crayon-copy-button" title="Copy"></div>
<div class="crayon-button crayon-popup-button" title="Open Code In New Window"></div>
<p><span class="crayon-language">Shell</span></div>
</div>
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-585a44bc911d6025176235-1">1</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-585a44bc911d6025176235-1" class="crayon-line"><span class="crayon-o">/</span><span class="crayon-v">dev</span><span class="crayon-o">/</span><span class="crayon-v">mapper</span><span class="crayon-o">/</span><span class="crayon-v">data</span><span class="crayon-o">-</span><span class="crayon-v">mongodb</span> <span class="crayon-o">/</span><span class="crayon-t">var</span><span class="crayon-o">/</span><span class="crayon-v">lib</span><span class="crayon-o">/</span><span class="crayon-e">mongo&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="crayon-e">ext4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="crayon-v">defaults</span><span class="crayon-sy">,</span><span class="crayon-i">noatime</span><span class="crayon-h">&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="crayon-cn">0</span> <span class="crayon-cn">0</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>Use <em>&ldquo;grep</em><em>&rdquo; </em>to verify the volume is currently mounted:</p>
<div id="crayon-585a44bc911dd251656326" class="crayon-syntax crayon-theme-familiar crayon-font-monaco crayon-os-pc print-yes notranslate" data-settings=" minimize scroll-mouseover">
<div class="crayon-toolbar" data-settings=" show">
<div class="crayon-tools">
<div class="crayon-button crayon-nums-button crayon-pressed" title="Toggle Line Numbers"></div>
<div class="crayon-button crayon-plain-button" title="Toggle Plain Code"></div>
<div class="crayon-button crayon-wrap-button" title="Toggle Line Wrap"></div>
<div class="crayon-button crayon-copy-button" title="Copy"></div>
<div class="crayon-button crayon-popup-button" title="Open Code In New Window"></div>
<p><span class="crayon-language">Shell</span></div>
</div>
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-585a44bc911dd251656326-1">1</div>
<div class="crayon-num crayon-striped-num" data-line="crayon-585a44bc911dd251656326-2">2</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-585a44bc911dd251656326-1" class="crayon-line"><span class="crayon-sy">$</span> <span class="crayon-r">grep</span> <span class="crayon-s">"/var/lib/mongo"</span> <span class="crayon-o">/</span><span class="crayon-v">proc</span><span class="crayon-o">/</span><span class="crayon-v">mounts</span></div>
<div id="crayon-585a44bc911dd251656326-2" class="crayon-line crayon-striped-line"><span class="crayon-o">/</span><span class="crayon-v">dev</span><span class="crayon-o">/</span><span class="crayon-v">mapper</span><span class="crayon-o">/</span><span class="crayon-v">data</span><span class="crayon-o">-</span><span class="crayon-v">mongodb</span> <span class="crayon-o">/</span><span class="crayon-t">var</span><span class="crayon-o">/</span><span class="crayon-v">lib</span><span class="crayon-o">/</span><span class="crayon-e">mongo </span><span class="crayon-e">ext4 </span><span class="crayon-v">rw</span><span class="crayon-sy">,</span><span class="crayon-v">seclabel</span><span class="crayon-sy">,</span><span class="crayon-v">noatime</span><span class="crayon-sy">,</span><span class="crayon-v">data</span><span class="crayon-o">=</span><span class="crayon-i">ordered</span> <span class="crayon-cn">0</span> <span class="crayon-cn">0</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p><em>Note: to apply a filesystem-options change, you must remount (umount + mount) the volume&nbsp;again after stopping MongoDB, or reboot.</em></p>
<h5><strong>Network Stack</strong></h5>
<p>Several defaults of the Linux kernel network tunings are either not optimal for MongoDB, limit a typical host with 1000mbps network interfaces (<em>or better</em>) or cause unpredictable&nbsp;behavior with routers and load balancers.&nbsp;We suggest some increases to the relatively low throughput settings (<em>net.core.somaxconn and net.ipv4.tcp_max_syn_backlog</em>) and a decrease in keepalive settings, seen below.</p>
<p>Make these changes permanent by adding the following to <em>&ldquo;</em><em>/etc/sysctl.conf&rdquo;&nbsp;</em>(<em>or a new file /etc/sysctl.d/mongodb-sysctl.conf &ndash; if /etc/sysctl.d exists</em>):</p>
<div id="crayon-585a44bc911e6620866988" class="crayon-syntax crayon-theme-familiar crayon-font-monaco crayon-os-pc print-yes notranslate" data-settings=" minimize scroll-mouseover">
<div class="crayon-toolbar" data-settings=" show"><span class="crayon-title">/etc/sysctl.conf</span></p>
<div class="crayon-tools">
<div class="crayon-button crayon-nums-button crayon-pressed" title="Toggle Line Numbers"></div>
<div class="crayon-button crayon-plain-button crayon-pressed" title="Toggle Plain Code"></div>
<div class="crayon-button crayon-wrap-button" title="Toggle Line Wrap"></div>
<div class="crayon-button crayon-copy-button" title="Copy"></div>
<div class="crayon-button crayon-popup-button" title="Open Code In New Window"></div>
<p><span class="crayon-language">Shell</span></div>
</div>
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-585a44bc911e6620866988-1">1</div>
<div class="crayon-num crayon-striped-num" data-line="crayon-585a44bc911e6620866988-2">2</div>
<div class="crayon-num" data-line="crayon-585a44bc911e6620866988-3">3</div>
<div class="crayon-num crayon-striped-num" data-line="crayon-585a44bc911e6620866988-4">4</div>
<div class="crayon-num" data-line="crayon-585a44bc911e6620866988-5">5</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-585a44bc911e6620866988-1" class="crayon-line"><span class="crayon-v">net</span><span class="crayon-e">.core</span><span class="crayon-e">.somaxconn</span> <span class="crayon-o">=</span> <span class="crayon-cn">4096</span></div>
<div id="crayon-585a44bc911e6620866988-2" class="crayon-line crayon-striped-line"><span class="crayon-v">net</span><span class="crayon-e">.ipv4</span><span class="crayon-e">.tcp_fin_timeout</span> <span class="crayon-o">=</span> <span class="crayon-cn">30</span></div>
<div id="crayon-585a44bc911e6620866988-3" class="crayon-line"><span class="crayon-v">net</span><span class="crayon-e">.ipv4</span><span class="crayon-e">.tcp_keepalive_intvl</span> <span class="crayon-o">=</span> <span class="crayon-cn">30</span></div>
<div id="crayon-585a44bc911e6620866988-4" class="crayon-line crayon-striped-line"><span class="crayon-v">net</span><span class="crayon-e">.ipv4</span><span class="crayon-e">.tcp_keepalive_time</span> <span class="crayon-o">=</span> <span class="crayon-cn">120</span></div>
<div id="crayon-585a44bc911e6620866988-5" class="crayon-line"><span class="crayon-v">net</span><span class="crayon-e">.ipv4</span><span class="crayon-e">.tcp_max_syn_backlog</span> <span class="crayon-o">=</span> <span class="crayon-cn">4096</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>To check the current values of any of these settings:</p>
<div id="crayon-585a44bc911ed832781806" class="crayon-syntax crayon-theme-familiar crayon-font-monaco crayon-os-pc print-yes notranslate" data-settings=" minimize scroll-mouseover">
<div class="crayon-toolbar" data-settings=" show">
<div class="crayon-tools">
<div class="crayon-button crayon-nums-button crayon-pressed" title="Toggle Line Numbers"></div>
<div class="crayon-button crayon-plain-button crayon-pressed" title="Toggle Plain Code"></div>
<div class="crayon-button crayon-wrap-button" title="Toggle Line Wrap"></div>
<div class="crayon-button crayon-copy-button" title="Copy"></div>
<div class="crayon-button crayon-popup-button" title="Open Code In New Window"></div>
<p><span class="crayon-language">Shell</span></div>
</div>
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-585a44bc911ed832781806-1">1</div>
<div class="crayon-num crayon-striped-num" data-line="crayon-585a44bc911ed832781806-2">2</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-585a44bc911ed832781806-1" class="crayon-line"><span class="crayon-sy">$</span> <span class="crayon-e">sysctl </span><span class="crayon-v">net</span><span class="crayon-e">.core</span><span class="crayon-e">.somaxconn</span></div>
<div id="crayon-585a44bc911ed832781806-2" class="crayon-line crayon-striped-line"><span class="crayon-v">net</span><span class="crayon-e">.core</span><span class="crayon-e">.somaxconn</span> <span class="crayon-o">=</span> <span class="crayon-cn">4096</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p><em>Note: you must run the&nbsp;command &ldquo;/sbin/sysctl -p&rdquo; as root/sudo (or reboot) to&nbsp;apply this change!</em></p>
<h5><strong>NTP Daemon</strong></h5>
<p>All of these deeper tunings make it easy to forget about something as simple as your clock source.&nbsp;As MongoDB is a cluster, it relies on a&nbsp;consistent time across nodes. Thus the <a href="https://en.wikipedia.org/wiki/Ntpd" target="_blank" rel="nofollow">NTP Daemon</a> should run permanently on all MongoDB hosts, mongos and arbiters included. Be sure to check the time syncing&nbsp;won&rsquo;t fight&nbsp;with any guest-based virtualization tools like &ldquo;VMWare tools&rdquo; and &ldquo;VirtualBox Guest Additions&rdquo;.</p>
<p>This is installed on RedHat/CentOS with:</p>
<div id="crayon-585a44bc911f5823360999" class="crayon-syntax crayon-theme-familiar crayon-font-monaco crayon-os-pc print-yes notranslate" data-settings=" minimize scroll-mouseover">
<div class="crayon-toolbar" data-settings=" show">
<div class="crayon-tools">
<div class="crayon-button crayon-nums-button crayon-pressed" title="Toggle Line Numbers"></div>
<div class="crayon-button crayon-plain-button" title="Toggle Plain Code"></div>
<div class="crayon-button crayon-wrap-button" title="Toggle Line Wrap"></div>
<div class="crayon-button crayon-copy-button" title="Copy"></div>
<div class="crayon-button crayon-popup-button" title="Open Code In New Window"></div>
<p><span class="crayon-language">Shell</span></div>
</div>
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-585a44bc911f5823360999-1">1</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-585a44bc911f5823360999-1" class="crayon-line"><span class="crayon-sy">$</span> <span class="crayon-e">sudo </span><span class="crayon-e">yum </span><span class="crayon-e">install </span><span class="crayon-v">ntp</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>And on Debian/Ubuntu:</p>
<div id="crayon-585a44bc911fc898301489" class="crayon-syntax crayon-theme-familiar crayon-font-monaco crayon-os-pc print-yes notranslate" data-settings=" minimize scroll-mouseover">
<div class="crayon-toolbar" data-settings=" show">
<div class="crayon-tools">
<div class="crayon-button crayon-nums-button crayon-pressed" title="Toggle Line Numbers"></div>
<div class="crayon-button crayon-plain-button" title="Toggle Plain Code"></div>
<div class="crayon-button crayon-wrap-button" title="Toggle Line Wrap"></div>
<div class="crayon-button crayon-copy-button" title="Copy"></div>
<div class="crayon-button crayon-popup-button" title="Open Code In New Window"></div>
<p><span class="crayon-language">Shell</span></div>
</div>
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-585a44bc911fc898301489-1">1</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-585a44bc911fc898301489-1" class="crayon-line"><span class="crayon-sy">$</span> <span class="crayon-e">sudo </span><span class="crayon-v">apt</span><span class="crayon-o">-</span><span class="crayon-r">get</span> <span class="crayon-e">install </span><span class="crayon-v">ntp</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p><em>Note: Start and enable the NTP Daemon (for starting on reboots) after installation. The commands to do this vary by OS and OS version, so please consult your documentation.</em></p>
<h5><strong>Security-Enhanced Linux (SELinux)</strong></h5>
<p><a href="https://en.wikipedia.org/wiki/Security-Enhanced_Linux" target="_blank" rel="nofollow">Security-Enhanced Linux</a> is a kernel-level security access control module that has an unfortunate tendency to be disabled or set to warn-only on Linux deployments. As SELinux is a strict access control system, sometimes it can cause unexpected errors (<em>permission denied, etc.)</em> with applications that were not configured properly for SELinux. Often people disable SELinux to resolve the issue and forget about it entirely. While implementing SELinux is not an end-all solution, it massively&nbsp;reduces the local attack surface of the server. We recommend deploying MongoDB with SELinus&nbsp;<em>&ldquo;</em><em>Enforcing&rdquo;</em>&nbsp;mode on.</p>
<p>The modes of SELinux are:</p>
<ol>
<li>Enforcing &ndash; Block and log policy violations.</li>
<li>Permissive &ndash; Log policy violations only.</li>
<li>Disabled &ndash; Completely disabled.</li>
</ol>
<p>As database servers are usually dedicated to one purpose, such as running MongoDB, the work of setting up SELinux is a lot simpler than a multi-use&nbsp;server with many processes and users (such as an application/web server, etc.). The OS access pattern of a database server&nbsp;should be extremely predictable. Introducing <em>&ldquo;</em><em>Enforcing&rdquo;</em>&nbsp;mode at the very beginning of your testing/installation instead of after-the-fact avoids a lot of gotchas with SELinux. Logging for SELinux is directed to <em>&ldquo;</em><em><span class="s1">/var/log/audit/audit.log&rdquo;</span></em>&nbsp;and the configuration is at <em>&ldquo;</em><em>/etc/selinux&rdquo;</em>.</p>
<p>Luckily, <a href="https://www.percona.com/software/mongo-database/percona-server-for-mongodb" target="_blank">Percona Server for MongoDB</a>&nbsp;RPM&nbsp;packages (<em>CentOS/RedHat</em>) are SELinux &ldquo;<em>Enforcing</em>&rdquo; mode compatible&nbsp;as they install/enable&nbsp;an&nbsp;SELinux policy at&nbsp;RPM&nbsp;install time! Debian/Ubuntu SELinux support is&nbsp;still in planning.</p>
<p>Here you can see the SELinux policy shipped in the Percona Server for MongoDB version 3.2 server package:</p>
<div id="crayon-585a44bc91228977829014" class="crayon-syntax crayon-theme-familiar crayon-font-monaco crayon-os-pc print-yes notranslate" data-settings=" minimize scroll-mouseover">
<div class="crayon-toolbar" data-settings=" show">
<div class="crayon-tools">
<div class="crayon-button crayon-nums-button crayon-pressed" title="Toggle Line Numbers"></div>
<div class="crayon-button crayon-plain-button" title="Toggle Plain Code"></div>
<div class="crayon-button crayon-wrap-button" title="Toggle Line Wrap"></div>
<div class="crayon-button crayon-copy-button" title="Copy"></div>
<div class="crayon-button crayon-popup-button" title="Open Code In New Window"></div>
<p><span class="crayon-language">Shell</span></div>
</div>
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-585a44bc91228977829014-1">1</div>
<div class="crayon-num crayon-striped-num" data-line="crayon-585a44bc91228977829014-2">2</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-585a44bc91228977829014-1" class="crayon-line"><span class="crayon-sy">$</span> <span class="crayon-v">rpm</span> <span class="crayon-o">-</span><span class="crayon-e">ql </span><span class="crayon-v">Percona</span><span class="crayon-o">-</span><span class="crayon-v">Server</span><span class="crayon-o">-</span><span class="crayon-v">MongoDB</span><span class="crayon-o">-</span><span class="crayon-cn">32</span><span class="crayon-o">-</span><span class="crayon-v">server</span> <span class="crayon-o">|</span> <span class="crayon-r">grep</span> <span class="crayon-v">selinux</span></div>
<div id="crayon-585a44bc91228977829014-2" class="crayon-line crayon-striped-line"><span class="crayon-o">/</span><span class="crayon-v">etc</span><span class="crayon-o">/</span><span class="crayon-v">selinux</span><span class="crayon-o">/</span><span class="crayon-v">targeted</span><span class="crayon-o">/</span><span class="crayon-v">modules</span><span class="crayon-o">/</span><span class="crayon-v">active</span><span class="crayon-o">/</span><span class="crayon-v">modules</span><span class="crayon-o">/</span><span class="crayon-v">mongod</span><span class="crayon-e">.pp</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>To change the SELinux mode to <em>&ldquo;</em><em>Enforcing&rdquo;</em>:</p>
<div id="crayon-585a44bc91232119592262" class="crayon-syntax crayon-theme-familiar crayon-font-monaco crayon-os-pc print-yes notranslate" data-settings=" minimize scroll-mouseover">
<div class="crayon-toolbar" data-settings=" show">
<div class="crayon-tools">
<div class="crayon-button crayon-nums-button crayon-pressed" title="Toggle Line Numbers"></div>
<div class="crayon-button crayon-plain-button" title="Toggle Plain Code"></div>
<div class="crayon-button crayon-wrap-button" title="Toggle Line Wrap"></div>
<div class="crayon-button crayon-copy-button" title="Copy"></div>
<div class="crayon-button crayon-popup-button" title="Open Code In New Window"></div>
<p><span class="crayon-language">Shell</span></div>
</div>
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-585a44bc91232119592262-1">1</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-585a44bc91232119592262-1" class="crayon-line"><span class="crayon-sy">$</span> <span class="crayon-e">sudo </span><span class="crayon-e">setenforce </span><span class="crayon-v">Enforcing</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>To check the running&nbsp;SELinux mode:</p>
<div id="crayon-585a44bc91239527192649" class="crayon-syntax crayon-theme-familiar crayon-font-monaco crayon-os-pc print-yes notranslate" data-settings=" minimize scroll-mouseover">
<div class="crayon-toolbar" data-settings=" show">
<div class="crayon-tools">
<div class="crayon-button crayon-nums-button crayon-pressed" title="Toggle Line Numbers"></div>
<div class="crayon-button crayon-plain-button" title="Toggle Plain Code"></div>
<div class="crayon-button crayon-wrap-button" title="Toggle Line Wrap"></div>
<div class="crayon-button crayon-copy-button" title="Copy"></div>
<div class="crayon-button crayon-popup-button" title="Open Code In New Window"></div>
<p><span class="crayon-language">Shell</span></div>
</div>
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-585a44bc91239527192649-1">1</div>
<div class="crayon-num crayon-striped-num" data-line="crayon-585a44bc91239527192649-2">2</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-585a44bc91239527192649-1" class="crayon-line"><span class="crayon-sy">$</span> <span class="crayon-e">sudo </span><span class="crayon-e">getenforce</span></div>
<div id="crayon-585a44bc91239527192649-2" class="crayon-line crayon-striped-line"><span class="crayon-v">Enforcing</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<h5><strong>Linux Kernel and Glibc Version</strong></h5>
<p>The version of the Linux kernel and Glibc itself may be more important than you think. Some community&nbsp;benchmarks show a significant improvement on OLTP throughput benchmarks&nbsp;with the recent Linux 3.x kernels versus the 2.6 still widely deployed. To avoid serious bugs, MongoDB&nbsp;should at minimum use Linux 2.6.36 and Glibc 2.13 or newer.</p>
<p>I hope to create a follow-up post on the specific differences seen under MongoDB workloads on Linux 3.2+ versus 2.6. Until then, I recommend you test the difference&nbsp;using your own workloads and any results/feedback are&nbsp;appreciated.</p>
<h5><strong>What&rsquo;s Next?</strong></h5>
<p>What&rsquo;s the next thing to tune? At this point, tuning becomes case-by-case and open-ended. I appreciate any comments on use-case/tunings pairings that worked for you. Also, look out for follow-ups to this article for a few tunings I excluded due to lack of&nbsp;testing.</p>
<p>Not knowing the next step might mean you&rsquo;re done tuning, or that you need more visibility into your stack to find the next bottleneck.&nbsp;Good monitoring and data visibility are invaluable for this type of investigation. Look out for future posts regarding monitoring your MongoDB (<em>or MySQL</em>) deployment and consider using <a href="https://www.percona.com/blog/2016/07/28/percona-monitoring-and-management-1-0-2-beta/" target="_blank">Percona Monitoring and Management</a>&nbsp;as an all-in-one monitoring solution. You could also try using&nbsp;<a href="https://github.com/Percona-Lab/prometheus_mongodb_exporter" target="_blank" rel="nofollow">Percona-Lab/prometheus_mongodb_exporter</a>,&nbsp;<a href="https://github.com/prometheus/node_exporter" target="_blank" rel="nofollow">prometheus/node_exporter</a>&nbsp;and&nbsp;<a href="https://github.com/Percona-Lab/grafana_mongodb_dashboards" target="_blank" rel="nofollow">Percona-Lab/grafana_mongodb_dashboards</a> for monitoring MongoDB/Linux with <a href="https://prometheus.io/" target="_blank" rel="nofollow">Prometheus</a>&nbsp;and&nbsp;<a href="http://grafana.org/" target="_blank" rel="nofollow">Grafana.</a></p>
<p>The road to an efficient database stack requires patience, analysis and iteration. Tomorrow a new hardware architecture or change in kernel behavior could come, be the first to spot the next bottleneck! Happy hunting.</p>
<p>原文：https://www.percona.com/blog/2016/08/12/tuning-linux-for-mongodb/</p>
</div>
