---
layout: post
status: publish
published: true
title: grep命令的or，and，not操作示例


date: '2015-12-17 09:20:03 +0800'
date_gmt: '2015-12-17 01:20:03 +0800'
categories:
- Util
tags:
- grep
comments: []
---
<p>在Linux的grep命令中如何使用OR，AND，NOT操作符呢？</p>
<p>其实，在grep命令中，有OR和NOT操作符的等价选项，但是并没有grep AND这种操作符。不过呢，可以使用patterns来模拟AND操作的。下面会举一些例子来说明在Linux的grep命令中如何使用OR，AND，NOT。</p>
<p>在下面的例子中，会用到这个employee.txt文件，如下：</p>
<div class="dp-highlighter bg_plain">
<div class="bar">
<div class="tools"><b>[plain]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/jackaduma/article/details/6900242#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/jackaduma/article/details/6900242#">copy</a></p>
<div><embed id="ZeroClipboardMovie_1" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_1"></embed></div>
</div>
</div>
<ol start="1">
<li class="alt">$&nbsp;cat&nbsp;employee.txt</li>
<li class="">100&nbsp;&nbsp;Thomas&nbsp;&nbsp;Manager&nbsp;&nbsp;&nbsp;&nbsp;Sales&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$5,000</li>
<li class="alt">200&nbsp;&nbsp;Jason&nbsp;&nbsp;&nbsp;Developer&nbsp;&nbsp;Technology&nbsp;&nbsp;$5,500</li>
<li class="">300&nbsp;&nbsp;Raj&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sysadmin&nbsp;&nbsp;&nbsp;Technology&nbsp;&nbsp;$7,000</li>
<li class="alt">400&nbsp;&nbsp;Nisha&nbsp;&nbsp;&nbsp;Manager&nbsp;&nbsp;&nbsp;&nbsp;Marketing&nbsp;&nbsp;&nbsp;$9,500</li>
<li class="">500&nbsp;&nbsp;Randy&nbsp;&nbsp;&nbsp;Manager&nbsp;&nbsp;&nbsp;&nbsp;Sales&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$6,000</li>
</ol>
</div>
<p>（一）Grep OR 操作符</p>
<p>以下四种方法均能实现grep OR的操作。个人推荐方法3.</p>
<p>1.使用 \|</p>
<p>如果不使用grep命令的任何选项，可以通过使用 '\|' 来分割多个pattern，以此实现OR的操作。</p>
<div class="dp-highlighter bg_plain">
<div class="bar">
<div class="tools"><b>[plain]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/jackaduma/article/details/6900242#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/jackaduma/article/details/6900242#">copy</a></p>
<div><embed id="ZeroClipboardMovie_2" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_2"></embed></div>
</div>
</div>
<ol start="1">
<li class="alt">grep&nbsp;'pattern1\|pattern2'&nbsp;filename</li>
</ol>
</div>
<p>例子如下：</p>
<div class="dp-highlighter bg_plain">
<div class="bar">
<div class="tools"><b>[plain]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/jackaduma/article/details/6900242#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/jackaduma/article/details/6900242#">copy</a></p>
<div><embed id="ZeroClipboardMovie_3" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_3"></embed></div>
</div>
</div>
<ol start="1">
<li class="alt">$&nbsp;grep&nbsp;'Tech\|Sales'&nbsp;employee.txt</li>
<li class="">100&nbsp;&nbsp;Thomas&nbsp;&nbsp;Manager&nbsp;&nbsp;&nbsp;&nbsp;Sales&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$5,000</li>
<li class="alt">200&nbsp;&nbsp;Jason&nbsp;&nbsp;&nbsp;Developer&nbsp;&nbsp;Technology&nbsp;&nbsp;$5,500</li>
<li class="">300&nbsp;&nbsp;Raj&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sysadmin&nbsp;&nbsp;&nbsp;Technology&nbsp;&nbsp;$7,000</li>
<li class="alt">500&nbsp;&nbsp;Randy&nbsp;&nbsp;&nbsp;Manager&nbsp;&nbsp;&nbsp;&nbsp;Sales&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$6,000</li>
</ol>
</div>
<p>2.使用选项 -E</p>
<p>grep -E 选项可以用来扩展选项为正则表达式。 如果使用了grep 命令的选项-E，则应该使用 | 来分割多个pattern，以此实现OR操作。</p>
<div class="dp-highlighter bg_plain">
<div class="bar">
<div class="tools"><b>[plain]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/jackaduma/article/details/6900242#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/jackaduma/article/details/6900242#">copy</a></p>
<div><embed id="ZeroClipboardMovie_4" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_4"></embed></div>
</div>
</div>
<ol start="1">
<li class="alt"><span&nbsp;style="font-family:'Microsoft&nbsp;YaHei';font-size:16px;">grep&nbsp;-E&nbsp;'pattern1|pattern2'&nbsp;filename</span></li>
</ol>
</div>
<p>例子如下：</p>
<div class="dp-highlighter bg_plain">
<div class="bar">
<div class="tools"><b>[plain]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/jackaduma/article/details/6900242#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/jackaduma/article/details/6900242#">copy</a></p>
<div><embed id="ZeroClipboardMovie_5" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_5"></embed></div>
</div>
</div>
<ol start="1">
<li class="alt">$&nbsp;grep&nbsp;-E&nbsp;'Tech|Sales'&nbsp;employee.txt</li>
<li class="">100&nbsp;&nbsp;Thomas&nbsp;&nbsp;Manager&nbsp;&nbsp;&nbsp;&nbsp;Sales&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$5,000</li>
<li class="alt">200&nbsp;&nbsp;Jason&nbsp;&nbsp;&nbsp;Developer&nbsp;&nbsp;Technology&nbsp;&nbsp;$5,500</li>
<li class="">300&nbsp;&nbsp;Raj&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sysadmin&nbsp;&nbsp;&nbsp;Technology&nbsp;&nbsp;$7,000</li>
<li class="alt">500&nbsp;&nbsp;Randy&nbsp;&nbsp;&nbsp;Manager&nbsp;&nbsp;&nbsp;&nbsp;Sales&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$6,000</li>
</ol>
</div>
<p>3. 使用 egrep</p>
<p>egrep 命令等同于&lsquo;grep -E&rsquo;。因此，使用egrep (不带任何选项)命令，以此根据分割的多个Pattern来实现OR操作.</p>
<div class="dp-highlighter bg_plain">
<div class="bar">
<div class="tools"><b>[plain]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/jackaduma/article/details/6900242#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/jackaduma/article/details/6900242#">copy</a></p>
<div><embed id="ZeroClipboardMovie_6" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_6"></embed></div>
</div>
</div>
<ol start="1">
<li class="alt">egrep&nbsp;'pattern1|pattern2'&nbsp;filename</li>
</ol>
</div>
<p>例子如下：</p>
<div class="dp-highlighter bg_plain">
<div class="bar">
<div class="tools"><b>[plain]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/jackaduma/article/details/6900242#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/jackaduma/article/details/6900242#">copy</a></p>
<div><embed id="ZeroClipboardMovie_7" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_7"></embed></div>
</div>
</div>
<ol start="1">
<li class="alt">$&nbsp;egrep&nbsp;'Tech|Sales'&nbsp;employee.txt</li>
<li class="">100&nbsp;&nbsp;Thomas&nbsp;&nbsp;Manager&nbsp;&nbsp;&nbsp;&nbsp;Sales&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$5,000</li>
<li class="alt">200&nbsp;&nbsp;Jason&nbsp;&nbsp;&nbsp;Developer&nbsp;&nbsp;Technology&nbsp;&nbsp;$5,500</li>
<li class="">300&nbsp;&nbsp;Raj&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sysadmin&nbsp;&nbsp;&nbsp;Technology&nbsp;&nbsp;$7,000</li>
<li class="alt">500&nbsp;&nbsp;Randy&nbsp;&nbsp;&nbsp;Manager&nbsp;&nbsp;&nbsp;&nbsp;Sales&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$6,000</li>
</ol>
</div>
<p>4. 使用选项 -e</p>
<p>使用grep -e 选项，只能传递一个参数。在单条命令中使用多个 -e 选项，得到多个pattern，以此实现OR操作。</p>
<div class="dp-highlighter bg_plain">
<div class="bar">
<div class="tools"><b>[plain]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/jackaduma/article/details/6900242#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/jackaduma/article/details/6900242#">copy</a></p>
<div><embed id="ZeroClipboardMovie_8" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_8"></embed></div>
</div>
</div>
<ol start="1">
<li class="alt">grep&nbsp;-e&nbsp;pattern1&nbsp;-e&nbsp;pattern2&nbsp;filename</li>
</ol>
</div>
<p>例子如下：</p>
<div class="dp-highlighter bg_plain">
<div class="bar">
<div class="tools"><b>[plain]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/jackaduma/article/details/6900242#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/jackaduma/article/details/6900242#">copy</a></p>
<div><embed id="ZeroClipboardMovie_9" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_9"></embed></div>
</div>
</div>
<ol start="1">
<li class="alt">$&nbsp;grep&nbsp;-e&nbsp;Tech&nbsp;-e&nbsp;Sales&nbsp;employee.txt</li>
<li class="">100&nbsp;&nbsp;Thomas&nbsp;&nbsp;Manager&nbsp;&nbsp;&nbsp;&nbsp;Sales&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$5,000</li>
<li class="alt">200&nbsp;&nbsp;Jason&nbsp;&nbsp;&nbsp;Developer&nbsp;&nbsp;Technology&nbsp;&nbsp;$5,500</li>
<li class="">300&nbsp;&nbsp;Raj&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sysadmin&nbsp;&nbsp;&nbsp;Technology&nbsp;&nbsp;$7,000</li>
<li class="alt">500&nbsp;&nbsp;Randy&nbsp;&nbsp;&nbsp;Manager&nbsp;&nbsp;&nbsp;&nbsp;Sales&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$6,000</li>
</ol>
</div>
<p>（二） Grep AND 操作</p>
<p>1. 使用 -E 'pattern1.*pattern2'</p>
<p>grep命令本身不提供AND功能。但是，使用 -E 选项可以实现AND操作。</p>
<div class="dp-highlighter bg_plain">
<div class="bar">
<div class="tools"><b>[plain]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/jackaduma/article/details/6900242#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/jackaduma/article/details/6900242#">copy</a></p>
<div><embed id="ZeroClipboardMovie_10" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_10"></embed></div>
</div>
</div>
<ol start="1">
<li class="alt">grep&nbsp;-E&nbsp;'pattern1.*pattern2'&nbsp;filename</li>
<li class="">grep&nbsp;-E&nbsp;'pattern1.*pattern2|pattern2.*pattern1'&nbsp;filename</li>
</ol>
</div>
<p>第一个例子如下：（其中两个pattern的顺序是指定的）</p>
<div class="dp-highlighter bg_plain">
<div class="bar">
<div class="tools"><b>[plain]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/jackaduma/article/details/6900242#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/jackaduma/article/details/6900242#">copy</a></p>
<div><embed id="ZeroClipboardMovie_11" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_11"></embed></div>
</div>
</div>
<ol start="1">
<li class="alt">$&nbsp;grep&nbsp;-E&nbsp;'Dev.*Tech'&nbsp;employee.txt</li>
<li class="">200&nbsp;&nbsp;Jason&nbsp;&nbsp;&nbsp;Developer&nbsp;&nbsp;Technology&nbsp;&nbsp;$5,500</li>
</ol>
</div>
<p>第二个例子：（两个pattern的顺序不是固定的，可以是乱序的）</p>
<div class="dp-highlighter bg_plain">
<div class="bar">
<div class="tools"><b>[plain]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/jackaduma/article/details/6900242#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/jackaduma/article/details/6900242#">copy</a></p>
<div><embed id="ZeroClipboardMovie_12" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_12"></embed></div>
</div>
</div>
<ol start="1">
<li class="alt">$&nbsp;grep&nbsp;-E&nbsp;'Manager.*Sales|Sales.*Manager'&nbsp;employee.txt</li>
</ol>
</div>
<p>2. 使用多个grep命令</p>
<p>可以使用多个 grep 命令 ，由管道符分割，以此来实现 AND 语义。</p>
<div class="dp-highlighter bg_plain">
<div class="bar">
<div class="tools"><b>[plain]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/jackaduma/article/details/6900242#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/jackaduma/article/details/6900242#">copy</a></p>
<div><embed id="ZeroClipboardMovie_13" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_13"></embed></div>
</div>
</div>
<ol start="1">
<li class="alt">grep&nbsp;-E&nbsp;'pattern1'&nbsp;filename&nbsp;|&nbsp;grep&nbsp;-E&nbsp;'pattern2'</li>
</ol>
</div>
<p>例子如下：</p>
<div class="dp-highlighter bg_plain">
<div class="bar">
<div class="tools"><b>[plain]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/jackaduma/article/details/6900242#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/jackaduma/article/details/6900242#">copy</a></p>
<div><embed id="ZeroClipboardMovie_14" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_14"></embed></div>
</div>
</div>
<ol start="1">
<li class="alt">$&nbsp;grep&nbsp;Manager&nbsp;employee.txt&nbsp;|&nbsp;grep&nbsp;Sales</li>
<li class="">100&nbsp;&nbsp;Thomas&nbsp;&nbsp;Manager&nbsp;&nbsp;&nbsp;&nbsp;Sales&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$5,000</li>
<li class="alt">500&nbsp;&nbsp;Randy&nbsp;&nbsp;&nbsp;Manager&nbsp;&nbsp;&nbsp;&nbsp;Sales&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$6,000</li>
</ol>
</div>
<p>（三） Grep NOT操作</p>
<p>1. 使用选项 grep -v</p>
<p>使用 grep -v 可以实现 NOT 操作。 -v 选项用来实现反选匹配的（ invert match）。如，可匹配得到除下指定pattern外的所有lines。</p>
<div class="dp-highlighter bg_plain">
<div class="bar">
<div class="tools"><b>[plain]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/jackaduma/article/details/6900242#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/jackaduma/article/details/6900242#">copy</a></p>
<div><embed id="ZeroClipboardMovie_15" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_15"></embed></div>
</div>
</div>
<ol start="1">
<li class="alt">grep&nbsp;-v&nbsp;'pattern1'&nbsp;filename</li>
</ol>
</div>
<p>例子如下：</p>
<div class="dp-highlighter bg_plain">
<div class="bar">
<div class="tools"><b>[plain]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/jackaduma/article/details/6900242#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/jackaduma/article/details/6900242#">copy</a></p>
<div><embed id="ZeroClipboardMovie_16" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_16"></embed></div>
</div>
</div>
<ol start="1">
<li class="alt">$&nbsp;grep&nbsp;-v&nbsp;Sales&nbsp;employee.txt</li>
<li class="">200&nbsp;&nbsp;Jason&nbsp;&nbsp;&nbsp;Developer&nbsp;&nbsp;Technology&nbsp;&nbsp;$5,500</li>
<li class="alt">300&nbsp;&nbsp;Raj&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sysadmin&nbsp;&nbsp;&nbsp;Technology&nbsp;&nbsp;$7,000</li>
<li class="">400&nbsp;&nbsp;Nisha&nbsp;&nbsp;&nbsp;Manager&nbsp;&nbsp;&nbsp;&nbsp;Marketing&nbsp;&nbsp;&nbsp;$9,500</li>
</ol>
</div>
<p>当然，可以将NOT操作与其他操作联合起来，以此实现更强大的功能 组合。</p>
<p>如，这个例子将得到：&lsquo;Manager或者Developer，但是不是Sales&rsquo;的结果：</p>
<div class="dp-highlighter bg_plain">
<div class="bar">
<div class="tools"><b>[plain]</b> <a class="ViewSource" title="view plain" href="http://blog.csdn.net/jackaduma/article/details/6900242#">view plain</a><a class="CopyToClipboard" title="copy" href="http://blog.csdn.net/jackaduma/article/details/6900242#">copy</a></p>
<div><embed id="ZeroClipboardMovie_17" src="http://static.blog.csdn.net/scripts/ZeroClipboard/ZeroClipboard.swf" type="application/x-shockwave-flash" width="18" height="18" align="middle" name="ZeroClipboardMovie_17"></embed></div>
</div>
</div>
<ol start="1">
<li class="alt">$&nbsp;egrep&nbsp;'Manager|Developer'&nbsp;employee.txt&nbsp;|&nbsp;grep&nbsp;-v&nbsp;Sales</li>
<li class="">200&nbsp;&nbsp;Jason&nbsp;&nbsp;&nbsp;Developer&nbsp;&nbsp;Technology&nbsp;&nbsp;$5,500</li>
<li class="alt">400&nbsp;&nbsp;Nisha&nbsp;&nbsp;&nbsp;Manager&nbsp;&nbsp;&nbsp;&nbsp;Marketing&nbsp;&nbsp;&nbsp;$9,500</li>
</ol>
<p>摘自『http://blog.csdn.net/jackaduma/article/details/6900242』</p>
</div>
