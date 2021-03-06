---
layout: post
status: publish
published: true
title: Gradle to maven conversion and vice versa


date: '2017-07-06 21:00:31 +0800'
date_gmt: '2017-07-06 13:00:31 +0800'
categories:
- Opensource
tags:
- maven
- gradle
comments: []
---
<p><span class="author vcard"><a class="url fn n" href="https://codexplo.wordpress.com/author/codexplo/">A N M Bazlur Bazlur Rahman</a></span><span class="entry-tags-date"><a href="https://codexplo.wordpress.com/2014/07/20/gradle-to-maven-conversion-and-vice-versa/" rel="bookmark"><time class="entry-date published" datetime="2014-07-20T01:45:47+00:00">July 20, 2014</time></a></span><span class="entry-categories"><a href="https://codexplo.wordpress.com/category/java/" rel="tag">Java</a>,&nbsp;<a href="https://codexplo.wordpress.com/category/tips/" rel="tag">Tips</a></span></p>
<p><strong>How to convert maven to gradle</strong></p>
<p>The first thing is, you have to install gradle. Its easy. I know you can do it.&nbsp; Go to the installing guide:&nbsp;<a href="http://www.gradle.org/docs/current/userguide/installation.html" rel="nofollow">http://www.gradle.org/docs/current/userguide/installation.html</a></p>
<p>Now the second step is to run &lsquo;<em><strong>gradle init</strong></em>&lsquo; in the directory containing the POM file. This will&nbsp; convert the maven build to a gradle build generating a setting.gradle file and one or&nbsp; ore more build.gradle files.</p>
<p>Thats all.</p>
<p><strong>How to convert gradle to maven</strong></p>
<p>You just need to add&nbsp; a maven plugin in your build.gradle.</p>
<p>Your build gradle should be like this-</p>
<div>
<div id="highlighter_659425" class="syntaxhighlighter  plain   ">
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
</td>
<td class="code">
<div class="container">
<div class="line number1 index0 alt2"><code class="plain plain">apply plugin: 'java'</code></div>
<div class="line number2 index1 alt1"><code class="plain plain">apply plugin: 'maven'</code></div>
<div class="line number3 index2 alt2"></div>
<div class="line number4 index3 alt1"><code class="plain plain">group = 'com.bazlur.app'</code></div>
<div class="line number5 index4 alt2"><code class="plain plain">// artifactId is taken by default, from folder name</code></div>
<div class="line number6 index5 alt1"><code class="plain plain">version = '0.1-SNAPSHOT'</code></div>
<div class="line number7 index6 alt2"></div>
<div class="line number8 index7 alt1"><code class="plain plain">dependencies {</code></div>
<div class="line number9 index8 alt2"><code class="plain plain">compile 'commons-lang:commons-lang:2.3'</code></div>
<div class="line number10 index9 alt1"><code class="plain plain">}</code></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>Now run &lsquo;<em><strong>gradle install</strong></em>&lsquo; in the build.gradle folder.</p>
<p>Now you will find in the&nbsp;<strong><em>build/poms</em></strong>&nbsp;subfolder, a file called pom-default.xml which will contain the dependencies.</p>
<p>Now its all yours, copy it, customise it add up new stuff.</p>
<div class="wpcnt"></div>
<div class="wpcnt">Source:&nbsp;https://codexplo.wordpress.com/2014/07/20/gradle-to-maven-conversion-and-vice-versa/</div>
