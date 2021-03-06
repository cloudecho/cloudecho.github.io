---
layout: post
status: publish
published: true
title: Filter and rename resources with Maven


date: '2017-09-21 20:40:10 +0800'
date_gmt: '2017-09-21 12:40:10 +0800'
categories:
- Opensource
tags:
- maven
comments: []
---
<p><strong>Source</strong>:&nbsp;http://roufid.com/filter-and-rename-resources-with-maven/&nbsp;17 DEC, 2016</p>
<div class="post-inner">
<div class="post-content pad">
<div class="entry">
<p>If you want to filter and copy your project resources to the output directory, the&nbsp;<strong><a href="https://maven.apache.org/plugins/maven-resources-plugin/" target="_blank" rel="noopener noreferrer">Apache Maven Resources Plugin</a></strong>&nbsp;is the best plugin to perform that. But sometimes you want to filter and&nbsp;<em>rename</em>resources&nbsp;with Maven and the last version of the&nbsp;<span id="crayon-59c3b2c0cd19d981025343" class="crayon-syntax crayon-syntax-inline  crayon-theme-familiar crayon-theme-familiar-inline crayon-font-consolas"><span class="crayon-pre crayon-code"><span class="crayon-e">Maven&nbsp;</span><span class="crayon-e">Resources&nbsp;</span><span class="crayon-v">Plugin</span></span></span>&nbsp;(current 3.0.1) does not provide a direct way to do that.</p>
<p>This tutorial will show a workaround to filter and rename resources with Maven.</p>
<h1><strong>Project example</strong></h1>
<p>Let&rsquo;s consider a file&nbsp;<span id="crayon-59c3b2c0cd1a4895029620" class="crayon-syntax crayon-syntax-inline  crayon-theme-familiar crayon-theme-familiar-inline crayon-font-consolas"><span class="crayon-pre crayon-code"><span class="crayon-v">file</span><span class="crayon-o">-</span><span class="crayon-st">to</span><span class="crayon-o">-</span><span class="crayon-v">rename</span><span class="crayon-sy">.</span><span class="crayon-v">txt</span></span></span>&nbsp;located under&nbsp;<span id="crayon-59c3b2c0cd1a6283134192" class="crayon-syntax crayon-syntax-inline  crayon-theme-familiar crayon-theme-familiar-inline crayon-font-consolas"><span class="crayon-pre crayon-code"><span class="crayon-v">src</span><span class="crayon-o">/</span><span class="crayon-v">main</span><span class="crayon-o">/</span></span></span>&nbsp;which &nbsp;we want to filter and rename to&nbsp;<span id="crayon-59c3b2c0cd1a8496658482" class="crayon-syntax crayon-syntax-inline  crayon-theme-familiar crayon-theme-familiar-inline crayon-font-consolas"><span class="crayon-pre crayon-code"><span class="crayon-v">renamed</span><span class="crayon-o">-</span><span class="crayon-v">file</span><span class="crayon-sy">.</span><span class="crayon-v">txt</span></span></span>.</p>
<p>Below the project structure :</p>
<div id="attachment_1289" class="wp-caption aligncenter"><a href="http://roufid.com/wp-content/uploads/2016/12/1_project_structure.png" rel="lightbox[1288]"><img class="size-full wp-image-1289" src="http://roufid.com/wp-content/uploads/2016/12/1_project_structure.png" sizes="(max-width: 331px) 100vw, 331px" srcset="http://roufid.com/wp-content/uploads/2016/12/1_project_structure.png 331w, http://roufid.com/wp-content/uploads/2016/12/1_project_structure-300x131.png 300w" alt="Maven project structure" width="331" height="144" /></a></p>
<p class="wp-caption-text">Maven project structure</p>
</div>
<p>The content of&nbsp;<span id="crayon-59c3b2c0cd1aa131926367" class="crayon-syntax crayon-syntax-inline  crayon-theme-familiar crayon-theme-familiar-inline crayon-font-consolas"><span class="crayon-pre crayon-code"><span class="crayon-v">file</span><span class="crayon-o">-</span><span class="crayon-st">to</span><span class="crayon-o">-</span><span class="crayon-v">rename</span><span class="crayon-sy">.</span><span class="crayon-v">txt</span></span></span>&nbsp;:</p>
<div id="crayon-59c3b2c0cd1ab771528496" class="crayon-syntax crayon-theme-familiar crayon-font-consolas crayon-os-mac print-yes notranslate" data-settings=" no-popup minimize scroll-mouseover">
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ab771528496-1">1</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ab771528496-2">2</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ab771528496-3">3</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-59c3b2c0cd1ab771528496-1" class="crayon-line"><span class="crayon-v">firstname</span><span class="crayon-o">=</span><span class="crayon-sy">$</span><span class="crayon-sy">{</span><span class="crayon-v">user</span><span class="crayon-sy">.</span><span class="crayon-v">firstname</span><span class="crayon-sy">}</span></div>
<div id="crayon-59c3b2c0cd1ab771528496-2" class="crayon-line"><span class="crayon-v">lastname</span><span class="crayon-o">=</span><span class="crayon-sy">$</span><span class="crayon-sy">{</span><span class="crayon-v">user</span><span class="crayon-sy">.</span><span class="crayon-v">lastname</span><span class="crayon-sy">}</span></div>
<div id="crayon-59c3b2c0cd1ab771528496-3" class="crayon-line"><span class="crayon-v">date</span><span class="crayon-o">=</span><span class="crayon-sy">$</span><span class="crayon-sy">{</span><span class="crayon-v">maven</span><span class="crayon-sy">.</span><span class="crayon-v">build</span><span class="crayon-sy">.</span><span class="crayon-v">timestamp</span><span class="crayon-sy">}</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<p>Content of&nbsp;<span id="crayon-59c3b2c0cd1ac172469324" class="crayon-syntax crayon-syntax-inline  crayon-theme-familiar crayon-theme-familiar-inline crayon-font-consolas"><span class="crayon-pre crayon-code"><span class="crayon-v">pom</span><span class="crayon-sy">.</span><span class="crayon-v">xml</span></span></span>&nbsp;:</p>
<div id="crayon-59c3b2c0cd1ae672745455" class="crayon-syntax crayon-theme-familiar crayon-font-consolas crayon-os-mac print-yes notranslate" data-settings=" no-popup minimize scroll-mouseover">
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row alt">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-1">1</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-2">2</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-3">3</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-4">4</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-5">5</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-6">6</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-7">7</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-8">8</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-9">9</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-10">10</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-11">11</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-12">12</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-13">13</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-14">14</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-15">15</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-16">16</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-17">17</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-18">18</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-19">19</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-20">20</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-21">21</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-22">22</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-23">23</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-24">24</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-25">25</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-26">26</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-27">27</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-28">28</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-29">29</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-30">30</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-31">31</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-32">32</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-33">33</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-34">34</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-35">35</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-36">36</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-37">37</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-38">38</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-39">39</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-40">40</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-41">41</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-42">42</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-43">43</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-44">44</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-45">45</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-46">46</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-47">47</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-48">48</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-49">49</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-50">50</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-51">51</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-52">52</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-53">53</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-54">54</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-55">55</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-56">56</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-57">57</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-58">58</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-59">59</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-60">60</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-61">61</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-62">62</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-63">63</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-64">64</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-65">65</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-66">66</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1ae672745455-67">67</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-59c3b2c0cd1ae672745455-1" class="crayon-line"><span class="crayon-r ">
<project </span><span class="crayon-e ">xmlns</span><span class="crayon-o">=</span><span class="crayon-s ">"<a class="vglnk" href="http://maven.apache.org/POM/4.0.0" rel="nofollow">http://maven.apache.org/POM/4.0.0</a>"</span> xmlns<span class="crayon-o">:</span><span class="crayon-e ">xsi</span><span class="crayon-o">=</span><span class="crayon-s ">"<a class="vglnk" href="http://www.w3.org/2001/XMLSchema-instance" rel="nofollow">http://www.w3.org/2001/XMLSchema-instance</a>"</span></div>
<div id="crayon-59c3b2c0cd1ae672745455-2" class="crayon-line">xsi<span class="crayon-o">:</span><span class="crayon-e ">schemaLocation</span><span class="crayon-o">=</span><span class="crayon-s ">"<a class="vglnk" href="http://maven.apache.org/POM/4.0.0" rel="nofollow">http://maven.apache.org/POM/4.0.0</a> <a class="vglnk" href="http://maven.apache.org/xsd/maven-4.0.0.xsd" rel="nofollow">http://maven.apache.org/xsd/maven-4.0.0.xsd</a>"</span><span class="crayon-r ">></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-3" class="crayon-line"></div>
<div id="crayon-59c3b2c0cd1ae672745455-4" class="crayon-line"><span class="crayon-r "><modelVersion></span><span class="crayon-i ">4.0.0</span><span class="crayon-r "></modelVersion></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-5" class="crayon-line"></div>
<div id="crayon-59c3b2c0cd1ae672745455-6" class="crayon-line"><span class="crayon-r "><groupId></span><span class="crayon-i ">com.roufid.tutorial</span><span class="crayon-r "></groupId></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-7" class="crayon-line"><span class="crayon-r "><artifactId></span><span class="crayon-i ">filter-copy-rename-resource-tutorial</span><span class="crayon-r "></artifactId></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-8" class="crayon-line"><span class="crayon-r "><version></span><span class="crayon-i ">0.0.1-SNAPSHOT</span><span class="crayon-r "></version></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-9" class="crayon-line"></div>
<div id="crayon-59c3b2c0cd1ae672745455-10" class="crayon-line"><span class="crayon-r ">
<packaging></span><span class="crayon-i ">pom</span><span class="crayon-r "></packaging></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-11" class="crayon-line"><span class="crayon-r "><name></span><span class="crayon-i ">Filter, copy and rename resource tutorial</span><span class="crayon-r "></name></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-12" class="crayon-line"></div>
<div id="crayon-59c3b2c0cd1ae672745455-13" class="crayon-line"><span class="crayon-r ">
<properties></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-14" class="crayon-line"><span class="crayon-r "><user.firstname></span><span class="crayon-i ">Radouane</span><span class="crayon-r "></user.firstname></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-15" class="crayon-line"><span class="crayon-r "><user.lastname></span><span class="crayon-i ">ROUFID</span><span class="crayon-r "></user.lastname></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-16" class="crayon-line"><span class="crayon-r "></properties></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-17" class="crayon-line"></div>
<div id="crayon-59c3b2c0cd1ae672745455-18" class="crayon-line"><span class="crayon-r "><build></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-19" class="crayon-line"><span class="crayon-r ">
<plugins></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-20" class="crayon-line"><span class="crayon-r ">
<plugin></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-21" class="crayon-line"><span class="crayon-r "><groupId></span><span class="crayon-i ">org.apache.maven.plugins</span><span class="crayon-r "></groupId></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-22" class="crayon-line"><span class="crayon-r "><artifactId></span><span class="crayon-i ">maven-resources-plugin</span><span class="crayon-r "></artifactId></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-23" class="crayon-line"><span class="crayon-r "><version></span><span class="crayon-i ">3.0.1</span><span class="crayon-r "></version></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-24" class="crayon-line"><span class="crayon-r "><executions></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-25" class="crayon-line"><span class="crayon-r "><execution></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-26" class="crayon-line"><span class="crayon-r "><id></span><span class="crayon-i ">filter-resources</span><span class="crayon-r "></id></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-27" class="crayon-line"><span class="crayon-r ">
<phase></span><span class="crayon-i ">process-resources</span><span class="crayon-r "></phase></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-28" class="crayon-line"><span class="crayon-r "><goals></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-29" class="crayon-line"><span class="crayon-r "><goal></span><span class="crayon-i ">copy-resources</span><span class="crayon-r "></goal></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-30" class="crayon-line"><span class="crayon-r "></goals></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-31" class="crayon-line"><span class="crayon-r "><configuration></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-32" class="crayon-line"><span class="crayon-r "><outputDirectory></span><span class="crayon-i ">${project.build.directory}</span><span class="crayon-r "></outputDirectory></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-33" class="crayon-line"><span class="crayon-r "><resources></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-34" class="crayon-line"><span class="crayon-r "><resource></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-35" class="crayon-line"><span class="crayon-r "><filtering></span><span class="crayon-i ">true</span><span class="crayon-r "></filtering></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-36" class="crayon-line"><span class="crayon-r "><directory></span><span class="crayon-i ">${basedir}/src/main</span><span class="crayon-r "></directory></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-37" class="crayon-line"><span class="crayon-r "><include></span><span class="crayon-i ">**/*</span><span class="crayon-r "></include></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-38" class="crayon-line"><span class="crayon-r "></resource></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-39" class="crayon-line"><span class="crayon-r "></resources></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-40" class="crayon-line"><span class="crayon-r "></configuration></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-41" class="crayon-line"><span class="crayon-r "></execution></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-42" class="crayon-line"><span class="crayon-r "></executions></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-43" class="crayon-line"><span class="crayon-r "></plugin></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-44" class="crayon-line"></div>
<div id="crayon-59c3b2c0cd1ae672745455-45" class="crayon-line"><span class="crayon-r ">
<plugin></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-46" class="crayon-line"><span class="crayon-r "><groupId></span><span class="crayon-i ">com.coderplus.maven.plugins</span><span class="crayon-r "></groupId></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-47" class="crayon-line"><span class="crayon-r "><artifactId></span><span class="crayon-i ">copy-rename-maven-plugin</span><span class="crayon-r "></artifactId></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-48" class="crayon-line"><span class="crayon-r "><version></span><span class="crayon-i ">1.0</span><span class="crayon-r "></version></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-49" class="crayon-line"><span class="crayon-r "><executions></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-50" class="crayon-line"><span class="crayon-r "><execution></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-51" class="crayon-line"><span class="crayon-r "><id></span><span class="crayon-i ">copy-and-rename-file</span><span class="crayon-r "></id></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-52" class="crayon-line"><span class="crayon-r ">
<phase></span><span class="crayon-i ">compile</span><span class="crayon-r "></phase></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-53" class="crayon-line"><span class="crayon-r "><goals></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-54" class="crayon-line"><span class="crayon-r "><goal></span><span class="crayon-i ">rename</span><span class="crayon-r "></goal></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-55" class="crayon-line"><span class="crayon-r "></goals></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-56" class="crayon-line"><span class="crayon-r "><configuration></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-57" class="crayon-line"><span class="crayon-r "><sourceFile></span><span class="crayon-i ">${project.build.directory}/file-to-rename.txt</span><span class="crayon-r "></sourceFile></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-58" class="crayon-line"><span class="crayon-r "><destinationFile></span><span class="crayon-i ">${project.build.directory}/renamed-file.txt</span><span class="crayon-r "></destinationFile></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-59" class="crayon-line"><span class="crayon-r "></configuration></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-60" class="crayon-line"><span class="crayon-r "></execution></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-61" class="crayon-line"><span class="crayon-r "></executions></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-62" class="crayon-line"><span class="crayon-r "></plugin></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-63" class="crayon-line"></div>
<div id="crayon-59c3b2c0cd1ae672745455-64" class="crayon-line"><span class="crayon-r "></plugins></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-65" class="crayon-line"><span class="crayon-r "></build></span></div>
<div id="crayon-59c3b2c0cd1ae672745455-66" class="crayon-line"></div>
<div id="crayon-59c3b2c0cd1ae672745455-67" class="crayon-line"><span class="crayon-r "></project></span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<h1><strong>Building the project</strong></h1>
<p>Run a&nbsp;<span id="crayon-59c3b2c0cd1b1242625318" class="crayon-syntax crayon-syntax-inline  crayon-theme-familiar crayon-theme-familiar-inline crayon-font-consolas"><span class="crayon-pre crayon-code"><span class="crayon-e">mvn&nbsp;</span><span class="crayon-v">install</span></span></span>&nbsp;to build the project if you use command line or&nbsp;<em><strong>Right-Click</strong></em>&nbsp;->&nbsp;<strong><em>Run As</em></strong>&nbsp;->&nbsp;<strong><em>Maven install</em></strong>&nbsp;on Eclipse.</p>
<p>After a refresh, below the new project structure&nbsp;:</p>
<div id="attachment_1290" class="wp-caption aligncenter"><a href="http://roufid.com/wp-content/uploads/2016/12/2_project_output.png" rel="lightbox[1288]"><img class="size-full wp-image-1290" src="http://roufid.com/wp-content/uploads/2016/12/2_project_output.png" sizes="(max-width: 363px) 100vw, 363px" srcset="http://roufid.com/wp-content/uploads/2016/12/2_project_output.png 363w, http://roufid.com/wp-content/uploads/2016/12/2_project_output-300x150.png 300w" alt="Maven project output directory" width="363" height="181" /></a></p>
<p class="wp-caption-text">Maven project output directory</p>
</div>
<p>And the content of&nbsp;<span id="crayon-59c3b2c0cd1b3273428257" class="crayon-syntax crayon-syntax-inline  crayon-theme-familiar crayon-theme-familiar-inline crayon-font-consolas"><span class="crayon-pre crayon-code"><span class="crayon-v">renamed</span><span class="crayon-o">-</span><span class="crayon-v">file</span><span class="crayon-sy">.</span><span class="crayon-v">txt</span></span></span>is :</p>
<div id="crayon-59c3b2c0cd1b4493404796" class="crayon-syntax crayon-theme-familiar crayon-font-consolas crayon-os-mac print-yes notranslate" data-settings=" no-popup minimize scroll-mouseover">
<div class="crayon-plain-wrap"></div>
<div class="crayon-main">
<table class="crayon-table">
<tbody>
<tr class="crayon-row">
<td class="crayon-nums " data-settings="show">
<div class="crayon-nums-content">
<div class="crayon-num" data-line="crayon-59c3b2c0cd1b4493404796-1">1</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1b4493404796-2">2</div>
<div class="crayon-num" data-line="crayon-59c3b2c0cd1b4493404796-3">3</div>
</div>
</td>
<td class="crayon-code">
<div class="crayon-pre">
<div id="crayon-59c3b2c0cd1b4493404796-1" class="crayon-line"><span class="crayon-v">firstname</span><span class="crayon-o">=</span><span class="crayon-e">Radouane</span></div>
<div id="crayon-59c3b2c0cd1b4493404796-2" class="crayon-line"><span class="crayon-v">lastname</span><span class="crayon-o">=</span><span class="crayon-e">ROUFID</span></div>
<div id="crayon-59c3b2c0cd1b4493404796-3" class="crayon-line"><span class="crayon-v">date</span><span class="crayon-o">=</span><span class="crayon-cn">2016</span><span class="crayon-o">-</span><span class="crayon-cn">12</span><span class="crayon-o">-</span><span class="crayon-cn">06T10</span><span class="crayon-o">:</span><span class="crayon-cn">19</span><span class="crayon-o">:</span><span class="crayon-cn">19Z</span></div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<h1><strong>What happened ?</strong></h1>
<p>The project build is on two step. First&nbsp;<a href="https://maven.apache.org/plugins/maven-resources-plugin/" target="_blank" rel="noopener noreferrer">maven-resources-plugin</a>&nbsp;is used at the&nbsp;<span id="crayon-59c3b2c0cd1b6044578457" class="crayon-syntax crayon-syntax-inline  crayon-theme-familiar crayon-theme-familiar-inline crayon-font-consolas"><span class="crayon-pre crayon-code"><span class="crayon-v">copy</span><span class="crayon-o">-</span><span class="crayon-v">resources</span></span></span>&nbsp;lifecycle phase to filter the &nbsp;resources located under&nbsp;<span id="crayon-59c3b2c0cd1b8451667258" class="crayon-syntax crayon-syntax-inline  crayon-theme-familiar crayon-theme-familiar-inline crayon-font-consolas"><span class="crayon-pre crayon-code"><span class="crayon-o">/</span><span class="crayon-v">src</span><span class="crayon-o">/</span><span class="crayon-v">main</span></span></span>&nbsp;and copy them to the&nbsp;<span id="crayon-59c3b2c0cd1b9968637139" class="crayon-syntax crayon-syntax-inline  crayon-theme-familiar crayon-theme-familiar-inline crayon-font-consolas"><span class="crayon-pre crayon-code"><span class="crayon-v">target</span></span></span>&nbsp;directory. Next,&nbsp;<a href="https://coderplus.github.io/copy-rename-maven-plugin/" target="_blank" rel="noopener noreferrer">copy-rename-maven-plugin</a>&nbsp;is used to rename the&nbsp;<em>filtered</em>&nbsp;output file&nbsp;<span id="crayon-59c3b2c0cd1bb535947396" class="crayon-syntax crayon-syntax-inline  crayon-theme-familiar crayon-theme-familiar-inline crayon-font-consolas"><span class="crayon-pre crayon-code"><span class="crayon-v">file</span><span class="crayon-o">-</span><span class="crayon-st">to</span><span class="crayon-o">-</span><span class="crayon-v">rename</span><span class="crayon-sy">.</span><span class="crayon-v">txt</span></span></span>&nbsp;to&nbsp;<span id="crayon-59c3b2c0cd1bc832075309" class="crayon-syntax crayon-syntax-inline  crayon-theme-familiar crayon-theme-familiar-inline crayon-font-consolas"><span class="crayon-pre crayon-code"><span class="crayon-v">renamed</span><span class="crayon-o">-</span><span class="crayon-v">file</span><span class="crayon-sy">.</span><span class="crayon-v">txt</span></span></span>.</p>
<h1><strong>References</strong></h1>
<ul>
<li><strong><a href="https://maven.apache.org/plugins/maven-resources-plugin/" target="_blank" rel="noopener noreferrer">Apache Maven resources plugin</a></strong></li>
<li><strong><a href="https://coderplus.github.io/copy-rename-maven-plugin/" target="_blank" rel="noopener noreferrer">Copy Rename Maven Plugin</a></strong></li>
</ul>
</div>
</div>
</div>
