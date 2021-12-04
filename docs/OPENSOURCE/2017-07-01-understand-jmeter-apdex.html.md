---
layout: post
status: publish
published: true
title: Understand JMeter APDEX


date: '2017-07-01 10:16:38 +0800'
date_gmt: '2017-07-01 02:16:38 +0800'
categories:
- Opensource
tags:
- jmeter
- APDEX
- performance
- test
- threshold
comments: []
---
<h1 id="1-concept" data-source-line="1">1. Concept</h1>
<p data-source-line="2">APDEX is explained here</p>
<p data-source-line="4">To compute it JMeter needs 2 values:</p>
<ul data-source-line="5">
<li>Satisfied count</li>
<li>Tolerating count</li>
</ul>
<p data-source-line="8">Satisfied count is the Number of requests for which response time is lower than "Toleration threshold"</p>
<p data-source-line="10">Tolerating count is the Number of requests for which response time is higher than Toleration threshold but lower than "Frustration threshold"</p>
<p data-source-line="12">So JMeter let's you customize those 2 values as it depends on your SLR/SLA.</p>
<blockquote data-source-line="14"><p>APDEX = (SatisfiedCount + ToleratingCount / 2) / TotalSamples</p></blockquote>
<h1 id="2-how-to-set-apdex-thresholds" data-source-line="16">2. How to set APDEX thresholds</h1>
<h2 id="binuserproperties" data-source-line="17">bin/user.properties</h2>
<pre data-source-line="19"><code class="hljs">$ <span class="hljs-built_in">pwd</span>
/Users/<span class="hljs-built_in">echo</span>/apps/jmeter-<span class="hljs-number">3.2</span>
$ cat bin/user.properties | grep threshold
<span class="hljs-comment"># Change this parameter if you want to override the APDEX satisfaction threshold.</span>
<span class="hljs-comment">#jmeter.reportgenerator.apdex_satisfied_threshold=500</span>
<span class="hljs-comment"># Change this parameter if you want to override the APDEX tolerance threshold.</span>
<span class="hljs-comment">#jmeter.reportgenerator.apdex_tolerated_threshold=1500</span></code></pre>
<h2 id="command-line" data-source-line="29">command line</h2>
<p data-source-line="30">For exampe:</p>
<pre data-source-line="31"><code class="hljs">CASE=testcast1 &amp;&amp; ./bin/jmeter -n -t <span class="hljs-string">"testcase/<span class="hljs-variable">$CASE</span>.jmx"</span> <span class="hljs-operator">-l</span> <span class="hljs-string">"output/<span class="hljs-variable">$CASE</span>.log"</span>  -o <span class="hljs-string">"output/<span class="hljs-variable">$CASE</span>"</span> <span class="hljs-operator">-e</span> -Jjmeter.reportgenerator.apdex_satisfied_threshold=<span class="hljs-number">400</span> -Jjmeter.reportgenerator.apdex_tolerated_threshold=<span class="hljs-number">1200</span></code></pre>
<h1 id="references" data-source-line="35">References</h1>
<ul data-source-line="36">
<li><a href="http://jmeter.apache.org/usermanual/generating-dashboard.html">http://jmeter.apache.org/usermanual/generating-dashboard.html</a></li>
<li><a href="https://en.wikipedia.org/wiki/Apdex">https://en.wikipedia.org/wiki/Apdex</a></li>
<li><a href="https://stackoverflow.com/questions/39696457/can-anyone-help-me-to-understand-the-terms-toleration-threshold-and-frustrati">https://stackoverflow.com/questions/39696457/can-anyone-help-me-to-understand-the-terms-toleration-threshold-and-frustrati</a></li>
</ul>