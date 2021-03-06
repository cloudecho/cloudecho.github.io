---
layout: post
status: publish
published: true
title: linux awk 内置函数详细介绍（实例）


date: '2015-12-27 11:31:33 +0800'
date_gmt: '2015-12-27 03:31:33 +0800'
categories:
- Util
tags:
- awk
- linux
- 函数
comments: []
---
<p>这节详细介绍awk内置函数，主要分以下3种类似：算数函数、字符串函数、其它一般函数、时间函数</p>
<p id="eb6a497986mela"><strong>一、算术函数:</strong></p>
<p>以下算术函数执行与 C 语言中名称相同的子例程相同的操作：</p>
<table border="0" width="545" cellspacing="1" cellpadding="4" bgcolor="#666666">
<tbody>
<tr>
<td bgcolor="#cccccc"><strong>函数名</strong></td>
<td bgcolor="#cccccc" width="405"><strong>说明</strong></td>
</tr>
<tr>
<td bgcolor="#ffffff" width="25%">atan2( y, x )</td>
<td bgcolor="#ffffff" width="405">返回 y/x 的反正切。</td>
</tr>
<tr>
<td bgcolor="#ffffff">cos( x )</td>
<td bgcolor="#ffffff" width="405">返回 x 的余弦；x 是弧度。</td>
</tr>
<tr>
<td bgcolor="#ffffff">sin( x )</td>
<td bgcolor="#ffffff" width="405">返回 x 的正弦；x 是弧度。</td>
</tr>
<tr>
<td bgcolor="#ffffff">exp( x )</td>
<td bgcolor="#ffffff" width="405">返回 x 幂函数。</td>
</tr>
<tr>
<td bgcolor="#ffffff">log( x )</td>
<td bgcolor="#ffffff" width="405">返回 x 的自然对数。</td>
</tr>
<tr>
<td bgcolor="#ffffff">sqrt( x )</td>
<td bgcolor="#ffffff" width="405">返回 x 平方根。</td>
</tr>
<tr>
<td bgcolor="#ffffff">int( x )</td>
<td bgcolor="#ffffff" width="405">返回 x 的截断至整数的值。</td>
</tr>
<tr>
<td bgcolor="#ffffff">rand( )</td>
<td bgcolor="#ffffff" width="405">返回任意数字 n，其中 0 <= n < 1。</td>
</tr>
<tr>
<td bgcolor="#ffffff">srand( [Expr] )</td>
<td bgcolor="#ffffff" width="405">将 rand 函数的种子值设置为 Expr 参数的值，或如果省略 Expr 参数则使用某天的时间。返回先前的种子值。</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>
<blockquote><p><strong>举例说明：</strong></p>
<p>[chengmo@centos5 ~]$ awk 'BEGIN{OFMT="%.3f";fs=sin(1);fe=exp(10);fl=log(10);fi=int(3.1415);print fs,fe,fl,fi;}'<br />
0.841 22026.466 2.303 3</p>
<p>&nbsp;</p>
<p>OFMT 设置输出数据格式是保留3位小数</p>
<p><strong>获得随机数：</strong></p>
<p>[chengmo@centos5 ~]$ awk 'BEGIN{srand();fr=int(100*rand());print fr;}'<br />
78<br />
[chengmo@centos5 ~]$ awk 'BEGIN{srand();fr=int(100*rand());print fr;}'<br />
31<br />
[chengmo@centos5 ~]$ awk 'BEGIN{srand();fr=int(100*rand());print fr;}'</p>
<p>41</p>
<p>&nbsp;</p></blockquote>
<p>&nbsp;</p>
<h5 id="a171c1272">二、字符串函数是：</h5>
<table border="0" width="464" cellspacing="1" cellpadding="4" bgcolor="#666666">
<tbody>
<tr>
<td bgcolor="#cccccc" width="163"><strong>函数</strong></td>
<td bgcolor="#cccccc" width="296"><strong>说明</strong></td>
</tr>
<tr>
<td bgcolor="#ffffff" width="163">gsub( Ere, Repl, [ In ] )</td>
<td bgcolor="#ffffff" width="296">除了正则表达式所有具体值被替代这点，它和 sub 函数完全一样地执行，。</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="163">sub( Ere, Repl, [ In ] )</td>
<td bgcolor="#ffffff" width="296">用 Repl 参数指定的字符串替换 In 参数指定的字符串中的由 Ere 参数指定的扩展正则表达式的第一个具体值。sub 函数返回替换的数量。出现在 Repl 参数指定的字符串中的 &amp;（和符号）由 In 参数指定的与 Ere 参数的指定的扩展正则表达式匹配的字符串替换。如果未指定 In 参数，缺省值是整个记录（$0 记录变量）。</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="163">index( String1, String2 )</td>
<td bgcolor="#ffffff" width="296">在由 String1 参数指定的字符串（其中有出现 String2 指定的参数）中，返回位置，从 1 开始编号。如果 String2 参数不在 String1 参数中出现，则返回 0（零）。</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="163">length [(String)]</td>
<td bgcolor="#ffffff" width="296">返回 String 参数指定的字符串的长度（字符形式）。如果未给出 String 参数，则返回整个记录的长度（$0 记录变量）。</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="163">blength [(String)]</td>
<td bgcolor="#ffffff" width="296">返回 String 参数指定的字符串的长度（以字节为单位）。如果未给出 String 参数，则返回整个记录的长度（$0 记录变量）。</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="163">substr( String, M, [ N ] )</td>
<td bgcolor="#ffffff" width="296">返回具有 N 参数指定的字符数量子串。子串从 String 参数指定的字符串取得，其字符以 M 参数指定的位置开始。M 参数指定为将 String 参数中的第一个字符作为编号 1。如果未指定 N 参数，则子串的长度将是 M 参数指定的位置到 String 参数的末尾 的长度。</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="163">match( String, Ere )</td>
<td bgcolor="#ffffff" width="296">在 String 参数指定的字符串（Ere 参数指定的扩展正则表达式出现在其中）中返回位置（字符形式），从 1 开始编号，或如果 Ere 参数不出现，则返回 0（零）。RSTART 特殊变量设置为返回值。RLENGTH 特殊变量设置为匹配的字符串的长度，或如果未找到任何匹配，则设置为 -1（负一）。</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="163">split( String, A, [Ere] )</td>
<td bgcolor="#ffffff" width="296">将 String 参数指定的参数分割为数组元素 A[1], A[2], . . ., A[n]，并返回 n 变量的值。此分隔可以通过 Ere 参数指定的扩展正则表达式进行，或用当前字段分隔符（FS 特殊变量）来进行（如果没有给出 Ere 参数）。除非上下文指明特定的元素还应具有一个数字值，否则 A 数组中的元素用字符串值来创建。</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="163">tolower( String )</td>
<td bgcolor="#ffffff" width="296">返回 String 参数指定的字符串，字符串中每个大写字符将更改为小写。大写和小写的映射由当前语言环境的 LC_CTYPE 范畴定义。</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="163">toupper( String )</td>
<td bgcolor="#ffffff" width="296">返回 String 参数指定的字符串，字符串中每个小写字符将更改为大写。大写和小写的映射由当前语言环境的 LC_CTYPE 范畴定义。</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="163">sprintf(Format, Expr, Expr, . . . )</td>
<td bgcolor="#ffffff" width="296">根据 Format 参数指定的 <a href="http://www.cnblogs.com/chengmo/admin/zh_CN/libs/basetrf1/printf.htm#a8zed0gaco">printf</a> 子例程格式字符串来格式化 Expr 参数指定的表达式并返回最后生成的字符串。</td>
</tr>
</tbody>
</table>
<h5 id="a171c127f">Ere都可以是正则表达式</h5>
<p>&nbsp;</p>
<blockquote><p><strong>gsub,sub使用</strong></p>
<p>[chengmo@centos5 ~]$ awk 'BEGIN{info="this is a test2010test!";gsub(/[0-9]+/,"!",info);print info}'<br />
this is a test!test!</p>
<p>&nbsp;</p>
<p>在 info中查找满足正则表达式，/[0-9]+/ 用&rdquo;&rdquo;替换，并且替换后的值，赋值给info 未给info值，默认是$0</p>
<p>&nbsp;</p>
<p><strong>查找字符串（index使用）</strong></p>
<p>[wangsl@centos5 ~]$ awk 'BEGIN{info="this is a test2010test!";print index(info,"test")?"ok":"no found";}'<br />
ok</p>
<p>未找到，返回0</p>
<p>&nbsp;</p>
<p><strong>正则表达式匹配查找(match使用）</strong></p>
<p>[wangsl@centos5 ~]$ awk 'BEGIN{info="this is a test2010test!";print match(info,/[0-9]+/)?"ok":"no found";}'<br />
ok</p>
<p>&nbsp;</p>
<p><strong>截取字符串(substr使用）</strong></p>
<p>[wangsl@centos5 ~]$ awk 'BEGIN{info="this is a test2010test!";print substr(info,4,10);}'<br />
s is a tes</p>
<p>从第 4个 字符开始，截取10个长度字符串</p>
<p>&nbsp;</p>
<p><strong>字符串分割（split使用）</strong></p>
<p>[chengmo@centos5 ~]$ awk 'BEGIN{info="this is a test";split(info,tA," ");print length(tA);for(k in tA){print k,tA[k];}}'<br />
4<br />
4 test<br />
1 this<br />
2 is<br />
3 a</p>
<p>&nbsp;</p>
<p>分割info,动态创建数组tA,这里比较有意思，awk for &hellip;in 循环，是一个无序的循环。 并不是从数组下标1&hellip;n ，因此使用时候需要注意。</p>
<p>&nbsp;</p>
<p><strong>格式化字符串输出（sprintf使用）</strong></p>
<p>格式化字符串格式：</p>
<p>其中格式化字符串包括两部分内容: 一部分是正常字符, 这些字符将按原样输出; 另一部分是格式化规定字符, 以"%"开始, 后跟一个或几个规定字符,用来确定输出内容格式。</p>
<p>&nbsp;</p>
<table border="0" width="361" cellspacing="1" cellpadding="4" bgcolor="#666666">
<tbody>
<tr>
<td bgcolor="#cccccc" width="87"><strong>格式符</strong></td>
<td bgcolor="#cccccc" width="269"><strong>说明</strong></td>
</tr>
<tr>
<td bgcolor="#ffffff" width="87">%d</td>
<td bgcolor="#ffffff" width="269">十进制有符号整数</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="87">%u</td>
<td bgcolor="#ffffff" width="269">十进制无符号整数</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="87">%f</td>
<td bgcolor="#ffffff" width="269">浮点数</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="87">%s</td>
<td bgcolor="#ffffff" width="269">字符串</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="87">%c</td>
<td bgcolor="#ffffff" width="269">单个字符</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="87">%p</td>
<td bgcolor="#ffffff" width="269">指针的值</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="87">%e</td>
<td bgcolor="#ffffff" width="269">指数形式的浮点数</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="87">%x</td>
<td bgcolor="#ffffff" width="269">%X 无符号以十六进制表示的整数</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="87">%o</td>
<td bgcolor="#ffffff" width="269">无符号以八进制表示的整数</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="87">%g</td>
<td bgcolor="#ffffff" width="269">自动选择合适的表示法</td>
</tr>
</tbody>
</table>
</blockquote>
<blockquote><p>[chengmo@centos5 ~]$ awk 'BEGIN{n1=124.113;n2=-1.224;n3=1.2345; printf("%.2f,%.2u,%.2g,%X,%o\n",n1,n2,n3,n1,n1);}'<br />
124.11,18446744073709551615,1.2,7C,174</p>
<p>&nbsp;</p></blockquote>
<h5>三、一般函数是：</h5>
<table border="0" width="443" cellspacing="1" cellpadding="4" bgcolor="#666666">
<tbody>
<tr>
<td bgcolor="#cccccc"><strong>函数</strong></td>
<td bgcolor="#cccccc" width="346"><strong>说明</strong></td>
</tr>
<tr>
<td bgcolor="#ffffff" width="21%">close( Expression )</td>
<td bgcolor="#ffffff" width="346">用同一个带字符串值的 Expression 参数来关闭由 print 或 printf 语句打开的或调用 getline 函数打开的文件或管道。如果文件或管道成功关闭，则返回 0；其它情况下返回非零值。如果打算写一个文件，并稍后在同一个程序中读取文件，则 close 语句是必需的。</td>
</tr>
<tr>
<td bgcolor="#ffffff">system(Command )</td>
<td bgcolor="#ffffff" width="346">执行 Command 参数指定的命令，并返回退出状态。等同于<a href="http://www.cnblogs.com/chengmo/admin/zh_CN/libs/basetrf2/system.htm#a181929c">system</a> 子例程。</td>
</tr>
<tr>
<td bgcolor="#ffffff">Expression | getline [ Variable ]</td>
<td bgcolor="#ffffff" width="346">从来自 Expression 参数指定的命令的输出中通过管道传送的流中读取一个输入记录，并将该记录的值指定给 Variable 参数指定的变量。如果当前未打开将 Expression 参数的值作为其命令名称的流，则创建流。创建的流等同于调用 <a href="http://www.cnblogs.com/chengmo/admin/zh_CN/libs/basetrf1/popen.htm#sk62b0shad">popen</a> 子例程，此时 Command 参数取 Expression 参数的值且 Mode 参数设置为一个是 r 的值。只要流保留打开且 Expression 参数求得同一个字符串，则对 getline 函数的每次后续调用读取另一个记录。如果未指定 Variable 参数，则 $0 记录变量和 NF 特殊变量设置为从流读取的记录。</td>
</tr>
<tr>
<td bgcolor="#ffffff">getline [ Variable ] < Expression</td>
<td bgcolor="#ffffff" width="346">从 Expression 参数指定的文件读取输入的下一个记录，并将 Variable 参数指定的变量设置为该记录的值。只要流保留打开且 Expression 参数对同一个字符串求值，则对 getline 函数的每次后续调用读取另一个记录。如果未指定 Variable 参数，则 $0 记录变量和 NF 特殊变量设置为从流读取的记录。</td>
</tr>
<tr>
<td bgcolor="#ffffff">getline [ Variable ]</td>
<td bgcolor="#ffffff" width="346">将 Variable 参数指定的变量设置为从当前输入文件读取的下一个输入记录。如果未指定 Variable 参数，则 $0 记录变量设置为该记录的值，还将设置 NF、NR 和 FNR 特殊变量。</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>
<blockquote><p><strong>打开外部文件（close用法）</strong></p>
<p>[chengmo@centos5 ~]$ awk 'BEGIN{while("cat /etc/passwd"|getline){print $0;};close("/etc/passwd");}'<br />
root:x:0:0:root:/root:/bin/bash<br />
bin:x:1:1:bin:/bin:/sbin/nologin<br />
daemon:x:2:2:daemon:/sbin:/sbin/nologin</p>
<p>&nbsp;</p>
<p><strong>逐行读取外部文件(getline使用方法）</strong></p>
<p>[chengmo@centos5 ~]$ awk 'BEGIN{while(getline < "/etc/passwd"){print $0;};close("/etc/passwd");}'<br />
root:x:0:0:root:/root:/bin/bash<br />
bin:x:1:1:bin:/bin:/sbin/nologin<br />
daemon:x:2:2:daemon:/sbin:/sbin/nologin</p>
<p>&nbsp;</p>
<p>[chengmo@centos5 ~]$ awk 'BEGIN{print "Enter your name:";getline name;print name;}'<br />
Enter your name:<br />
chengmo<br />
chengmo</p>
<p><strong>&nbsp;</strong></p>
<p><strong>调用外部应用程序(system使用方法）</strong></p>
<p>[chengmo@centos5 ~]$ awk 'BEGIN{b=system("ls -al");print b;}'<br />
total 42092<br />
drwxr-xr-x 14 chengmo chengmo&nbsp;&nbsp;&nbsp;&nbsp; 4096 09-30 17:47 .<br />
drwxr-xr-x 95 root&nbsp;&nbsp; root&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4096 10-08 14:01 ..</p>
<p>&nbsp;</p>
<p>b返回值，是执行结果。</p></blockquote>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p><strong>四、时间函数</strong></p>
<p><strong>&nbsp;</strong></p>
<table border="0" width="443" cellspacing="1" cellpadding="4" bgcolor="#666666">
<tbody>
<tr>
<td bgcolor="#cccccc" width="250"><strong>函数名</strong></td>
<td bgcolor="#cccccc" width="188"><strong>说明</strong></td>
</tr>
<tr>
<td bgcolor="#ffffff" width="250">mktime( YYYY MM DD HH MM SS[ DST])</td>
<td bgcolor="#ffffff" width="188">生成时间格式</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="250">strftime([format [, timestamp]])</td>
<td bgcolor="#ffffff" width="188">格式化时间输出，将时间戳转为时间字符串<br />
具体格式，见下表.</td>
</tr>
<tr>
<td bgcolor="#ffffff" width="250">systime()</td>
<td bgcolor="#ffffff" width="188">得到时间戳,返回从1970年1月1日开始到当前时间(不计闰年)的整秒数</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>
<blockquote><p><strong>创建指定时间(mktime使用）</strong></p>
<p>[chengmo@centos5 ~]$ awk 'BEGIN{tstamp=mktime("2001 01 01 12 12 12");print strftime("%c",tstamp);}'<br />
2001年01月01日 星期一 12时12分12秒</p>
<p>&nbsp;</p>
<p>[chengmo@centos5 ~]$ awk 'BEGIN{tstamp1=mktime("2001 01 01 12 12 12");tstamp2=mktime("2001 02 01 0 0 0");print tstamp2-tstamp1;}'<br />
2634468</p>
<p>求2个时间段中间时间差,介绍了strftime使用方法</p>
<p>&nbsp;</p>
<p>[chengmo@centos5 ~]$ awk 'BEGIN{tstamp1=mktime("2001 01 01 12 12 12");tstamp2=systime();print tstamp2-tstamp1;}'<br />
308201392</p>
<p>&nbsp;</p>
<p><strong>strftime日期和时间格式说明符</strong></p>
<table border="0" summary="日期和时间格式说明符" cellspacing="1" cellpadding="4" bgcolor="#666666">
<thead>
<tr>
<th>格式</th>
<th>描述</th>
</tr>
</thead>
<tbody>
<tr>
<td bgcolor="#ffffff">%a</td>
<td bgcolor="#ffffff">星期几的缩写(Sun)</td>
</tr>
<tr>
<td bgcolor="#ffffff">%A</td>
<td bgcolor="#ffffff">星期几的完整写法(Sunday)</td>
</tr>
<tr>
<td bgcolor="#ffffff">%b</td>
<td bgcolor="#ffffff">月名的缩写(Oct)</td>
</tr>
<tr>
<td bgcolor="#ffffff">%B</td>
<td bgcolor="#ffffff">月名的完整写法(October)</td>
</tr>
<tr>
<td bgcolor="#ffffff">%c</td>
<td bgcolor="#ffffff">本地日期和时间</td>
</tr>
<tr>
<td bgcolor="#ffffff">%d</td>
<td bgcolor="#ffffff">十进制日期</td>
</tr>
<tr>
<td bgcolor="#ffffff">%D</td>
<td bgcolor="#ffffff">日期 08/20/99</td>
</tr>
<tr>
<td bgcolor="#ffffff">%e</td>
<td bgcolor="#ffffff">日期，如果只有一位会补上一个空格</td>
</tr>
<tr>
<td bgcolor="#ffffff">%H</td>
<td bgcolor="#ffffff">用十进制表示24小时格式的小时</td>
</tr>
<tr>
<td bgcolor="#ffffff">%I</td>
<td bgcolor="#ffffff">用十进制表示12小时格式的小时</td>
</tr>
<tr>
<td bgcolor="#ffffff">%j</td>
<td bgcolor="#ffffff">从1月1日起一年中的第几天</td>
</tr>
<tr>
<td bgcolor="#ffffff">%m</td>
<td bgcolor="#ffffff">十进制表示的月份</td>
</tr>
<tr>
<td bgcolor="#ffffff">%M</td>
<td bgcolor="#ffffff">十进制表示的分钟</td>
</tr>
<tr>
<td bgcolor="#ffffff">%p</td>
<td bgcolor="#ffffff">12小时表示法(AM/PM)</td>
</tr>
<tr>
<td bgcolor="#ffffff">%S</td>
<td bgcolor="#ffffff">十进制表示的秒</td>
</tr>
<tr>
<td bgcolor="#ffffff">%U</td>
<td bgcolor="#ffffff">十进制表示的一年中的第几个星期(星期天作为一个星期的开始)</td>
</tr>
<tr>
<td bgcolor="#ffffff">%w</td>
<td bgcolor="#ffffff">十进制表示的星期几(星期天是0)</td>
</tr>
<tr>
<td bgcolor="#ffffff">%W</td>
<td bgcolor="#ffffff">十进制表示的一年中的第几个星期(星期一作为一个星期的开始)</td>
</tr>
<tr>
<td bgcolor="#ffffff">%x</td>
<td bgcolor="#ffffff">重新设置本地日期(08/20/99)</td>
</tr>
<tr>
<td bgcolor="#ffffff">%X</td>
<td bgcolor="#ffffff">重新设置本地时间(12：00：00)</td>
</tr>
<tr>
<td bgcolor="#ffffff">%y</td>
<td bgcolor="#ffffff">两位数字表示的年(99)</td>
</tr>
<tr>
<td bgcolor="#ffffff">%Y</td>
<td bgcolor="#ffffff">当前月份</td>
</tr>
<tr>
<td bgcolor="#ffffff">%Z</td>
<td bgcolor="#ffffff">时区(PDT)</td>
</tr>
<tr>
<td bgcolor="#ffffff">%%</td>
<td bgcolor="#ffffff">百分号(%)</td>
</tr>
</tbody>
</table>
</blockquote>
<p>&nbsp;</p>
<p>以上是awk常见 内置函数使用及说明，希望对大家有所帮助。</p>
<p>摘自『http://www.cnblogs.com/chengmo/archive/2010/10/08/1845913.html』</p>
