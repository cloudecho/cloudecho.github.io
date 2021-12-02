---
layout: post
status: publish
published: true
title: jquery表单验证validate插件全攻略


date: '2015-12-20 21:38:51 +0800'
date_gmt: '2015-12-20 13:38:51 +0800'
categories:
- Frontend
tags:
- ui
- jquery
- validate
comments: []
---
<div><strong>一、准备工作</strong><br />
需要JQuery版本：1.2.6+, 兼容 1.3.2</div>
<div><script src="jquery.js" type="text/javascript"></script><br />
<script src="jquery.validate.js" type="text/javascript"></script></div>
<div><strong>二、默认校验规则</strong></div>
<div>(1)required:true&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 必输字段<br />
(2)remote:"check.php"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 使用ajax方法调用check.php验证输入值<br />
(3)email:true&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 必须输入正确格式的电子邮件<br />
(4)url:true&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 必须输入正确格式的网址<br />
(5)date:true&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 必须输入正确格式的日期<br />
(6)dateISO:true&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 必须输入正确格式的日期(ISO)，例如：2009-06-23，1998/01/22 只验证格式，不验证有效性<br />
(7)number:true&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 必须输入合法的数字(负数，小数)<br />
(8)digits:true&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 必须输入整数<br />
(9)creditcard:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 必须输入合法的信用卡号<br />
(10)equalTo:"#field"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 输入值必须和#field相同<br />
(11)accept:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 输入拥有合法后缀名的字符串（上传文件的后缀）<br />
(12)maxlength:5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 输入长度最多是5的字符串(汉字算一个字符)<br />
(13)minlength:10&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 输入长度最小是10的字符串(汉字算一个字符)<br />
(14)rangelength:[5,10]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 输入长度必须介于 5 和 10 之间的字符串")(汉字算一个字符)<br />
(15)range:[5,10]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 输入值必须介于 5 和 10 之间<br />
(16)max:5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 输入值不能大于5<br />
(17)min:10&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 输入值不能小于10</div>
<div><strong>三、默认的提示</strong></div>
<div>messages: {<br />
required: "This field is required.",<br />
remote: "Please fix this field.",<br />
email: "Please enter a valid email address.",<br />
url: "Please enter a valid URL.",<br />
date: "Please enter a valid date.",<br />
dateISO: "Please enter a valid date (ISO).",<br />
dateDE: "Bitte geben Sie ein g眉ltiges Datum ein.",<br />
number: "Please enter a valid number.",<br />
numberDE: "Bitte geben Sie eine Nummer ein.",<br />
digits: "Please enter only digits",<br />
creditcard: "Please enter a valid credit card number.",<br />
equalTo: "Please enter the same value again.",<br />
accept: "Please enter a value with a valid extension.",<br />
maxlength: $.validator.format("Please enter no more than {0} characters."),<br />
minlength: $.validator.format("Please enter at least {0} characters."),<br />
rangelength: $.validator.format("Please enter a value between {0} and {1} characters long."),<br />
range: $.validator.format("Please enter a value between {0} and {1}."),<br />
max: $.validator.format("Please enter a value less than or equal to {0}."),<br />
min: $.validator.format("Please enter a value greater than or equal to {0}.")<br />
},</div>
<div>如需要修改，可在js代码中加入：</div>
<div>jQuery.extend(jQuery.validator.messages, {<br />
required: "必选字段",<br />
remote: "请修正该字段",<br />
email: "请输入正确格式的电子邮件",<br />
url: "请输入合法的网址",<br />
date: "请输入合法的日期",<br />
dateISO: "请输入合法的日期 (ISO).",<br />
number: "请输入合法的数字",<br />
digits: "只能输入整数",<br />
creditcard: "请输入合法的信用卡号",<br />
equalTo: "请再次输入相同的值",<br />
accept: "请输入拥有合法后缀名的字符串",<br />
maxlength: jQuery.validator.format("请输入一个长度最多是 {0} 的字符串"),<br />
minlength: jQuery.validator.format("请输入一个长度最少是 {0} 的字符串"),<br />
rangelength: jQuery.validator.format("请输入一个长度介于 {0} 和 {1} 之间的字符串"),<br />
range: jQuery.validator.format("请输入一个介于 {0} 和 {1} 之间的值"),<br />
max: jQuery.validator.format("请输入一个最大为 {0} 的值"),<br />
min: jQuery.validator.format("请输入一个最小为 {0} 的值")<br />
});</div>
<div>推荐做法，将此文件放入messages_cn.js中，在页面中引入<br />
<script src="../js/messages_cn.js" type="text/javascript"></script></div>
<div><strong>四、使用方式</strong></div>
<div>1.将校验规则写到控件中<br />
<script src="../js/jquery.js" type="text/javascript"></script><br />
<script src="../js/jquery.validate.js" type="text/javascript"></script><br />
<script src="./js/jquery.metadata.js" type="text/javascript"></script></div>
<div>$().ready(function() {<br />
$("#signupForm").validate();<br />
});</div>
<div>
<form id="signupForm" method="get" action="">
<p>
<label for="firstname">Firstname</label><br />
<input id="firstname" name="firstname" class="required" /></p>
<p>
<label for="email">E-Mail</label><br />
<input id="email" name="email" class="required email" /></p>
<p>
<label for="password">Password</label><br />
<input id="password" name="password" type="password" class="{required:true,minlength:5}" /></p>
<p>
<label for="confirm_password">确认密码</label><br />
<input id="confirm_password" name="confirm_password" type="password" class="{required:true,minlength:5,equalTo:'#password'}" /></p>
<p>
<input class="submit" type="submit" value="Submit"/></p>
</form>
</div>
<div>使用class="{}"的方式，必须引入包：jquery.metadata.js</div>
<div>可以使用如下的方法，修改提示内容：<br />
class="{required:true,minlength:5,messages:{required:'请输入内容'}}"</div>
<div>在使用equalTo关键字时，后面的内容必须加上引号，如下代码：<br />
class="{required:true,minlength:5,equalTo:'#password'}"</div>
<div>另外一个方式，使用关键字：meta（为了元数据使用其他插件你要包装 你的验证规则 在他们自己的项目中可以用这个特殊的选项）<br />
Tell the validation plugin to look inside a validate-property in metadata for validation rules.<br />
例如：<br />
meta: "validate"<br />
<input id="password" name="password" type="password" class="{validate:{required:true,minlength:5}}" /></div>
<div>再有一种方式：<br />
$.metadata.setType("attr", "validate");</div>
<div>这样可以使用validate="{required:true}"的方式，或者class="required"，但class="{required:true,minlength:5}"将不起作用</div>
<div></div>
<div>2.将校验规则写到代码中</div>
<div>$().ready(function() {<br />
$("#signupForm").validate({<br />
rules: {<br />
firstname: "required",<br />
email: {<br />
required: true,<br />
email: true<br />
},<br />
password: {<br />
required: true,<br />
minlength: 5<br />
},<br />
confirm_password: {<br />
required: true,<br />
minlength: 5,<br />
equalTo: "#password"<br />
}<br />
},<br />
messages: {<br />
firstname: "请输入姓名",<br />
email: {<br />
required: "请输入Email地址",<br />
email: "请输入正确的email地址"<br />
},<br />
password: {<br />
required: "请输入密码",<br />
minlength: jQuery.format("密码不能小于{0}个字符")<br />
},<br />
confirm_password: {<br />
required: "请输入确认密码",<br />
minlength: "确认密码不能小于5个字符",<br />
equalTo: "两次输入密码不一致不一致"<br />
}<br />
}<br />
});<br />
});</div>
<div>//messages处，如果某个控件没有message，将调用默认的信息</div>
<div>
<form id="signupForm" method="get" action="">
<p>
<label for="firstname">Firstname</label><br />
<input id="firstname" name="firstname" /></p>
<p>
<label for="email">E-Mail</label><br />
<input id="email" name="email" /></p>
<p>
<label for="password">Password</label><br />
<input id="password" name="password" type="password" /></p>
<p>
<label for="confirm_password">确认密码</label><br />
<input id="confirm_password" name="confirm_password" type="password" /></p>
<p>
<input class="submit" type="submit" value="Submit"/></p>
</form>
</div>
<div>required:true 必须有值<br />
required:"#aa:checked"表达式的值为真，则需要验证<br />
required:function(){}返回为真，表时需要验证<br />
后边两种常用于，表单中需要同时填或不填的元素</div>
<div></div>
<div><strong>五、常用方法及注意问题</strong></div>
<div>1.用其他方式替代默认的SUBMIT</div>
<div>$().ready(function() {<br />
$("#signupForm").validate({<br />
submitHandler:function(form){<br />
alert("submitted");<br />
form.submit();<br />
}<br />
});<br />
});</div>
<div>可以设置validate的默认值，写法如下：<br />
$.validator.setDefaults({<br />
submitHandler: function(form) { alert("submitted!");form.submit(); }<br />
});</div>
<div>如果想提交表单, 需要使用form.submit()而不要使用$(form).submit()</div>
<div>2.debug，如果这个参数为true，那么表单不会提交，只进行检查，调试时十分方便<br />
$().ready(function() {<br />
$("#signupForm").validate({<br />
debug:true<br />
});<br />
});<br />
如果一个页面中有多个表单，用<br />
$.validator.setDefaults({<br />
debug: true<br />
})</div>
<div>3.ignore：忽略某些元素不验证<br />
ignore: ".ignore"</div>
<div>4.errorPlacement：Callback&nbsp; Default: 把错误信息放在验证的元素后面<br />
指明错误放置的位置，默认情况是：error.appendTo(element.parent());即把错误信息放在验证的元素后面<br />
errorPlacement: function(error, element) {<br />
error.appendTo(element.parent());<br />
}</div>
<div>//示例：</p>
<tr>
<td class="label"><label id="lfirstname" for="firstname">First Name</label></td>
<td class="field"><input id="firstname" name="firstname" type="text" value="" maxlength="100" /></td>
<td class="status"></td>
</tr>
<tr>
<td style="padding-right: 5px;">
<input id="dateformat_eu" name="dateformat" type="radio" value="0" /><br />
<label id="ldateformat_eu" for="dateformat_eu">14/02/07</label>
</td>
<td style="padding-left: 5px;">
<input id="dateformat_am" name="dateformat" type="radio" value="1"&nbsp; /><br />
<label id="ldateformat_am" for="dateformat_am">02/14/07</label>
</td>
<td></td>
</tr>
<tr>
<td class="label">&amp;nbsp;</td>
<td class="field" colspan="2">
<div id="termswrap">
<input id="terms" type="checkbox" name="terms" /><br />
<label id="lterms" for="terms">I have read and accept the Terms of Use.</label>
</div>
</td>
</tr>
</div>
<div>errorPlacement: function(error, element) {<br />
if ( element.is(":radio") )<br />
error.appendTo( element.parent().next().next() );<br />
else if ( element.is(":checkbox") )<br />
error.appendTo ( element.next() );<br />
else<br />
error.appendTo( element.parent().next() );<br />
}</div>
<div>代码的作用是：一般情况下把错误信息显示在
<td class="status"></td>
<p>中，如果是radio显示在
<td></td>
<p>中，如果是checkbox显示在内容的后面</p></div>
<div>errorClass：String&nbsp; Default: "error"<br />
指定错误提示的css类名，可以自定义错误提示的样式</div>
<div>errorElement：String&nbsp; Default: "label"<br />
用什么标签标记错误，默认的是label你可以改成em</div>
<div>errorContainer：Selector<br />
显示或者隐藏验证信息，可以自动实现有错误信息出现时把容器属性变为显示，无错误时隐藏，用处不大<br />
errorContainer: "#messageBox1, #messageBox2"</div>
<div>errorLabelContainer：Selector<br />
把错误信息统一放在一个容器里面。</div>
<div>wrapper：String<br />
用什么标签再把上边的errorELement包起来</div>
<div>一般这三个属性同时使用，实现在一个容器内显示所有错误提示的功能，并且没有信息时自动隐藏</div>
<div>errorContainer: "div.error",<br />
errorLabelContainer: $("#signupForm div.error"),<br />
wrapper: "li"</div>
<div></div>
<div>设置错误提示的样式，可以增加图标显示</div>
<div>input.error { border: 1px solid red; }<br />
label.error {<br />
background:url("./demo/images/unchecked.gif") no-repeat 0px 0px;</div>
<div>&nbsp; padding-left: 16px;</div>
<div>&nbsp; padding-bottom: 2px;</div>
<div>&nbsp; font-weight: bold;</div>
<div>&nbsp; color: #EA5200;<br />
}<br />
label.checked {<br />
background:url("./demo/images/checked.gif") no-repeat 0px 0px;<br />
}</div>
<div>success：String,Callback<br />
要验证的元素通过验证后的动作，如果跟一个字符串，会当做一个css类，也可跟一个函数<br />
success: function(label) {<br />
// set &amp;nbsp; as text for IE<br />
label.html("&amp;nbsp;").addClass("checked");<br />
//label.addClass("valid").text("Ok!")<br />
}<br />
添加"valid" 到验证元素, 在CSS中定义的样式<br />
<style>label.valid {}</style>
<p>success: "valid"</p></div>
<div></div>
<div></div>
<div>nsubmit： Boolean&nbsp; Default: true<br />
提交时验证. 设置唯false就用其他方法去验证<br />
onfocusout：Boolean&nbsp; Default: true<br />
失去焦点是验证(不包括checkboxes/radio buttons)<br />
onkeyup：Boolean&nbsp; Default: true<br />
在keyup时验证.<br />
onclick：Boolean&nbsp; Default: true<br />
在checkboxes 和 radio 点击时验证<br />
focusInvalid：Boolean&nbsp; Default: true<br />
提交表单后，未通过验证的表单(第一个或提交之前获得焦点的未通过验证的表单)会获得焦点<br />
focusCleanup：Boolean&nbsp; Default: false<br />
如果是true那么当未通过验证的元素获得焦点时，移除错误提示。避免和 focusInvalid 一起用</div>
<div></div>
<div>// 重置表单<br />
$().ready(function() {<br />
var validator = $("#signupForm").validate({<br />
submitHandler:function(form){<br />
alert("submitted");<br />
form.submit();<br />
}<br />
});<br />
$("#reset").click(function() {<br />
validator.resetForm();<br />
});</div>
<div>});</div>
<div></div>
<div>remote：URL<br />
使用ajax方式进行验证，默认会提交当前验证的值到远程地址，如果需要提交其他的值，可以使用data选项</div>
<div>remote: "check-email.php"</div>
<div>remote: {<br />
url: "check-email.php",&nbsp;&nbsp;&nbsp;&nbsp; //后台处理程序<br />
type: "post",&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //数据发送方式<br />
dataType: "json",&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //接受数据格式<br />
data: {&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //要传递的数据<br />
username: function() {<br />
return $("#username").val();<br />
}<br />
}<br />
}</div>
<div>远程地址只能输出 "true" 或 "false"，不能有其它输出</div>
<div></div>
<div></div>
<div>addMethod：name, method, message<br />
自定义验证方法</div>
<div>// 中文字两个字节<br />
jQuery.validator.addMethod("byteRangeLength", function(value, element, param) {<br />
var length = value.length;<br />
for(var i = 0; i < value.length; i++){<br />
if(value.charCodeAt(i) > 127){<br />
length++;<br />
}<br />
}<br />
return this.optional(element) || ( length >= param[0] &amp;&amp; length <= param[1] );<br />
}, $.validator.format("请确保输入的值在{0}-{1}个字节之间(一个中文字</div>
<div></div>
<div>摘自『http://dcbjavaeye.iteye.com/blog/1125866』</div>
