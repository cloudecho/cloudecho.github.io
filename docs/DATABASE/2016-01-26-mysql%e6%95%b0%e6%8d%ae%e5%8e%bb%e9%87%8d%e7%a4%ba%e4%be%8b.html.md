---
layout: post
status: publish
published: true
title: MySQL数据去重示例


date: '2016-01-26 11:44:54 +0800'
date_gmt: '2016-01-26 03:44:54 +0800'
categories:
- Database
tags:
- ETL
comments: []
---
<pre>
-- ==== 数据清洗 ====
-- === 表1：ESB_ERP_BASIC_MODEL_PRICE ===
-- 根据MODL_ST去重  取最新记录
-- S1: 设置ROWNUM
select @x:= 0;

update ESB_ERP_BASIC_MODEL_PRICE t1
set t1.ATTRIBUTE10 = (select @x := @x+1);

-- S2: 根据ROWNUM去重
DELETE FROM ESB_ERP_BASIC_MODEL_PRICE 
WHERE ATTRIBUTE10 IN (
	select ATTRIBUTE10 from (
	  select t1.*
	   , if(@g1=t1.MODL_ST, @rank:=@rank+1, @rank:=1) as rank
	   , (@g1:=t1.MODL_ST) as g1
	  from 
		(select ATTRIBUTE10, MODL_ST, LAST_UPDATE_DATE
		from ESB_ERP_BASIC_MODEL_PRICE
		order by modl_st asc, LAST_UPDATE_DATE desc) t1
	  , (select @g1:=null, @rank:=0) t2
	) t where rank>1
)
;


-- === 表2：ESB_ERP_SPEC_PRICE ===
-- 根据MODL_ST+SPEC_ITEM_CD+SPEC_DTL_CD去重  取最新记录
-- S1: 设置ROWNUM
select @x:= 0;

update ESB_ERP_SPEC_PRICE t1
set t1.ATTRIBUTE10 = (select @x := @x+1);

-- S2: 根据ROWNUM去重
DELETE FROM ESB_ERP_SPEC_PRICE 
WHERE ATTRIBUTE10 IN (
	select ATTRIBUTE10 from (
	  select t1.*
	   , if(@g1=t1.group1, @rank:=@rank+1, @rank:=1) as rank
	   , (@g1:=t1.group1) as g1
	  from 
		(select ATTRIBUTE10, CONCAT(MODL_ST ,char(5), SPEC_ITEM_CD, char(5), SPEC_DTL_CD) group1, LAST_UPDATE_DATE
		from ESB_ERP_SPEC_PRICE
		order by MODL_ST, SPEC_ITEM_CD, SPEC_DTL_CD , LAST_UPDATE_DATE desc) t1
	  , (select @g1:=null, @rank:=0) t2
	) t where rank>1
)
;
</pre>
