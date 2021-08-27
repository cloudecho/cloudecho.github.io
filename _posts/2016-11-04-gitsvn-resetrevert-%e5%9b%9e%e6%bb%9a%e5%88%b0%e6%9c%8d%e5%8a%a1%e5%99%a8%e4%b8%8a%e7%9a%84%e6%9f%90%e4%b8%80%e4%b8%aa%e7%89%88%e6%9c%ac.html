---
layout: post
status: publish
published: true
title: git/svn reset/revert 回滚到服务器上的某一个版本


date: '2016-11-04 15:25:44 +0800'
date_gmt: '2016-11-04 07:25:44 +0800'
categories:
- Opensource
tags:
- svn
- git
comments: []
---
<p>Git:</p>
<p>1、git log</p>
<p>查找到要回滚的版本号，设为aldfjsajdfljsadf</p>
<p>2、git reset &nbsp;--hard&nbsp;aldfjsajdfljsadf</p>
<p>reset 会影响 commit&nbsp;aldfjsajdfljsadf 之后的commit都会被退回到暂存区</p>
<p>revert是撤销某次操作，此次操作之前的commit都会被保留，貌似之后的也会被保留</p>
<p>git revert 撤销 某次操作，此次操作之前和之后的commit和history都会保留，并且把这次撤销<br />
作为一次最新的提交<br />
* git revert HEAD&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 撤销前一次 commit<br />
* git revert HEAD^&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 撤销前前一次 commit<br />
* git revert commit （比如：fa042ce57ebbe5bb9c8db709f719cec2c58ee7ff）撤销指定的版本，撤销也会作为一次提交进行保存。<br />
git revert是提交一个新的版本，将需要revert的版本的内容再反向修改回去，版本会递增，不影响之前提交的内容</p>
<p>Svn:</p>
<p>svn log</p>
<p>查找到要回滚的版本号</p>
<p>------------------------------------------------------------------------<br />
r26 | yaoming | 2014-02-12 15:06:17 +0800 | 5 行<br />
[BSP]移除BSP分支<br />
适用机型:M65U<br />
验证建议:<br />
关联变更项: 无<br />
checked by liuxiang<br />
------------------------------------------------------------------------<br />
r25 | yaoming | 2014-02-11 17:55:44 +0800 | 5 行<br />
[BSP]添加MT6592平台支持<br />
适用机型:M65U<br />
验证建议:<br />
关联变更项: 无<br />
checked by liuxiang</p>
<p><strong>从26回滚到25</strong></p>
<p><strong>svn diff -r 26:25 ""<br />
</strong></p>
<p><strong>svn merge -r&nbsp;26:25 ""</strong></p>
<h1 class="postTitle"><a id="cb_post_title_url" class="postTitle2" href="http://www.cnblogs.com/jndream/archive/2012/03/20/2407955.html" target="_blank">svn代码回滚命令</a></h1>
<div id="cnblogs_post_body">
<div>取消对代码的修改分为两种情况：</div>
<div><strong>第一种情况：改动没有被提交（commit）。</strong></div>
<div>这种情况下，使用svn revert就能取消之前的修改。</div>
<div>svn revert用法如下：</div>
<div># svn revert [-R] something</div>
<div>其中something可以是（目录或文件的）相对路径也可以是绝对路径。</div>
<div>当something为单个文件时，直接svn revert something就行了；当something为目录时，需要加上参数-R(Recursive,递归)，否则只会将something这个目录的改动。</div>
<div>在这种情况下也可以使用svn update命令来取消对之前的修改，但不建议使用。因为svn update会去连接仓库服务器，耗费时间。</div>
<div>注意：svn revert本身有固有的危险，因为它的目的是放弃未提交的修改。一旦你选择了恢复，Subversion没有方法找回未提交的修改。</div>
<div><strong>第二种情况：改动已经被提交（commit）。</strong></div>
<div>这种情况下，用svn merge命令来进行回滚。</div>
<div>&nbsp;&nbsp;&nbsp;回滚的操作过程如下：</div>
<div>&nbsp;&nbsp;&nbsp;1、保证我们拿到的是最新代码：</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;svn update</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;假设最新版本号是28。</div>
<div>&nbsp;&nbsp;&nbsp;2、然后找出要回滚的确切版本号：</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;svn log [something]</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;假设根据svn log日志查出要回滚的版本号是25，此处的something可以是文件、目录或整个项目</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如果想要更详细的了解情况，可以使用svn diff -r 28:25 [something]</div>
<div>&nbsp;&nbsp;&nbsp;3、回滚到版本号25：</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;svn merge -r 28:25 something</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;为了保险起见，再次确认回滚的结果：</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;svn diff [something]</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;发现正确无误，提交。</div>
<div>&nbsp;&nbsp;&nbsp;4、提交回滚：</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;svn commit -m "Revert revision from r28 to r25,because of ..."</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;提交后版本变成了29。</div>
<div>&nbsp;&nbsp;&nbsp;将以上操作总结为三条如下：</div>
<div>&nbsp;&nbsp;&nbsp;1. svn update，svn log，找到最新版本（latest revision）</div>
<div>&nbsp;&nbsp;&nbsp;2. 找到自己想要回滚的版本号（rollbak revision）</div>
<div>&nbsp;&nbsp;&nbsp;3. 用svn merge来回滚： svn merge -r : something</div>
<div></div>
</div>
<div>摘自「http://blog.csdn.net/angle_birds/article/details/19506405」</div>
