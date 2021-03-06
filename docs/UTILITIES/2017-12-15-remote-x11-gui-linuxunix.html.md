---
layout: post
status: publish
published: true
title: Remote X11 GUI For Linux/Unix


date: '2017-12-15 14:07:47 +0800'
date_gmt: '2017-12-15 06:07:47 +0800'
categories:
- Util
tags:
- linux
- X11
comments: []
---
<h4><strong>Source</strong>:&nbsp;https://www.redwireservices.com/remote-x11-for-linux-unix</h4>
<h1>The Problem</h1>
<p>One of my most feared questions from end users is &ldquo;how can I interact with an X11 GUI application on our remote Linux system if I have no access to the physical console, X11 isn&rsquo;t installed, and there is no VNC access?&rdquo; &nbsp;After hearing this many times at one site, I wrote a script to automate the server side process, but even that does not address the whole story. &nbsp;I&rsquo;m&nbsp;writing&nbsp;this post as a quick reference when I field this question in the future, and I hope it helps you, too.</p>
<p>The problem is that most system administrators do not install X11, Xorg, or other GUI interfaces on Linux and Unix systems as this introduces more packages to manage and patch, more security bugs to fix/mitigate, and a larger install footprint (more used space). That last point may seem moot today, but with many environments deploying hundreds of virtual machines, 200-400MB of extra space per VM can really add up quickly (see my latest presentation on&nbsp;<a title="An Updated Look at Open Source Data Deduplication" href="https://www.redwireservices.com/an-updated-look-at-open-source-data-deduplication" target="_blank" rel="noopener noreferrer">Open Source Data Deduplication</a>&nbsp;for more ideas on saving space in these environments). &nbsp;If you consider the overhead of installing a modern desktop/windowing system such as&nbsp;<a title="The GNOME Project" href="https://www.redwireservices.com/wp-content/uploads/2011/08/www.gnome.org" target="_blank" rel="noopener noreferrer">Gnome</a>&nbsp;or&nbsp;<a title="The KDE Project" href="https://www.redwireservices.com/wp-content/uploads/2011/08/www.kde.org" target="_blank" rel="noopener noreferrer">KDE</a>, it could easily more than double the data size footprint of a Linux server.</p>
<p>OK, many environments don&rsquo;t install the Linux/Unix GUI bits (also known as X11 or Xorg server), so who cares, I can just install everything via the command line, right? &nbsp;Well, yes, for the most part you can just install applications via the command line and forget this whole issue. &nbsp;However, there are a few vendor applications,&nbsp;notably&nbsp;including Oracle Database and Application Server products, that are difficult if not impossible to install without a GUI.</p>
<h1>The Solution</h1>
<p>The modern solution to the problem stated above is to tunnel X11 traffic over ssh (securely), and display it on your workstation, whether it be Windows, Mac OS X, or Linux. &nbsp;For sake of helping the most folks, we&rsquo;ll focus on Windows workstations here, but Linux and Mac OS X should work with only the server side changes we write here (just connect with the command line&nbsp;<em>ssh -Y your_username@your_servername.com</em>).</p>
<p>In certain circumstances, it may be&nbsp;advantageous&nbsp;to setup a VNC server to accomplish the same thing, but that requires more of X11 and an windowing environment be configured on the server side, and we&rsquo;d like to avoid as many server side changes as possible, as many users won&rsquo;t have access to make these changes themselves.</p>
<h2>PROCESS OVERVIEW</h2>
<p>In order to obtain the ability to&nbsp;interact&nbsp;with an X11 GUI remotely, we will follow these general steps:</p>
<ol>
<li>Ensure that the foundational X11 packages are installed</li>
<li>Ensure that OpenSSH server is configured to forward X11 connections</li>
<li>Configure a local X11 server on our workstation</li>
<li>Configure our ssh application to forward X11 requests</li>
<li>Test with a simple application</li>
<li>Configured authentication if user changes are needed</li>
<li>Move on with the task at hand</li>
</ol>
<div><span class="Apple-style-span">&nbsp;</span></div>
<h2>1) ENSURE THAT THE FOUNDATIONAL X11 PACKAGES ARE INSTALLED</h2>
<p>In order to use remote X11, you must have a few X11 packages installed on the server. &nbsp;In many cases these are already installed, but you may have to ask your System Administrator to install them for you, it&rsquo;s easy:</p>
<p>RHEL/CentOS/Fedora (xterm is optional, but&nbsp;beneficial&nbsp;for testing):</p>
<pre>sudo yum install xorg-x11-xauth xterm
<em>sudo yum install libXext.x86_64</em>
<em>sudo yum install libXrender.x86_64</em>
<em>sudo yum install libXtst.x86_64</em></pre>
<h2>2) ENSURE THAT OPENSSH SERVER IS CONFIGURED TO FORWARD X11 CONNECTIONS</h2>
<p>On RHEL and related RedHat based servers, the file to check is /etc/ssh/sshd_config. &nbsp;Review this file for the following line:</p>
<pre>X11Forwarding yes</pre>
<p>If that line is preceded by a comment (<em>#</em>) or is set to&nbsp;<em>no</em>, update the file to match the above, and restart your ssh server daemon (be careful here &mdash; if you made an error you may lock yourself out of the server).</p>
<pre>sudo /etc/init.d/sshd restart</pre>
<h2>3)&nbsp;CONFIGURE A LOCAL X11 SERVER ON YOUR WORKSTATION</h2>
<p>Next we need to install and configure a local X11 server,&nbsp;<a title="Xming" href="https://www.redwireservices.com/wp-content/uploads/2011/08/XmingNotes" target="_blank" rel="noopener noreferrer">Xming&nbsp;</a>or&nbsp;<a title="Cygwin/X" href="https://www.redwireservices.com/wp-content/uploads/2011/08/x.cygwin.com" target="_blank" rel="noopener noreferrer">Cygwin/X</a>&nbsp;are popular</p>
<div id="attachment_660" class="wp-caption alignright"><a href="https://www.redwireservices.com/wp-content/uploads/2011/08/StartXming.png"><img class="size-full wp-image-660" title="StartXming" src="https://www.redwireservices.com/wp-content/uploads/2011/08/StartXming.png" alt="" width="265" height="241" /></a></p>
<p class="wp-caption-text">Click Xming to start the Xming X11 Server on your Desktop/Workstation</p>
</div>
<p>free choices for Windows. &nbsp;Simply download and follow the install instructions for these packages, Xming is by far easier to setup for beginners. &nbsp;After the install is complete, and you&rsquo;ve rebooted your workstation/desktop (if requested), start the X11 server application from the start menu.</p>
<h2>4) CONFIGURE OUR SSH APPLICATION TO FORWARD X11 REQUESTS</h2>
<p>Next, we need to ensure that our ssh client is configured to forward X11 requests from the server. &nbsp;If you are using Cygwin/X, a Mac, or a Linux desktop, simple open up a terminal and preface your ssh command with&nbsp;<em>-Y</em>, for example:</p>
<pre>ssh -Y your_username@your_server.your_domain.com</pre>
<p>That will tell SSH to forward all X11 requests to your local desktop. &nbsp;For Windows, the most popular client is&nbsp;<a title="PuTTY SSH Client" href="https://www.redwireservices.com/wp-content/uploads/2011/08/putty" target="_blank" rel="noopener noreferrer">PuTTY</a>. &nbsp;To&nbsp;achieve&nbsp;the same result in PuTTY, load the profile of the server you wish to connect to, or simply fill out the connection details. &nbsp;Next expand the&nbsp;<em>Connection</em>&nbsp;and&nbsp;<em>SSH</em>&nbsp;options on the left hand side. &nbsp;Under&nbsp;<em>SSH&nbsp;</em>and then&nbsp;<em>X11,&nbsp;</em>ensure that&nbsp;<em>Enable X11 Forwarding</em>&nbsp;is checked.</p>
<div id="attachment_661" class="wp-caption aligncenter"><a href="https://www.redwireservices.com/wp-content/uploads/2011/08/Putty_X11_forward.png"><img class="size-full wp-image-661" title="Putty_X11_forward" src="https://www.redwireservices.com/wp-content/uploads/2011/08/Putty_X11_forward.png" sizes="(max-width: 466px) 100vw, 466px" srcset="http://www.redwireservices.com/wp-content/uploads/2011/08/Putty_X11_forward.png 466w, http://www.redwireservices.com/wp-content/uploads/2011/08/Putty_X11_forward-300x287.png 300w" alt="" width="466" height="446" /></a></p>
<p class="wp-caption-text">PuTTY Configuration Window Show X11 Forwarding Enabled.</p>
</div>
<p>Finally, click the&nbsp;<em>Open</em>&nbsp;button to connect to the remote server.</p>
<h2>5) TEST WITH A SIMPLE APPLICATION</h2>
<p>If everything has gone according to plan you now have a server configured to allow X11 connections, an ssh client configured likewise, and you are ready to test. &nbsp;When connecting to the remote server (last step in part 4 above), you may see a message like this:</p>
<pre>/usr/bin/xauth:  creating new authority file /home/ec2-user/.Xauthority</pre>
<p>This is a normal message, and in fact it tells us that part of our changes are working! &nbsp;This file contains an authentication token required to connect with the X11 server. &nbsp;Now to test, it&rsquo;s easy, just enter this command on the remote ssh session:</p>
<pre>xterm</pre>
<p>Wait just a few seconds depending on your internet/network connection speed, and you should see the following.</p>
<div id="attachment_663" class="wp-caption aligncenter"><a href="https://www.redwireservices.com/wp-content/uploads/2011/08/xterm.png"><img class="size-full wp-image-663" title="xterm" src="https://www.redwireservices.com/wp-content/uploads/2011/08/xterm.png" sizes="(max-width: 515px) 100vw, 515px" srcset="http://www.redwireservices.com/wp-content/uploads/2011/08/xterm.png 515w, http://www.redwireservices.com/wp-content/uploads/2011/08/xterm-300x205.png 300w" alt="Xterm shown via remote X11 on Windows" width="515" height="352" /></a></p>
<p class="wp-caption-text">xterm displayed on Windows from a remote Linux Server</p>
</div>
<p>If you see something similar, congratulations! &nbsp;Remote X11 connections are working!</p>
<h2>6) CONFIGURED AUTHENTICATION IF USER CHANGES ARE NEEDED</h2>
<p>X11 forwarding is working, great! &nbsp;These days, however, users are often not allowed to log in as root, which is great for security, but adds yet another step to our process. &nbsp;In step 5 we ran xterm as ourselves, which validates our setup is proper. &nbsp;Try running the same command as another user, though, via&nbsp;<em>sudo</em>&nbsp;and you&rsquo;ll likely see an error like the following.</p>
<div id="attachment_664" class="wp-caption aligncenter"><a href="https://www.redwireservices.com/wp-content/uploads/2011/08/X11_error.png"><img class="size-full wp-image-664 " title="X11_error" src="https://www.redwireservices.com/wp-content/uploads/2011/08/X11_error.png" sizes="(max-width: 534px) 100vw, 534px" srcset="http://www.redwireservices.com/wp-content/uploads/2011/08/X11_error.png 835w, http://www.redwireservices.com/wp-content/uploads/2011/08/X11_error-300x168.png 300w" alt="X11 Error from Improper .Xauthority" width="534" height="301" /></a></p>
<p class="wp-caption-text">X11 Error from Improper Xauth Configuration</p>
</div>
<p>The problem here is that a&nbsp;<em>.Xauthority</em>&nbsp;file is created automatically at log in time for our user, allowing our user access to our local X11 server (on our desktop). &nbsp;However, when root tries to access this connection it is denied without the proper permissions.</p>
<p>To work around this, simply copy the&nbsp;<em>.Xauthority</em>&nbsp;file from your user directory to the user you want to work with (root for example). &nbsp;Note that this should be done from your user account, not as root:</p>
<pre>sudo cp ~/.Xauthority ~root/</pre>
<pre>sudo /bin/chown root ~root/.Xauthority</pre>
<p>Try running&nbsp;<em>xterm&nbsp;</em>again as root, it should work.</p>
<pre>sudo xterm</pre>
<h2>7) MOVE ON WITH THE TASK AT HAND</h2>
<p>There you have it, now that you can login remotely and still access a GUI as any user, you can move on to installing your GUI centric application such as Oracle.</p>
<pre>sudo cp ~/.Xauthority ~oracle/</pre>
<pre>sudo /bin/chown oracle ~oracle/.Xauthority</pre>
<pre>sudo su - oracle</pre>
<pre>./runInstaller</pre>
<p>Enjoy!</p>
<h1>Gotchas</h1>
<p>When installing or configuring an application, like those from Oracle, keep in mind that a break in your internet connection or other problems with your link may cause the remote program to be closed! &nbsp;So while it may be tempting to let an X11 process run overnight, you may have better results sticking around until the process completes. &nbsp;If your installer/application stops to ask you a question and your link does fail, you will likely lose all the work completed to that point and have to start all over again. &nbsp;Save early, save often, as they say.</p>
<h1>Conclusion</h1>
<p>If this was helpful, please drop us a line at info at redwireservices.com,&nbsp;<a title="Red Wire Services on Twitter" href="https://www.redwireservices.com/wp-content/uploads/2011/08/RedWireServices1" target="_blank" rel="noopener noreferrer">@RedWireServices</a>&nbsp;on Twitter, or using the&nbsp;<a title="Contact" href="https://www.redwireservices.com/contact" target="_blank" rel="noopener noreferrer">contact</a>&nbsp;page. &nbsp;If you have additional tips to add, please add a comment below and I will update the post accordingly to help as many as possible.</p>
<p>Finally, if you or your company are in need of&nbsp;<a title="Data Protection Service Plans" href="https://www.redwireservices.com/services">IT disaster recovery planning</a>,&nbsp;<a title="Data Protection Service Plans" href="https://www.redwireservices.com/services">backup system&nbsp;assistance</a>,&nbsp;<a title="Consulting" href="https://www.redwireservices.com/consulting">storage</a>, or&nbsp;<a title="Consulting" href="https://www.redwireservices.com/consulting">archival&nbsp;help</a>, give us a ring at&nbsp;<strong>(206) 829-8621</strong>.</p>
