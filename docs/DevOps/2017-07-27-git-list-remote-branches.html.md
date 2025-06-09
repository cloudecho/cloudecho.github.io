---
layout: post
status: publish
published: true
title: git list remote branches


date: '2017-07-27 10:58:59 +0800'
date_gmt: '2017-07-27 02:58:59 +0800'
categories:
- Opensource
tags:
- git
- ls-remote
comments: []
---
<p>Sometimes you may need to figure out what&nbsp;<a href="http://gitready.com/beginner/2009/01/25/branching-and-merging.html">branches</a>&nbsp;exist on a remote repository so you can pull them down and check them out, merge them into your local branches, etc. If you&rsquo;re using&nbsp;<a href="http://github.com/">GitHub</a>&nbsp;or&nbsp;<a href="http://git.or.cz/gitwiki/Gitweb">gitweb</a>&nbsp;to host your repository it&rsquo;s usually easy to determine the branch names, but if you need to get them in general or for scripts it&rsquo;s not exactly clear.</p>
<p><a href="http://flickr.com/photos/joiseyshowaa/3100342708/"><img src="http://farm4.static.flickr.com/3163/3100342708_b12c4a36d6.jpg" alt="" /></a></p>
<p><strong><span class="caps">UPDATE</span>:</strong>&nbsp;The comments have enlightened me quite a bit&hellip;there seems to always be more than one way to skin a cat using Git. The easiest way is just to use the&nbsp;<code>git branch</code>&nbsp;commands&rsquo; various options.&nbsp;<code>-a</code>&nbsp;shows all local and remote branches, while&nbsp;<code>-r</code>shows only remote branches.</p>
<pre>$ git branch
* master

$ git branch -a
* master
  origin/1-2-stable
  origin/2-0-stable
  origin/2-1-stable
  origin/2-2-stable
  origin/3-0-unstable
  origin/HEAD
  origin/master

$ git branch -r
  origin/1-2-stable
  origin/2-0-stable
  origin/2-1-stable
  origin/2-2-stable
  origin/3-0-unstable
  origin/HEAD
  origin/master
</pre>
<p>So, once you know the name of the branch it&rsquo;s quite simple to&nbsp;<a href="http://gitready.com/intermediate/2009/01/09/checkout-remote-tracked-branch.html">check them out.</a>&nbsp;If you have color options on it&rsquo;s also quite easy to tell which branches aren&rsquo;t pulled down since they&rsquo;re listed in red.</p>
<p>There&rsquo;s also another way to do figure out what branches are on your remote by actually using the remote related commands,&nbsp;<code>git remote</code>&nbsp;and&nbsp;<code>git ls-remote</code>. The former displays plenty of information about the remote in general and how it relates to your own repository, while the latter simply lists all references to branches and tags that it knows about.</p>
<pre>$ git remote show origin
* remote origin
  URL: git://github.com/rails/rails.git
  Remote branch merged with 'git pull' while on branch master
    master
  Tracked remote branches
    1-2-stable 2-0-stable 2-1-stable 2-2-stable 3-0-unstable master

$ git ls-remote --heads origin
5b3f7563ae1b4a7160fda7fe34240d40c5777dcd  refs/heads/1-2-stable
71926912a127da29530520d435c83c48778ac2b2  refs/heads/2-0-stable
2b158543247a150e8ec568becf360e7376f8ab84  refs/heads/2-1-stable
b0792a3e7be88e3060af19bab01cd3d26d347e4c  refs/heads/2-2-stable
d6b9f8410c990b3d68d1970f1461a1d385d098d7  refs/heads/3-0-unstable
f04346d8b999476113d5e5a30661e07899e3ff80  refs/heads/master
</pre>
<p>The&nbsp;<code>ls-remote</code>&nbsp;command returns the SHA1 hash of the latest commit for that reference, so it is quite easy to parse out and get to the exact commit you need if you&rsquo;re doing some scripting. The&nbsp;<code>--heads</code>&nbsp;option lists only branch names since the command can list tags too.</p>
<p>If you have any other uses for these commands or an easier way to figure out branches that live on a remote, comment away!</p>
<p>Source:&nbsp;http://gitready.com/intermediate/2009/02/13/list-remote-branches.html</p>
