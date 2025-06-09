---
layout: post
status: publish
published: true
title: mac vi 语法高亮


date: '2015-12-09 21:23:44 +0800'
date_gmt: '2015-12-09 13:23:44 +0800'
categories:
- Util
tags:
- vi
comments: []
---
<p><code>$ cat .vimrc<br />
" Configuration file for vim<br />
set modelines=0 " CVE-2007-2438<br />
" Normally we use vim-extensions. If you want true vi-compatibility<br />
" remove change the following statements<br />
set nocompatible " Use Vim defaults instead of 100% vi compatibility<br />
set backspace=2 " more powerful backspacing<br />
syntax on<br />
set nu!<br />
set cindent<br />
set ruler<br />
" Don't write backup file if vim is being called by "crontab -e"<br />
au BufWrite /private/tmp/crontab.* set nowritebackup nobackup<br />
" Don't write backup file if vim is being called by "chpass"<br />
au BufWrite /private/etc/pw.* set nowritebackup nobackup</code></p>
