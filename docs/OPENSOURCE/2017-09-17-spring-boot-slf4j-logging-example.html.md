---
layout: post
status: publish
published: true
title: Spring Boot SLF4J Logging example


date: '2017-09-17 10:04:49 +0800'
date_gmt: '2017-09-17 02:04:49 +0800'
categories:
- Opensource
tags:
- springboot
- logging
- logback
- log4j
comments: []
---
<h1></h1>
<div class="post-meta">
<p class="post-meta">By&nbsp;<a title="mkyong" href="https://www.mkyong.com/author/mkyong/" rel="author">mkyong</a>&nbsp;|&nbsp;<time datetime="2017-01-04T18:05:37+00:00">January 4, 2017</time>&nbsp;| Updated : April 17, 2017 | Viewed : 0 times&nbsp;+-57,224 pv/w</p>
</div>
<div class="post-content">
<div class="pic"><img src="http://www.mkyong.com/wp-content/uploads/2017/01/spring-boot-slf4j-logging-example.png" alt="spring-boot-slf4j-logging-example" /></div>
<p>By default, the SLF4j Logging is included in the Spring Boot starter package.</p>
<div class="filename">application.properties</div>
<pre class=" language-bash"><code class=" language-bash">spring-boot-web-project$ mvn dependency:tree

+<span class="token punctuation">..</span>.
+- org.springframework.boot:spring-boot-starter-logging:jar:1.4.2.RELEASE:compile
<span class="token punctuation">[</span>INFO<span class="token punctuation">]</span> <span class="token operator">|</span>  <span class="token operator">|</span>  <span class="token operator">|</span>  +- ch.qos.logback:logback-classic:jar:1.1.7:compile
<span class="token punctuation">[</span>INFO<span class="token punctuation">]</span> <span class="token operator">|</span>  <span class="token operator">|</span>  <span class="token operator">|</span>  <span class="token operator">|</span>  \- ch.qos.logback:logback-core:jar:1.1.7:compile
<span class="token punctuation">[</span>INFO<span class="token punctuation">]</span> <span class="token operator">|</span>  <span class="token operator">|</span>  <span class="token operator">|</span>  +- org.slf4j:jcl-over-slf4j:jar:1.7.21:compile
<span class="token punctuation">[</span>INFO<span class="token punctuation">]</span> <span class="token operator">|</span>  <span class="token operator">|</span>  <span class="token operator">|</span>  +- org.slf4j:jul-to-slf4j:jar:1.7.21:compile
<span class="token punctuation">[</span>INFO<span class="token punctuation">]</span> <span class="token operator">|</span>  <span class="token operator">|</span>  <span class="token operator">|</span>  \- org.slf4j:log4j-over-slf4j:jar:1.7.21:compile
+<span class="token punctuation">..</span>.</code></pre>
<div class="note"><strong>Note</strong><br />
Review this&nbsp;<a href="https://github.com/spring-projects/spring-boot/tree/master/spring-boot/src/main/resources/org/springframework/boot/logging/logback" target="_blank" rel="noopener noreferrer">Spring Boot Logback XML template</a>&nbsp;to understand the default logging pattern and configuration.</div>
<h2>1. application.properties</h2>
<p>To enable logging, create a&nbsp;<code>application.properties</code>&nbsp;file in the root of the&nbsp;<code>resources</code>&nbsp;folder.</p>
<p>1.1&nbsp;<code>logging.level</code>&nbsp;&ndash; define logging level, the logging will be output to console.</p>
<div class="filename">application.properties</div>
<pre class=" language-bash"><code class=" language-bash">logging.level.org.springframework.web<span class="token operator">=</span>ERROR
logging.level.com.mkyong<span class="token operator">=</span>DEBUG</code></pre>
<p>1.2&nbsp;<code>logging.file</code>&nbsp;&ndash; define logging file, the logging will be output to a file and console.</p>
<div class="filename">application.properties</div>
<pre class=" language-bash"><code class=" language-bash">logging.level.org.springframework.web<span class="token operator">=</span>ERROR
logging.level.com.mkyong<span class="token operator">=</span>DEBUG

<span class="token comment" spellcheck="true">#output to a temp_folder/file</span>
logging.file<span class="token operator">=</span><span class="token variable">${java.io.tmpdir}</span>/application.log

<span class="token comment" spellcheck="true">#output to a file</span>
<span class="token comment" spellcheck="true">#logging.file=/Users/mkyong/application.log</span></code></pre>
<p>1.3&nbsp;<code>logging.pattern</code>&nbsp;&ndash; define a custom logging pattern.</p>
<div class="filename">application.properties</div>
<pre class=" language-bash"><code class=" language-bash">logging.level.org.springframework.web<span class="token operator">=</span>ERROR
logging.level.com.mkyong<span class="token operator">=</span>DEBUG

<span class="token comment" spellcheck="true"># Logging pattern for the console</span>
logging.pattern.console<span class="token operator">=</span> <span class="token string">"%d{yyyy-MM-dd HH:mm:ss} - %msg%n"</span>

<span class="token comment" spellcheck="true"># Logging pattern for file</span>
logging.pattern.file<span class="token operator">=</span> <span class="token string">"%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n"</span>

logging.file<span class="token operator">=</span>/Users/mkyong/application.log</code></pre>
<h2>2. application.yml</h2>
<p>This is the equivalent in YAML format.</p>
<div class="filename">application.yml</div>
<pre class=" language-bash"><code class=" language-bash">logging:
  level:
    org.springframework.web: ERROR
    com.mkyong: DEBUG
  pattern:
    console: <span class="token string">"%d{yyyy-MM-dd HH:mm:ss} - %msg%n"</span>
    file: <span class="token string">"%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n"</span>
  file: /Users/mkyong/application.log</code></pre>
<h2>3. Classic Logback.xml</h2>
<p>If you don&rsquo;t like the Spring Boot logging template, just create a standard&nbsp;<code>logback.xml</code>&nbsp;in the root of the&nbsp;<code>resources</code>folder or root of the classpath. This will override the Spring Boot logging template.</p>
<div class="filename">logback.xml</div>
<pre class=" language-markup"><code class=" language-markup"><span class="token prolog"><?xml version="1.0" encoding="UTF-8"?></span>
<span class="token tag"><span class="token punctuation"><</span>configuration<span class="token punctuation">></span></span>

	<span class="token tag"><span class="token punctuation"><</span>property <span class="token attr-name">name</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>DEV_HOME<span class="token punctuation">"</span></span> <span class="token attr-name">value</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>c:/logs<span class="token punctuation">"</span></span> <span class="token punctuation">/></span></span>

	<span class="token tag"><span class="token punctuation"><</span>appender <span class="token attr-name">name</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>FILE-AUDIT<span class="token punctuation">"</span></span>
		<span class="token attr-name">class</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>ch.qos.logback.core.rolling.RollingFileAppender<span class="token punctuation">"</span></span><span class="token punctuation">></span></span>
		<span class="token tag"><span class="token punctuation"><</span>file<span class="token punctuation">></span></span>${DEV_HOME}/debug.log<span class="token tag"><span class="token punctuation"></</span>file<span class="token punctuation">></span></span>
		<span class="token tag"><span class="token punctuation"><</span>encoder <span class="token attr-name">class</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>ch.qos.logback.classic.encoder.PatternLayoutEncoder<span class="token punctuation">"</span></span><span class="token punctuation">></span></span>
			<span class="token tag"><span class="token punctuation"><</span>Pattern<span class="token punctuation">></span></span>
				%d{yyyy-MM-dd HH:mm:ss} - %msg%n
			<span class="token tag"><span class="token punctuation"></</span>Pattern<span class="token punctuation">></span></span>
		<span class="token tag"><span class="token punctuation"></</span>encoder<span class="token punctuation">></span></span>

		<span class="token tag"><span class="token punctuation"><</span>rollingPolicy <span class="token attr-name">class</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>ch.qos.logback.core.rolling.TimeBasedRollingPolicy<span class="token punctuation">"</span></span><span class="token punctuation">></span></span>
			<span class="token comment" spellcheck="true"><!-- rollover daily --></span>
			<span class="token tag"><span class="token punctuation"><</span>fileNamePattern<span class="token punctuation">></span></span>${DEV_HOME}/archived/debug.%d{yyyy-MM-dd}.%i.log
                        <span class="token tag"><span class="token punctuation"></</span>fileNamePattern<span class="token punctuation">></span></span>
			<span class="token tag"><span class="token punctuation"><</span>timeBasedFileNamingAndTriggeringPolicy
				<span class="token attr-name">class</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP<span class="token punctuation">"</span></span><span class="token punctuation">></span></span>
				<span class="token tag"><span class="token punctuation"><</span>maxFileSize<span class="token punctuation">></span></span>10MB<span class="token tag"><span class="token punctuation"></</span>maxFileSize<span class="token punctuation">></span></span>
			<span class="token tag"><span class="token punctuation"></</span>timeBasedFileNamingAndTriggeringPolicy<span class="token punctuation">></span></span>
		<span class="token tag"><span class="token punctuation"></</span>rollingPolicy<span class="token punctuation">></span></span>

	<span class="token tag"><span class="token punctuation"></</span>appender<span class="token punctuation">></span></span>

	<span class="token tag"><span class="token punctuation"><</span>logger <span class="token attr-name">name</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>com.mkyong<span class="token punctuation">"</span></span> <span class="token attr-name">level</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>debug<span class="token punctuation">"</span></span>
		<span class="token attr-name">additivity</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>false<span class="token punctuation">"</span></span><span class="token punctuation">></span></span>
		<span class="token tag"><span class="token punctuation"><</span>appender-ref <span class="token attr-name">ref</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>FILE-AUDIT<span class="token punctuation">"</span></span> <span class="token punctuation">/></span></span>
	<span class="token tag"><span class="token punctuation"></</span>logger<span class="token punctuation">></span></span>

	<span class="token tag"><span class="token punctuation"><</span>root <span class="token attr-name">level</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>error<span class="token punctuation">"</span></span><span class="token punctuation">></span></span>
		<span class="token tag"><span class="token punctuation"><</span>appender-ref <span class="token attr-name">ref</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>FILE-AUDIT<span class="token punctuation">"</span></span> <span class="token punctuation">/></span></span>
	<span class="token tag"><span class="token punctuation"></</span>root<span class="token punctuation">></span></span>

<span class="token tag"><span class="token punctuation"></</span>configuration<span class="token punctuation">></span></span></code></pre>
<h2>4. Spring Boot logging by Profile</h2>
<div class="note"><strong>Note</strong><br />
Read this article &ndash;&nbsp;<a href="https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-logging.html#_profile_specific_configuration" target="_blank" rel="noopener noreferrer">Profile-specific configuration</a></div>
<p>Create a&nbsp;<code>logback-spring.xml</code>&nbsp;in the root of the classpath, to take advantage of the&nbsp;<a href="https://docs.spring.io/spring-boot/docs/current/reference/html/howto-logging.html#howto-configure-logback-for-logging" target="_blank" rel="noopener noreferrer">templating features</a>&nbsp;provided by Spring Boot.</p>
<p>In below example :</p>
<ol>
<li>If the profile is&nbsp;<code>dev</code>, logs to console and a rolling file.</li>
<li>If the profile is&nbsp;<code>prod</code>, logs to a rolling file only.</li>
</ol>
<div class="filename">logback-spring.xml</div>
<pre class=" language-markup"><code class=" language-markup"><span class="token prolog"><?xml version="1.0" encoding="UTF-8"?></span>
<span class="token tag"><span class="token punctuation"><</span>configuration<span class="token punctuation">></span></span>
    <span class="token tag"><span class="token punctuation"><</span>include <span class="token attr-name">resource</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>org/springframework/boot/logging/logback/defaults.xml<span class="token punctuation">"</span></span><span class="token punctuation">/></span></span>
    <span class="token tag"><span class="token punctuation"><</span>property <span class="token attr-name">name</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>LOG_FILE<span class="token punctuation">"</span></span> <span class="token attr-name">value</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>${LOG_FILE:-${LOG_PATH:-${LOG_TEMP:-${java.io.tmpdir:-/tmp}}/}spring.log}<span class="token punctuation">"</span></span><span class="token punctuation">/></span></span>

    <span class="token tag"><span class="token punctuation"><</span>springProfile <span class="token attr-name">name</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>dev<span class="token punctuation">"</span></span><span class="token punctuation">></span></span>
        <span class="token tag"><span class="token punctuation"><</span>include <span class="token attr-name">resource</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>org/springframework/boot/logging/logback/console-appender.xml<span class="token punctuation">"</span></span><span class="token punctuation">/></span></span>
        <span class="token tag"><span class="token punctuation"><</span>appender <span class="token attr-name">name</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>ROLLING-FILE<span class="token punctuation">"</span></span>
                  <span class="token attr-name">class</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>ch.qos.logback.core.rolling.RollingFileAppender<span class="token punctuation">"</span></span><span class="token punctuation">></span></span>
            <span class="token tag"><span class="token punctuation"><</span>encoder<span class="token punctuation">></span></span>
                <span class="token tag"><span class="token punctuation"><</span>pattern<span class="token punctuation">></span></span>${FILE_LOG_PATTERN}<span class="token tag"><span class="token punctuation"></</span>pattern<span class="token punctuation">></span></span>
            <span class="token tag"><span class="token punctuation"></</span>encoder<span class="token punctuation">></span></span>
            <span class="token tag"><span class="token punctuation"><</span>file<span class="token punctuation">></span></span>${LOG_FILE}<span class="token tag"><span class="token punctuation"></</span>file<span class="token punctuation">></span></span>
            <span class="token tag"><span class="token punctuation"><</span>rollingPolicy <span class="token attr-name">class</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>ch.qos.logback.core.rolling.TimeBasedRollingPolicy<span class="token punctuation">"</span></span><span class="token punctuation">></span></span>
                <span class="token tag"><span class="token punctuation"><</span>fileNamePattern<span class="token punctuation">></span></span>${LOG_FILE}.%d{yyyy-MM-dd}.log<span class="token tag"><span class="token punctuation"></</span>fileNamePattern<span class="token punctuation">></span></span>
            <span class="token tag"><span class="token punctuation"></</span>rollingPolicy<span class="token punctuation">></span></span>
        <span class="token tag"><span class="token punctuation"></</span>appender<span class="token punctuation">></span></span>
        <span class="token tag"><span class="token punctuation"><</span>root <span class="token attr-name">level</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>ERROR<span class="token punctuation">"</span></span><span class="token punctuation">></span></span>
            <span class="token tag"><span class="token punctuation"><</span>appender-ref <span class="token attr-name">ref</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>CONSOLE<span class="token punctuation">"</span></span><span class="token punctuation">/></span></span>
            <span class="token tag"><span class="token punctuation"><</span>appender-ref <span class="token attr-name">ref</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>ROLLING-FILE<span class="token punctuation">"</span></span><span class="token punctuation">/></span></span>
        <span class="token tag"><span class="token punctuation"></</span>root<span class="token punctuation">></span></span>
    <span class="token tag"><span class="token punctuation"></</span>springProfile<span class="token punctuation">></span></span>

    <span class="token tag"><span class="token punctuation"><</span>springProfile <span class="token attr-name">name</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>prod<span class="token punctuation">"</span></span><span class="token punctuation">></span></span>
        <span class="token tag"><span class="token punctuation"><</span>appender <span class="token attr-name">name</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>ROLLING-FILE<span class="token punctuation">"</span></span>
                  <span class="token attr-name">class</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>ch.qos.logback.core.rolling.RollingFileAppender<span class="token punctuation">"</span></span><span class="token punctuation">></span></span>
            <span class="token tag"><span class="token punctuation"><</span>encoder<span class="token punctuation">></span></span>
                <span class="token tag"><span class="token punctuation"><</span>pattern<span class="token punctuation">></span></span>${FILE_LOG_PATTERN}<span class="token tag"><span class="token punctuation"></</span>pattern<span class="token punctuation">></span></span>
            <span class="token tag"><span class="token punctuation"></</span>encoder<span class="token punctuation">></span></span>
            <span class="token tag"><span class="token punctuation"><</span>file<span class="token punctuation">></span></span>${LOG_FILE}<span class="token tag"><span class="token punctuation"></</span>file<span class="token punctuation">></span></span>
            <span class="token tag"><span class="token punctuation"><</span>rollingPolicy <span class="token attr-name">class</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>ch.qos.logback.core.rolling.TimeBasedRollingPolicy<span class="token punctuation">"</span></span><span class="token punctuation">></span></span>
                <span class="token tag"><span class="token punctuation"><</span>fileNamePattern<span class="token punctuation">></span></span>${LOG_FILE}.%d{yyyy-MM-dd}.%i.gz<span class="token tag"><span class="token punctuation"></</span>fileNamePattern<span class="token punctuation">></span></span>
                <span class="token tag"><span class="token punctuation"><</span>timeBasedFileNamingAndTriggeringPolicy
                        <span class="token attr-name">class</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP<span class="token punctuation">"</span></span><span class="token punctuation">></span></span>
                    <span class="token tag"><span class="token punctuation"><</span>maxFileSize<span class="token punctuation">></span></span>10MB<span class="token tag"><span class="token punctuation"></</span>maxFileSize<span class="token punctuation">></span></span>
                <span class="token tag"><span class="token punctuation"></</span>timeBasedFileNamingAndTriggeringPolicy<span class="token punctuation">></span></span>
            <span class="token tag"><span class="token punctuation"></</span>rollingPolicy<span class="token punctuation">></span></span>
        <span class="token tag"><span class="token punctuation"></</span>appender<span class="token punctuation">></span></span>

        <span class="token tag"><span class="token punctuation"><</span>root <span class="token attr-name">level</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>ERROR<span class="token punctuation">"</span></span><span class="token punctuation">></span></span>
            <span class="token tag"><span class="token punctuation"><</span>appender-ref <span class="token attr-name">ref</span><span class="token attr-value"><span class="token punctuation">=</span><span class="token punctuation">"</span>ROLLING-FILE<span class="token punctuation">"</span></span><span class="token punctuation">/></span></span>
        <span class="token tag"><span class="token punctuation"></</span>root<span class="token punctuation">></span></span>
    <span class="token tag"><span class="token punctuation"></</span>springProfile<span class="token punctuation">></span></span>

<span class="token tag"><span class="token punctuation"></</span>configuration<span class="token punctuation">></span></span></code></pre>
<div class="filename">application.yml</div>
<pre class=" language-bash"><code class=" language-bash">spring:
  profiles:
    active: prod

logging:
  level:
    ROOT: ERROR
    org.springframework: ERROR
    org.springframework.data: ERROR
    com.mkyong: INFO
    org.mongodb: ERROR
  file: /Users/mkyong/application.log</code></pre>
<p>For non-web boot app, you can override the log file output like this :</p>
<div class="filename">Console</div>
<pre class=" language-bash"><code class=" language-bash">$ java -Dlogging.file<span class="token operator">=</span>/home/mkyong/app/logs/app.log -jar boot-app.jar</code></pre>
<h2>5. Set Root Level</h2>
<div class="filename">application.properties</div>
<pre class=" language-bash"><code class=" language-bash"><span class="token comment" spellcheck="true"># root logging level, warning : too much output</span>
logging.level.<span class="token operator">=</span>DEBUG</code></pre>
<div class="filename">application.yml</div>
<pre class=" language-bash"><code class=" language-bash">logging:
  level:
    ROOT: DEBUG</code></pre>
<h2>Download Source Code</h2>
<div class="download">Download It &ndash;&nbsp;<a href="http://www.mkyong.com/wp-content/uploads/2017/01/spring-boot-web-slf4j-logging.zip">spring-boot-web-slf4j-logging.zip</a>&nbsp;(16 KB)</div>
<h2>References</h2>
<ol>
<li><a href="https://docs.spring.io/spring-boot/docs/current/reference/html/howto-logging.html" target="_blank" rel="noopener noreferrer">Spring Boot &ndash; How to Logging</a></li>
<li><a href="https://github.com/spring-projects/spring-boot/tree/master/spring-boot/src/main/resources/org/springframework/boot/logging/logback" target="_blank" rel="noopener noreferrer">Spring Boot Logback XML template</a></li>
<li><a href="http://stackoverflow.com/questions/20485059/spring-boot-how-can-i-set-the-logging-level-with-application-properties" target="_blank" rel="noopener noreferrer">Spring Boot: How can I set the logging level with application.properties?</a></li>
<li><a href="https://www.mkyong.com/logging/logback-xml-example/" target="_blank" rel="noopener noreferrer">logback.xml Examples</a></li>
<li><a href="http://logback.qos.ch/" target="_blank" rel="noopener noreferrer">Logback Home</a></li>
</ol>
</div>
<p>&nbsp;</p>
<p>Source: https://www.mkyong.com/spring-boot/spring-boot-slf4j-logging-example/</p>
