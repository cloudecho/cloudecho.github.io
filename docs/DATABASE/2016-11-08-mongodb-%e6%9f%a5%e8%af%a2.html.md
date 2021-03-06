---
layout: post
status: publish
published: true
title: MongoDB 查询


date: '2016-11-08 10:01:57 +0800'
date_gmt: '2016-11-08 02:01:57 +0800'
categories:
- Database
tags:
- mongodb
- mongo
comments: []
---
<div class="postbody">
<div id="cnblogs_post_body">
<p>1.&nbsp; 基本查询：<br />
构造查询数据。<br />
> db.test.findOne()<br />
{<br />
"_id" : ObjectId("4fd58ecbb9ac507e96276f1a"),<br />
"name" : "stephen",<br />
"age" : 35,<br />
"genda" : "male",<br />
"email" : "<a href="mailto:stephen@hotmail.com">stephen@hotmail.com</a>"<br />
}</p>
<p><em>--多条件查询。下面的示例等同于SQL语句的where name = "stephen" and age = 35</em><br />
> db.test.find({"name":"stephen","age":35})<br />
{ "_id" : ObjectId("4fd58ecbb9ac507e96276f1a"), "name" : "stephen", "age" : 35, "genda" : "male", "email" : "<a href="mailto:stephen@hotmail.com">stephen@hotmail.com</a>" }</p>
<p><em>--返回指定的文档键值对。下面的示例将只是返回name和age键值对。</em><br />
> db.test.find({}, {"name":1,"age":1})<br />
{ "_id" : ObjectId("4fd58ecbb9ac507e96276f1a"), "name" : "stephen", "age" : 35 }</p>
<p>&nbsp;</p>
<p><em>--指定不返回的文档键值对。下面的示例将返回除name之外的所有键值对。</em><br />
> db.test.find({}, {"name":0})<br />
{ "_id" : ObjectId("4fd58ecbb9ac507e96276f1a"), "age" : 35, "genda" : "male", "email" : "<a href="mailto:stephen@hotmail.com">stephen@hotmail.com</a>" }</p>
<p>2.&nbsp; 查询条件：<br />
MongoDB提供了一组比较操作符：$lt/$lte/$gt/$gte/$ne，依次等价于</<=/>/>=/!=。<br />
<em>--下面的示例返回符合条件age >= 18 &amp;&amp; age <= 40的文档。</em><br />
> db.test.find({"age":{"$gte":18, "$lte":40}})<br />
{ "_id" : ObjectId("4fd58ecbb9ac507e96276f1a"), "name" : "stephen", "age" : 35,"genda" : "male", "email" : "<a href="mailto:stephen@hotmail.com">stephen@hotmail.com</a>" }</p>
<p><em>--下面的示例返回条件符合name != "stephen1"</em><br />
> db.test.find({"name":{"$ne":"stephen1"}})<br />
{ "_id" : ObjectId("4fd58ecbb9ac507e96276f1a"), "name" : "stephen", "age" : 35,"genda" : "male", "email" : "<a href="mailto:stephen@hotmail.com">stephen@hotmail.com</a>" }</p>
<p><em>--$in等同于SQL中的in，下面的示例等同于SQL中的in ("stephen","stephen1")</em><br />
> db.test.find({"name":{"$in":["stephen","stephen1"]}})<br />
{ "_id" : ObjectId("4fd58ecbb9ac507e96276f1a"), "name" : "stephen", "age" : 35,"genda" : "male", "email" : "<a href="mailto:stephen@hotmail.com">stephen@hotmail.com</a>" }</p>
<p><em>--和SQL不同的是，MongoDB的in list中的数据可以是不同类型。这种情况可用于不同类型的别名场景。</em><br />
> db.test.find({"name":{"$in":["stephen",123]}})<br />
{ "_id" : ObjectId("4fd58ecbb9ac507e96276f1a"), "name" : "stephen", "age" : 35,"genda" : "male", "email" : "<a href="mailto:stephen@hotmail.com">stephen@hotmail.com</a>" }</p>
<p><em>--$nin等同于SQL中的not in，同时也是$in的取反。如：</em><br />
> db.test.find({"name":{"$nin":["stephen2","stephen1"]}})<br />
{ "_id" : ObjectId("4fd58ecbb9ac507e96276f1a"), "name" : "stephen", "age" : 35,"genda" : "male", "email" : "<a href="mailto:stephen@hotmail.com">stephen@hotmail.com</a>" }</p>
<p><em>--$or等同于SQL中的or，$or所针对的条件被放到一个数组中，每个数组元素表示or的一个条件。</em><br />
<em>--下面的示例等同于name = "stephen1" or age = 35</em><br />
> db.test.find({"$or": [{"name":"stephen1"}, {"age":35}]})<br />
{ "_id" : ObjectId("4fd58ecbb9ac507e96276f1a"), "name" : "stephen", "age" : 35,"genda" : "male", "email" : "<a href="mailto:stephen@hotmail.com">stephen@hotmail.com</a>" }</p>
<p><em>--下面的示例演示了如何混合使用$or和$in。</em><br />
> db.test.find({"$or": [{"name":{"$in":["stephen","stephen1"]}}, {"age":36}]})<br />
{ "_id" : ObjectId("4fd58ecbb9ac507e96276f1a"), "name" : "stephen", "age" : 35,"genda" : "male", "email" : "<a href="mailto:stephen@hotmail.com">stephen@hotmail.com</a>" }</p>
<p><em>--$not表示取反，等同于SQL中的not。</em><br />
> db.test.find({"name": {"$not": {"$in":["stephen2","stephen1"]}}})<br />
{ "_id" : ObjectId("4fd58ecbb9ac507e96276f1a"), "name" : "stephen", "age" : 35,"genda" : "male", "email" : "<a href="mailto:stephen@hotmail.com">stephen@hotmail.com</a>" }</p>
<p>&nbsp;</p>
<p>3.&nbsp; null数据类型的查询：<br />
<em>--在进行值为null数据的查询时，所有值为null，以及不包含指定键的文档均会被检索出来。</em><br />
> db.test.find({"x":null})<br />
{ "_id" : ObjectId("4fd59d30b9ac507e96276f1b"), "x" : null }<br />
{ "_id" : ObjectId("4fd59d49b9ac507e96276f1c"), "y" : 1 }</p>
<p><em>--需要将null作为数组中的一个元素进行相等性判断，即便这个数组中只有一个元素。</em><br />
<em>--再有就是通过$exists判断指定键是否存在。</em><br />
> db.test.find({"x": {"$in": [null], "$exists":true}})<br />
{ "_id" : ObjectId("4fd59d30b9ac507e96276f1b"), "x" : null }</p>
<p>4.&nbsp; 正则查询：<br />
<em>--MongoDB中使用了Perl规则的正则语法。如：</em><br />
> db.test.find()<br />
{ "_id" : ObjectId("4fd59ed7b9ac507e96276f1d"), "name" : "stephen" }<br />
{ "_id" : ObjectId("4fd59edbb9ac507e96276f1e"), "name" : "stephen1" }<br />
<em>--i表示忽略大小写</em><br />
> db.test.find({"name":/stephen?/i})<br />
{ "_id" : ObjectId("4fd59ed7b9ac507e96276f1d"), "name" : "stephen" }<br />
{ "_id" : ObjectId("4fd59edbb9ac507e96276f1e"), "name" : "stephen1" }</p>
<p>5.&nbsp; 数组数据查询：<br />
<em>--基于数组的查找。</em><br />
> db.test.find()<br />
{ "_id" : ObjectId("4fd5a177b9ac507e96276f1f"), "fruit" : [ "apple", "banana", "peach" ] }<br />
{ "_id" : ObjectId("4fd5a18cb9ac507e96276f20"), "fruit" : [ "apple", "kumquat","orange" ] }<br />
{ "_id" : ObjectId("4fd5a1f0b9ac507e96276f21"), "fruit" : [ "cherry", "banana","apple" ] }<br />
<em>--数组中所有包含banana的文档都会被检索出来。</em><br />
> db.test.find({"fruit":"banana"})<br />
{ "_id" : ObjectId("4fd5a177b9ac507e96276f1f"), "fruit" : [ "apple", "banana", "peach" ] }<br />
{ "_id" : ObjectId("4fd5a1f0b9ac507e96276f21"), "fruit" : [ "cherry", "banana","apple" ] }<br />
--检索数组中需要包含多个元素的情况，这里使用$all。下面的示例中，数组中必须同时包含apple和banana，<em>但是他们的顺序无关紧要。</em><br />
> db.test.find({"fruit": {"$all": ["banana","apple"]}})<br />
{ "_id" : ObjectId("4fd5a177b9ac507e96276f1f"), "fruit" : [ "apple", "banana", "peach" ] }<br />
{ "_id" : ObjectId("4fd5a1f0b9ac507e96276f21"), "fruit" : [ "cherry", "banana", "apple" ] }<br />
<em>--下面的示例表示精确匹配，即被检索出来的文档，fruit值中的数组数据必须和查询条件完全匹配，即不能多，也不能少，顺序也必须保持一致。</em><br />
> db.test.find({"fruit":["apple","banana","peach"]})<br />
{ "_id" : ObjectId("4fd5a177b9ac507e96276f1f"), "fruit" : [ "apple", "banana", peach" ] }<br />
<em>--下面的示例将匹配数组中指定下标元素的值。数组的起始下标是0。</em><br />
> db.test.find({"fruit.2":"peach"})<br />
{ "_id" : ObjectId("4fd5a177b9ac507e96276f1f"), "fruit" : [ "apple", "banana", peach" ] }<br />
<em>--可以通过$size获取数组的长度，但是$size不能和比较操作符联合使用。</em><br />
> db.test.find({"fruit": {$size : 3}})<br />
{ "_id" : ObjectId("4fd5a177b9ac507e96276f1f"), "fruit" : [ "apple", "banana", "peach" ] }<br />
{ "_id" : ObjectId("4fd5a18cb9ac507e96276f20"), "fruit" : [ "apple", "kumquat","orange" ] }<br />
{ "_id" : ObjectId("4fd5a1f0b9ac507e96276f21"), "fruit" : [ "cherry", "banana","apple" ] }<br />
<em>--如果需要检索size > n的结果，不能直接使用$size，只能是添加一个额外的键表示数据中的元素数据，在操作数据中的元素时，需要同时更新size键的值。</em><br />
<em>--为后面的实验构造数据。</em><br />
> db.test.update({}, {"$set": {"size":3}},false,true)<br />
> db.test.find()<br />
{ "_id" : ObjectId("4fd5a18cb9ac507e96276f20"), "fruit" : [ "apple", "kumquat", "orange" ], "size" : 3 }<br />
{ "_id" : ObjectId("4fd5a1f0b9ac507e96276f21"), "fruit" : [ "cherry", "banana", "apple" ], "size" : 3 }<br />
<em>--每次添加一个新元素，都要原子性的自增size一次。</em><br />
> test.update({},{"$push": {"fruit":"strawberry"},"$inc":{"size":1}},false,true)<br />
> db.test.find()<br />
{ "_id" : ObjectId("4fd5a18cb9ac507e96276f20"), "fruit" : [ "apple", "kumquat", "orange", "strawberry" ], "size" : 4 }<br />
{ "_id" : ObjectId("4fd5a1f0b9ac507e96276f21"), "fruit" : [ "cherry", "banana", "apple", "strawberry" ], "size" : 4 }<br />
<em>--通过$slice返回数组中的部分数据。"$slice":2表示数组中的前两个元素。</em><br />
> db.test.find({},{"fruit": {"$slice":2}, "size":0})<br />
{ "_id" : ObjectId("4fd5a18cb9ac507e96276f20"), "fruit" : [ "apple", "kumquat" ]}<br />
{ "_id" : ObjectId("4fd5a1f0b9ac507e96276f21"), "fruit" : [ "cherry", "banana" ]}<br />
<em>--通过$slice返回数组中的部分数据。"$slice":-2表示数组中的后两个元素。</em><br />
> db.test.find({},{"fruit": {"$slice":-2}, "size":0})<br />
{ "_id" : ObjectId("4fd5a18cb9ac507e96276f20"), "fruit" : [ "orange", "strawberry" ] }<br />
{ "_id" : ObjectId("4fd5a1f0b9ac507e96276f21"), "fruit" : [ "apple", "strawberry" ] }<br />
<em>--$slice : [2,1]，表示从第二个2元素开始取1个，如果获取数量大于2后面的元素数量，则取后面的全部数据。</em><br />
> db.test.find({},{"fruit": {"$slice":[2,1]}, "size":0})<br />
{ "_id" : ObjectId("4fd5a18cb9ac507e96276f20"), "fruit" : [ "orange" ] }<br />
{ "_id" : ObjectId("4fd5a1f0b9ac507e96276f21"), "fruit" : [ "apple" ] }</p>
<p>6.&nbsp; 内嵌文档查询：<br />
<em>--为后面的示例构造测试数据。</em><br />
> db.test.find()<br />
{ "_id" : ObjectId("4fd5ada3b9ac507e96276f22"), "name" : { "first" : "Joe", "last" : "He" }, "age" : 45 }<br />
<em> --当嵌入式文档为数组时，需要$elemMatch操作符来帮助定位某一个元素匹配的情况，否则嵌入式文件将进行全部的匹配。</em><br />
<em>--即检索时需要将所有元素都列出来作为查询条件方可。</em><br />
> db.test.findOne()<br />
{<br />
"_id" : ObjectId("4fd5af76b9ac507e96276f23"),<br />
"comments" : [<br />
{<br />
"author" : "joe",<br />
"score" : 3<br />
},<br />
{<br />
"author" : "mary",<br />
"score" : 6<br />
}<br />
]<br />
}<br />
> db.test.find({"comments": {"$elemMatch": {"author":"joe","score":{"$gte":3}}}}<br />
{ "_id" : ObjectId("4fd5af76b9ac507e96276f23"), "comments" : [ { "author" : "joe", "score" : 3 }, { "author" : "mary", "score" : 6 } ] }</p>
<p>7.&nbsp; 游标：<br />
数据库使用游标来返回find()的执行结果，客户端对游标可以进行有效的控制，如：限定结果集的数量、跳过部分结果、基于任意键的任意方向的排序等。<br />
下面的例子将用于准备测试数据。<br />
> db.testtable.remove()<br />
> for (i = 0; i < 10; ++i) {<br />
... db.testtable.insert({x:i})<br />
... }<br />
我们可以通过cursor提供的hasNext()方法判断是否还有未读取的数据，再通过next()方法读取结果集中的下一个文档。如：<br />
> var c = db.testtable.find()<br />
> while (c.hasNext()) {<br />
... print(c.next().x)<br />
... }<br />
0<br />
1<br />
2<br />
3<br />
4<br />
5<br />
6<br />
7<br />
8<br />
9<br />
当调用find()的时候，shell并不立即查询数据库，而是等待真正开始要求获得结果的时候才发送查询，这样在执行之前可以给查询附加额外的选项。几乎所有的游标方法都返回本身，因此可以像下面这样将游标的方法链式组合起来。如：<br />
> var c1 = db.testtable.find().sort({"x":1}).limit(1).skip(4);<br />
> var c2 = db.testtable.find().limit(1).sort({"x":1}).skip(4);<br />
> var c3 = db.testtable.find().skip(4).limit(1).sort({"x":1});<br />
此时，查询并未执行，所有这些函数都是在构造查询，当执行下面的语句时，查询将被真正执行，<br />
> c.hasNext()<br />
查询被发送到服务器，MongoDB服务器每次将返回一批数据，当本批被全部迭代后再从服务器读取下一批数据，直至查询结果需要的数据被全部迭代。</p>
<p>对于上面的示例，limit(1)表示输出结果仅为一个，如果小于1，则不输出，即limit(n)函数限定的是最多输出结果。skip(4)表示跳过查询结果中的前4个文档，如果结果小于4，则不会返回任何文档。sort({"x":1})用于设定排序条件，即按照x键以升序(1)的方式排序，如果需要降序排序可以改为：sort({"x":-1})。sort也可以支持多键排序，如：sort({username:1, age:-1})即先按照username进行升序排序，如果username的值相同，再以age键进行降序排序。这里需要指出的是，如果skip过多的文档，将会导致性能问题。</p>
</div>
<div id="blog_post_info_block">
<div id="BlogPostCategory"></div>
</div>
</div>
<div>摘自「http://www.cnblogs.com/stephen-liu74/archive/2012/08/03/2553803.html」</div>
<div>See more: <a href="http://www.cnblogs.com/stephen-liu74/category/378376.html" target="_blank">MongoDB</a></div>
