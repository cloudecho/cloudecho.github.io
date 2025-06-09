---
layout: post
title:  "Pretty git log in one line"
date:   2021-09-19 20:47:00 +0800
categories: Util
tags:
- git
---

TL;DR;

```sh
git config --global alias.logline "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

git logline
```

See [https://ma.ttias.be/pretty-git-log-in-one-line/](https://ma.ttias.be/pretty-git-log-in-one-line/)
