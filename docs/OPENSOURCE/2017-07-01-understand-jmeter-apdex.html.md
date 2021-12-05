---
layout: post
status: publish
published: true
title: Understand JMeter APDEX


date: '2017-07-01 10:16:38 +0800'
date_gmt: '2017-07-01 02:16:38 +0800'
categories:
- Opensource
tags:
- jmeter
- APDEX
- performance
- test
- threshold
comments: []
---
## 1. Concept

APDEX is explained here

To compute it JMeter needs 2 values:
- Satisfied count
- Tolerating count

Satisfied count is the Number of requests for which response time is lower than "Toleration threshold"

Tolerating count is the Number of requests for which response time is higher than Toleration threshold but lower than "Frustration threshold"

So JMeter let's you customize those 2 values as it depends on your SLR/SLA.

> APDEX = (SatisfiedCount + ToleratingCount / 2) / TotalSamples

## 2. How to set APDEX thresholds 

### bin/user.properties

```sh
$ pwd
/Users/echo/apps/jmeter-3.2
$ cat bin/user.properties | grep threshold
# Change this parameter if you want to override the APDEX satisfaction threshold.
#jmeter.reportgenerator.apdex_satisfied_threshold=500
# Change this parameter if you want to override the APDEX tolerance threshold.
#jmeter.reportgenerator.apdex_tolerated_threshold=1500
```

### command line

For exampe:
```sh
CASE=testcast1 && ./bin/jmeter -n -t "testcase/$CASE.jmx" -l "output/$CASE.log"  -o "output/$CASE" -e -Jjmeter.reportgenerator.apdex_satisfied_threshold=400 -Jjmeter.reportgenerator.apdex_tolerated_threshold=1200
```

## References
* http://jmeter.apache.org/usermanual/generating-dashboard.html
* https://en.wikipedia.org/wiki/Apdex
* https://stackoverflow.com/questions/39696457/can-anyone-help-me-to-understand-the-terms-toleration-threshold-and-frustrati