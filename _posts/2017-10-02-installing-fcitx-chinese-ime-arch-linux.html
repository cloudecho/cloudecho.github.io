---
layout: post
status: publish
published: true
title: Installing fcitx (a Chinese IME) on Arch Linux


date: '2017-10-02 10:04:59 +0800'
date_gmt: '2017-10-02 02:04:59 +0800'
categories:
- Util
tags:
- linux
- arch
comments: []
---
<p><strong>Source</strong>:&nbsp;http://www.fanz.io/2015/10/10/fcitx-notes.html</p>
<div class="ui text main container">
<div class="ui blog-title center aligned text container"></div>
<div class="ui blog-meta center aligned container">
<div class="ui celled horizontal list">
<div class="item"><i class="calendar icon"></i>Oct 10, 2015</div>
<div class="item">By Fan Zhang</div>
<div class="item"><i class="tags icon"></i>&nbsp;<a href="http://www.fanz.io/tags.html#Arch-Linux">Arch Linux</a>,&nbsp;<a href="http://www.fanz.io/tags.html#Tools">Tools</a>,</div>
</div>
</div>
<div class="ui text blog container">
<p>Fcitx is a popular Chinese input method engine (IME) suggested by ArchWiki. Fcitx is awesome but every time I (re)install Arch Linux on my boxes, I had trouble getting fcitx to work out of the box --&nbsp;<code>pacman -Syu fcitx-im</code>&nbsp;doesn't give you a working IME. I guess a major facet making the installation and configuration so tricky is that fcitx doesn't provide an all-in-one configuration tool (I guess for good reason though), so as an user you will have to manually put various configuration snippets at several different places. Moreover, before getting all of them right, fcitx just won't work, which makes debugging even more frustrating. So, this short note serves as a memo for myself and hopefully can help others run into the similar troubles.</p>
<h1 id="prerequisites">Prerequisites</h1>
<p>Before installing&nbsp;<code>fcitx</code>, you'll need proper fonts installed. ArchWiki (e.g.&nbsp;<a href="https://wiki.archlinux.org/index.php/Fonts#Chinese.2C_Japanese.2C_Korean.2C_Vietnamese">this page</a>) has a comprehensive guidance for doing this.</p>
<h1 id="installation">Installation</h1>
<p>Once the necessary fonts are correctly installed, which can be verified by checking if your browser can render Chinese characters correctly when you go to renren.com or so on, we can proceed to the installation of fcitx.</p>
<p>Okay, basically there are three pieces of software to be installed: the&nbsp;<code>fcitx</code>&nbsp;itself, one or more IMEs of your choices (e.g. I like&nbsp;<code>fcitx-googlepinyin</code>) and a couple of input method engines for various toolkits (gtk2, gtk3, etc.). For convenience, they can be installed as a bundle by group&nbsp;<code>fcitx-im</code>. I also installed a GUI configuration tool (<code>fcitx-configtool</code>), which is not mandatory but makes my life a little bit easier.</p>
<div class="highlight">
<pre><code class="language-shell" data-lang="shell">pacman -Syu fcitx fcitx-googlepinyin fcitx-im  fcitx-configtool
</code></pre>
</div>
<h1 id="configuration">Configuration</h1>
<p>As I said, there are multiple pieces of configuration to be tweaked. Before getting all of them right, fcitx will not work.</p>
<p>First, you need to register those input method modules before using them. Depending on you choice of display manager, add the following lines to your startup script file to. Use&nbsp;<code>.xprofile</code>&nbsp;if you are using KDM, GDM, LightDM or SDDM. Use&nbsp;<code>.xinitrc</code>&nbsp;if you are using&nbsp;<code>startx</code>&nbsp;or Slim.</p>
<div class="highlight">
<pre><code class="language-shell" data-lang="shell"><span class="c"># .xprofile or .xinitrc</span>
<span class="nb">export </span><span class="nv">GTK_IM_MODULE</span><span class="o">=</span>fcitx
<span class="nb">export </span><span class="nv">QT_IM_MODULE</span><span class="o">=</span>fcitx
<span class="nb">export </span><span class="nv">XMODIFIERS</span><span class="o">=</span>@im<span class="o">=</span>fcitx
</code></pre>
</div>
<p>Second, if your locale is&nbsp;<code>en_US.UTF-8</code>, IME for Chinese will&nbsp;<em>not</em>&nbsp;be activated by default. You'll get a notice by&nbsp;<code>fcitx-dianose</code>&nbsp;command like this:</p>
<div class="highlight">
<pre><code class="language-" data-lang="">## Input Methods:
    1.  Found 1 enabled input methods:
            fcitx-keyboard-us
    2.  Default input methods:
        **You only have one input method enabled, please add a keyboard input method as the first one and your main input method as the second one.**
</code></pre>
</div>
<p>In my case, I managed to add&nbsp;<code>google-pinyin</code>&nbsp;using&nbsp;<code>fcitx-configtool</code>. Simply launch the GUI program and add input methods as you like and re-login.</p>
<h1 id="use-fcitx">Use fcitx</h1>
<p>Believe it or not, figuring out how to switch to Chinese input mode consumed the most of my time in this process. One correct way of doing this is to press&nbsp;<code>Ctrl-Space</code>&nbsp;while focusing on an input field. If a little widget shows up, you're all set. Otherwise, which is highly likely, please proceed to the next section :)</p>
<h1 id="troubleshooting">Troubleshooting</h1>
<p>Fcitx provided nice tools for troubleshooting. However, before getting to the correct way of debugging, please be advised not to fall into the following pitfall as I did:</p>
<p>If you're using a desktop environment that happens to a system tray, don't expect an icon there for fcitx (although many other IMEs do have system tray icons). For unknown reasons,&nbsp;<code>fcitx</code>&nbsp;doesn't display a system tray icon in my case, which confused me a lot because I expect that icon to appear to indicate fcitx is working properly. Long story short: never try to find a system tray icon.</p>
<p>The most adorable thing from an user's point of view is&nbsp;<code>fcitx-diagnose</code>. This is a small diagnose program coming with&nbsp;<code>fcitx</code>&nbsp;package, which does not only provide informative diagnosis but also quick fix tips. Whenever you're not sure if you're doing things right (e.g. when you can't find a system tray icon), just run&nbsp;<code>fcitx-diagnose</code>&nbsp;and check out the red bold errors.</p>
<h1 id="resources">Resources</h1>
<p>I found ArchWiki page on&nbsp;<a href="https://wiki.archlinux.org/index.php/Fcitx">fcitx</a>&nbsp;super informative.</p>
</div>
</div>
<footer>
<div class="ui main center aligned text container"></div>
</footer>
<p>&nbsp;</p>
