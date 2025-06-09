---
layout: post
status: publish
published: true
title: QuartZ Cron表达式


date: '2015-12-08 11:09:35 +0800'
date_gmt: '2015-12-08 03:09:35 +0800'
categories:
- Opensource
tags:
- QuartZ
- Cron
comments: []
---
<div class="posthead">
<h2>CronTrigger</h2>
</div>
<div class="postbody">
<div id="cnblogs_post_body">
<p>CronTriggers往往比SimpleTrigger更有用，如果您需要基于日历的概念，而非SimpleTrigger完全指定的时间间隔，复发的发射工作的时间表。<br />
CronTrigger，你可以指定触发的时间表如&ldquo;每星期五中午&rdquo;，或&ldquo;每个工作日9:30时&rdquo;，甚至&ldquo;每5分钟一班9:00和10:00逢星期一上午，星期三星期五&ldquo;。<br />
即便如此，SimpleTrigger一样，CronTrigger拥有的startTime指定的时间表时生效，指定的时间表时，应停止（可选）结束时间。</p>
<h4>Cron Expressions</h4>
<p>cron的表达式被用来配置CronTrigger实例。&nbsp;cron的表达式是字符串，实际上是由七子表达式，描述个别细节的时间表。这些子表达式是分开的空白，代表：</p>
<ol>
<li><strong>1.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </strong><strong>&nbsp;Seconds</strong></li>
<li><strong>2.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </strong><strong>&nbsp;Minutes</strong></li>
<li><strong>3.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </strong><strong>&nbsp;Hours</strong></li>
<li><strong>4.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </strong><strong>&nbsp;Day-of-Month</strong></li>
<li><strong>5.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </strong><strong>&nbsp;Month</strong></li>
<li><strong>6.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </strong><strong>&nbsp;Day-of-Week</strong></li>
<li><strong>7.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </strong><strong>&nbsp;Year (</strong><strong>可选字段</strong><strong>)</strong></li>
</ol>
<p align="left">例 &nbsp;"0 0 12 ? * WED" 在每星期三下午12:00 执行,</p>
<p align="left">个别子表达式可以包含范围, 例如，在前面的例子里("WED")可以替换成 "MON-FRI", "MON, WED, FRI"甚至"MON-WED,SAT".</p>
<p>&ldquo;*&rdquo; 代表整个时间段.</p>
<p>每一个字段都有一套可以指定有效值，如</p>
<p><strong>Seconds</strong> (秒)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ：可以用数字0－59 表示，</p>
<p><strong>Minutes(</strong>分)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ：可以用数字0－59 表示，</p>
<p><strong>Hours(</strong>时)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ：可以用数字0-23表示,</p>
<p><strong>Day-of-Month(</strong>天) ：可以用数字1-31 中的任一一个值，但要注意一些特别的月份</p>
<p><strong>Month(</strong>月)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ：可以用0-11 或用字符串 &nbsp;&ldquo;JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV and DEC&rdquo; 表示</p>
<p><strong>Day-of-Week(</strong><strong>每周</strong><strong>)</strong><strong>：</strong>可以用数字1-7表示（1 ＝ 星期日）或用字符口串&ldquo;SUN, MON, TUE, WED, THU, FRI and SAT&rdquo;表示</p>
<p>&ldquo;/&rdquo;：为特别单位，表示为&ldquo;每&rdquo;如&ldquo;0/15&rdquo;表示每隔15分钟执行一次,&ldquo;0&rdquo;表示为从&ldquo;0&rdquo;分开始, &ldquo;3/20&rdquo;表示表示每隔20分钟执行一次，&ldquo;3&rdquo;表示从第3分钟开始执行</p>
<p>&ldquo;?&rdquo;：表示每月的某一天，或第周的某一天</p>
<p>&ldquo;L&rdquo;：用于每月，或每周，表示为每月的最后一天，或每个月的最后星期几如&ldquo;6L&rdquo;表示&ldquo;每月的最后一个星期五&rdquo;</p>
<p>&ldquo;W&rdquo;：表示为最近工作日，如&ldquo;15W&rdquo;放在每月（day-of-month）字段上表示为&ldquo;到本月15日最近的工作日&rdquo;</p>
<p>&ldquo;&ldquo;#&rdquo;：是用来指定&ldquo;的&rdquo;每月第n个工作日,例 在每周（day-of-week）这个字段中内容为"6#3" or "FRI#3" 则表示&ldquo;每月第三个星期五&rdquo;</p>
<p>&nbsp;</p>
<p>1）Cron表达式的格式：秒 分 时 日 月 周 年(可选)。</p>
<p>字段名&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 允许的值&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 允许的特殊字符<br />
秒&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; 0-59&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; , - * /<br />
分&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0-59&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; , - * /<br />
小时&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 0-23&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; , - * /<br />
日&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; 1-31&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; , - * ? / L W C<br />
月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1-12 or JAN-DEC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;, - * /<br />
周几&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1-7 or SUN-SAT&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;, - * ? / L C #<br />
年 (可选字段)&nbsp;&nbsp;&nbsp;&nbsp; empty, 1970-2099&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; , - * /</p>
<p>&nbsp;</p>
<p>&ldquo;?&rdquo;字符：表示不确定的值</p>
<p>&ldquo;,&rdquo;字符：指定数个值</p>
<p>&ldquo;-&rdquo;字符：指定一个值的范围</p>
<p>&ldquo;/&rdquo;字符：指定一个值的增加幅度。n/m表示从n开始，每次增加m</p>
<p>&ldquo;L&rdquo;字符：用在日表示一个月中的最后一天，用在周表示该月最后一个星期X</p>
<p>&ldquo;W&rdquo;字符：指定离给定日期最近的工作日(周一到周五)</p>
<p>&ldquo;#&rdquo;字符：表示该月第几个周X。6#3表示该月第3个周五</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>2）Cron表达式范例：</p>
<p>每隔5秒执行一次：*/5 * * * * ?</p>
<p>每隔1分钟执行一次：0 */1 * * * ?</p>
<p>每天23点执行一次：0 0 23 * * ?</p>
<p>每天凌晨1点执行一次：0 0 1 * * ?</p>
<p>每月1号凌晨1点执行一次：0 0 1 1 * ?</p>
<p>每月最后一天23点执行一次：0 0 23 L * ?</p>
<p>每周星期天凌晨1点实行一次：0 0 1 ? * L</p>
<p>在26分、29分、33分执行一次：0 26,29,33 * * * ?</p>
<p>每天的0点、13点、18点、21点都执行一次：0 0 0,13,18,21 * * ?</p>
<p>摘自『http://www.cnblogs.com/sunjie9606/archive/2012/03/15/2397626.html』</p>
</div>
</div>
