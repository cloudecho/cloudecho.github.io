---
layout: post
status: publish
published: true
title: rc.local in osx-yosemite


date: '2015-12-09 21:04:34 +0800'
date_gmt: '2015-12-09 13:04:34 +0800'
categories:
- Util
tags:
- rc.local
comments: []
---
<p>I created&nbsp;<code>/Library/LaunchDaemons/local.localhost.startup.plist</code>&nbsp;containing the code below. It runs the rc.local script once at start up.</p>
<table>
<tbody>
<tr>
<td class="answercell">
<div class="post-text">

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>             <string>local.localhost.startup</string>
    <key>Disabled</key>          <false/>
    <key>RunAtLoad</key>         <true/>
    <key>KeepAlive</key>         <false/>
    <key>LaunchOnlyOnce</key>    <true/>
    <key>ProgramArguments</key>
        <array>
            <string>/etc/rc.local</string>
        </array>
</dict>
</plist> 
```

</div>
</td>
</tr>
</tbody>
</table>
<p>摘自『http://apple.stackexchange.com/questions/153387/problem-with-startup-script-rc-local-in-os-x-10-10-yosemite-running-bootcamp-in』</p>
