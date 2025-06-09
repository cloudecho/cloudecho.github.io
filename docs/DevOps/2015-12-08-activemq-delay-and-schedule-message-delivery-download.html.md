---
layout: post
status: publish
published: true
title: ActiveMQ Delay and Schedule Message Delivery


date: '2015-12-08 20:26:47 +0800'
date_gmt: '2015-12-08 12:26:47 +0800'
categories:
- Opensource
tags:
- activemq
- jms
comments: []
---
<p>ActiveMQ from version <strong>5.4</strong> has an optional persistent scheduler built into the ActiveMQ message broker. It is enabled by setting the broker <strong>schedulerSupport</strong> attribute to true in the <a href="http://activemq.apache.org/xml-configuration.html" shape="rect">Xml Configuration</a>. <br clear="none" />An ActiveMQ client can take advantage of a delayed delivery by using the following message properties:</p>
<div class="confluence-information-macro confluence-information-macro-note">
<p class="title">Check your Message Properties</p>
<div class="confluence-information-macro-body">
<p>The message property <code>scheduledJobId&nbsp;</code>is reserved for use by the Job Scheduler. If this property is set before sending, the message will be sent immediately and not scheduled. Also, after a scheduled message is received, the property<code>scheduledJobId</code>&nbsp;will be set on the received message so keep this in mind if using something like a Camel Route which might automatically copy properties over when re-sending a message.</p>
</div>
</div>
<div class="table-wrap">
<table class="confluenceTable">
<tbody>
<tr>
<th class="confluenceTh" colspan="1" rowspan="1">Property name</th>
<th class="confluenceTh" colspan="1" rowspan="1">type</th>
<th class="confluenceTh" colspan="1" rowspan="1">description</th>
</tr>
<tr>
<td class="confluenceTd" colspan="1" rowspan="1">AMQ_SCHEDULED_DELAY</td>
<td class="confluenceTd" colspan="1" rowspan="1">long</td>
<td class="confluenceTd" colspan="1" rowspan="1">The time in milliseconds that a message will wait before being scheduled to be delivered by the broker</td>
</tr>
<tr>
<td class="confluenceTd" colspan="1" rowspan="1">AMQ_SCHEDULED_PERIOD</td>
<td class="confluenceTd" colspan="1" rowspan="1">long</td>
<td class="confluenceTd" colspan="1" rowspan="1">The time in milliseconds to wait after the start time to wait before scheduling the message again</td>
</tr>
<tr>
<td class="confluenceTd" colspan="1" rowspan="1">AMQ_SCHEDULED_REPEAT</td>
<td class="confluenceTd" colspan="1" rowspan="1">int</td>
<td class="confluenceTd" colspan="1" rowspan="1">The number of times to repeat scheduling a message for delivery</td>
</tr>
<tr>
<td class="confluenceTd" colspan="1" rowspan="1">AMQ_SCHEDULED_CRON</td>
<td class="confluenceTd" colspan="1" rowspan="1">String</td>
<td class="confluenceTd" colspan="1" rowspan="1">Use a Cron entry to set the schedule</td>
</tr>
</tbody>
</table>
</div>
<p>For the connivence of Java JMS clients - there's an interface with the property names used for scheduling at<em><strong>org.apache.activemq.ScheduledMessage</strong></em>.</p>
<p>For example, to have a message scheduled for delivery in 60 seconds - you would need to set the <em>AMQ_SCHEDULED_DELAY</em>property:</p>
<div class="code panel pdl">
<div class="codeContent panelContent pdl">
<div>
<div id="highlighter_811780" class="syntaxhighlighter nogutter java">
<table border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td class="code">
<div class="container">
<div class="line number1 index0 alt2"><code class="java plain">MessageProducer producer = session.createProducer(destination);</code></div>
<div class="line number2 index1 alt1"><code class="java plain">TextMessage message = session.createTextMessage(</code><code class="java string">"test msg"</code><code class="java plain">);</code></div>
<div class="line number3 index2 alt2"><code class="java keyword">long</code> <code class="java plain">time = </code><code class="java value">60</code> <code class="java plain">* </code><code class="java value">1000</code><code class="java plain">;</code></div>
<div class="line number4 index3 alt1"><code class="java plain">message.setLongProperty(ScheduledMessage.AMQ_SCHEDULED_DELAY, time);</code></div>
<div class="line number5 index4 alt2"><code class="java plain">producer.send(message);</code></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
</div>
<p>You can set a message to wait with an initial delay, and the repeat delivery 10 times, waiting 10 seconds between each re-delivery:</p>
<div class="code panel pdl">
<div class="codeContent panelContent pdl">
<div>
<div id="highlighter_296074" class="syntaxhighlighter nogutter java">
<table border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td class="code">
<div class="container">
<div class="line number1 index0 alt2"><code class="java plain">MessageProducer producer = session.createProducer(destination);</code></div>
<div class="line number2 index1 alt1"><code class="java plain">TextMessage message = session.createTextMessage(</code><code class="java string">"test msg"</code><code class="java plain">);</code></div>
<div class="line number3 index2 alt2"><code class="java keyword">long</code> <code class="java plain">delay = </code><code class="java value">30</code> <code class="java plain">* </code><code class="java value">1000</code><code class="java plain">;</code></div>
<div class="line number4 index3 alt1"><code class="java keyword">long</code> <code class="java plain">period = </code><code class="java value">10</code> <code class="java plain">* </code><code class="java value">1000</code><code class="java plain">;</code></div>
<div class="line number5 index4 alt2"><code class="java keyword">int</code> <code class="java plain">repeat = </code><code class="java value">9</code><code class="java plain">;</code></div>
<div class="line number6 index5 alt1"><code class="java plain">message.setLongProperty(ScheduledMessage.AMQ_SCHEDULED_DELAY, delay);</code></div>
<div class="line number7 index6 alt2"><code class="java plain">message.setLongProperty(ScheduledMessage.AMQ_SCHEDULED_PERIOD, period);</code></div>
<div class="line number8 index7 alt1"><code class="java plain">message.setIntProperty(ScheduledMessage.AMQ_SCHEDULED_REPEAT, repeat);</code></div>
<div class="line number9 index8 alt2"><code class="java plain">producer.send(message);</code></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
</div>
<p>You can also use <a class="external-link" href="http://en.wikipedia.org/wiki/Cron" rel="nofollow" shape="rect">CRON</a> to schedule a message, for example, if you want a message scheduled to be delivered every hour, you would need to set the CRON entry to be - <em>0 * * * *</em> - e.g.</p>
<div class="code panel pdl">
<div class="codeContent panelContent pdl">
<div>
<div id="highlighter_298439" class="syntaxhighlighter nogutter java">
<table border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td class="code">
<div class="container">
<div class="line number1 index0 alt2"><code class="java plain">MessageProducer producer = session.createProducer(destination);</code></div>
<div class="line number2 index1 alt1"><code class="java plain">TextMessage message = session.createTextMessage(</code><code class="java string">"test msg"</code><code class="java plain">);</code></div>
<div class="line number3 index2 alt2"><code class="java plain">message.setStringProperty(ScheduledMessage.AMQ_SCHEDULED_CRON, </code><code class="java string">"0 * * * *"</code><code class="java plain">);</code></div>
<div class="line number4 index3 alt1"><code class="java plain">producer.send(message);</code></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
</div>
<p>CRON scheduling takes priority over using message delay - however, if a repeat and period is set with a CRON entry, the ActiveMQ scheduler will schedule delivery of the message for every time the CRON entry fires. Easier to explain with an example. Supposing that you want a message to be delivered 10 times, with a one second delay between each message - and you wanted this to happen every hour - you'd do this:</p>
<div class="code panel pdl">
<div class="codeContent panelContent pdl">
<div id="highlighter_799533" class="syntaxhighlighter nogutter java">
<table border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td class="code">
<div class="container">
<div class="line number1 index0 alt2"><code class="java plain">MessageProducer producer = session.createProducer(destination);</code></div>
<div class="line number2 index1 alt1"><code class="java plain">TextMessage message = session.createTextMessage(</code><code class="java string">"test msg"</code><code class="java plain">);</code></div>
<div class="line number3 index2 alt2"><code class="java plain">message.setStringProperty(ScheduledMessage.AMQ_SCHEDULED_CRON, </code><code class="java string">"0 * * * *"</code><code class="java plain">);</code></div>
<div class="line number4 index3 alt1"><code class="java plain">message.setLongProperty(ScheduledMessage.AMQ_SCHEDULED_DELAY, </code><code class="java value">1000</code><code class="java plain">);</code></div>
<div class="line number5 index4 alt2"><code class="java plain">message.setLongProperty(ScheduledMessage.AMQ_SCHEDULED_PERIOD, </code><code class="java value">1000</code><code class="java plain">);</code></div>
<div class="line number6 index5 alt1"><code class="java plain">message.setIntProperty(ScheduledMessage.AMQ_SCHEDULED_REPEAT, </code><code class="java value">9</code><code class="java plain">);</code></div>
<div class="line number7 index6 alt2"><code class="java plain">producer.send(message);</code></div>
</div>
</td>
</tr>
</tbody>
</table>
<p>摘自『http://activemq.apache.org/delay-and-schedule-message-delivery.html』</p>
</div>
</div>
</div>
