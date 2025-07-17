--**CREATE TABLE命令示例**
drop database if exists TPCH_TEST;
create database TPCH_TEST;
use TPCH_TEST;

--【例4-4】参照图3-13（A）模式，写出TPC-H数据库中各表的定义命令。
drop table if exists REGION;
CREATE TABLE REGION
(	R_REGIONKEY 	integer ,
	R_NAME  		char(25), 
	R_COMMENT  		varchar(152) );
--没有主键约束条件，不创建键和索引
drop table if exists REGION;
CREATE TABLE REGION
(	R_REGIONKEY 	integer 	PRIMARY KEY,
	R_NAME  		char(25), 
	R_COMMENT  		varchar(152) );
--设置主键约束条件，自动创建键和索引
drop table if exists NATION;
CREATE TABLE NATION
(	N_NATIONKEY 	integer 	PRIMARY KEY,
	N_NAME  		char(25), 
	N_REGIONKEY  	integer 	REFERENCES REGION (R_REGIONKEY),
	N_COMMENT  		varchar(152)  );
--创建外键，前提是参归表REGION的字段为主键列

drop table if exists PART;
CREATE TABLE PART
(	P_PARTKEY  		integer 	PRIMARY KEY,
	P_NAME  		varchar(55), 
	P_MFGR  		char(25),
	P_BRAND  		char(10),	
	P_TYPE  		varchar(25), 
	P_SIZE  		integer, 
	P_CONTAINER  	char(10), 
	P_RETAILPRICE 	decimal,
	P_COMMENT  		varchar(23) );

drop table if exists SUPPLIER;
CREATE TABLE SUPPLIER
(	S_SUPPKEY   	integer 	PRIMARY KEY,
	S_NAME  		char(25), 
	S_ADDRESS  		varchar(40), 
	S_NATIONKEY  	integer 	REFERENCES NATION (N_NATIONKEY),
	S_PHONE  		char(15), 
	S_ACCTBAL  		decimal,
	S_COMMENT  		varchar(101) ); 

drop table if exists PARTSUPP;
CREATE TABLE PARTSUPP
(	PS_PARTKEY  		integer		REFERENCES PART (P_PARTKEY),
	PS_SUPPKEY  		integer		REFERENCES SUPPLIER (S_SUPPKEY),
	PS_AVAILQTY  		integer, 
	PS_SUPPLYCOST 		Decimal,
	PS_COMMENT  		varchar(199),
	PRIMARY KEY(PS_PARTKEY, PS_SUPPKEY) ); 

drop table if exists CUSTOMER;
CREATE TABLE CUSTOMER
(	C_CUSTKEY  		integer 	PRIMARY KEY,
	C_NAME  		varchar(25), 
	C_ADDRESS  		varchar(40), 
	C_NATIONKEY 	integer		REFERENCES NATION (N_NATIONKEY),
	C_PHONE  		char(15), 
	C_ACCTBAL  		Decimal,
	C_MKTSEGMENT 	char(10), 
	C_COMMENT  		varchar(117) );

drop table if exists ORDERS;
CREATE TABLE ORDERS
(	O_ORDERKEY 	 	integer 	PRIMARY KEY,
	O_CUSTKEY  		integer		REFERENCES CUSTOMER (C_CUSTKEY),
	O_ORDERSTATUS 	char(1), 
	O_TOTALPRICE  	Decimal, 
	O_ORDERDATE  	Date, 
	O_ORDERPRIORITY char(15), 
	O_CLERK  		char(15), 
	O_SHIPPRIORITY 	integer,
	O_COMMENT  		varchar(79)  );


drop table if exists LINEITEM;
CREATE TABLE LINEITEM
(	L_ORDERKEY  	integer		REFERENCES ORDERS (O_ORDERKEY),
	L_PARTKEY 		integer		REFERENCES PART (P_PARTKEY),
	L_SUPPKEY  		integer		REFERENCES SUPPLIER (S_SUPPKEY), 
	L_LINENUMBER	integer,
	L_QUANTITY  	decimal,
	L_EXTENDEDPRICE decimal, 
	L_DISCOUNT  	float, 
	L_TAX  			float, 
	L_RETURNFLAG 	char(1), 
	L_LINESTATUS  	char(1), 
	L_SHIPDATE  	date, 
	L_COMMITDATE 	date, 
	L_RECEIPTDATE 	date, 
	L_SHIPINSTRUCT 	char(25), 
	L_SHIPMODE  	char(10), 
	L_COMMENT  		varchar(44), 
	PRIMARY KEY(L_ORDERKEY, L_LINENUMBER),
	FOREIGN KEY (L_PARTKEY, L_SUPPKEY) REFERENCES PARTSUPP (PS_PARTKEY,PS_SUPPKEY));

--从TPCH_DEMO库中向TPCH_TEST表中插入记录
insert into REGION select * from [TPCH_DEMO].[dbo].REGION;
insert into NATION select * from [TPCH_DEMO].[dbo].NATION;
insert into SUPPLIER select * from [TPCH_DEMO].[dbo].SUPPLIER;
insert into PART select * from [TPCH_DEMO].[dbo].PART;
insert into PARTSUPP select * from [TPCH_DEMO].[dbo].PARTSUPP;
insert into CUSTOMER select * from [TPCH_DEMO].[dbo].CUSTOMER;
insert into ORDERS select * from [TPCH_DEMO].[dbo].ORDERS;
insert into LINEITEM select * from [TPCH_DEMO].[dbo].LINEITEM;

--**ALTER TABLE命令示例**
ALTER TABLE LINEITEM ADD L_SURRKEY int;
--SQL命令解析：增加一个int类型的列L_SURRKEY;
ALTER TABLE LINEITEM ALTER COLUMN L_QUANTITY SMALLINT;
--SQL命令解析：将L_QUANTITY列的数据类型修改为SMALLINT：
ALTER TABLE ORDERS ALTER COLUMN O_ORDERPRIORITY varchar(15) NOT NULL;
--SQL命令解析：将O_ORDERPRIORITY列的约束修改为NOT NULL约束：
ALTER TABLE LINEITEM ADD CONSTRAINT FK_S FOREIGN KEY (L_SURRKEY) REFERENCES SUPPLIER(S_SUPPKEY); 
--SQL命令解析：在LINEITEM表中增加一个外键约束。CONSTRAINT关键字定义约束的名称FK_S，然后定义表级参照完整性约束条件。
ALTER TABLE LINEITEM DROP CONSTRAINT FK_S;
--SQL命令解析：在LINEITEM表中删除外键约束FK_S。
ALTER TABLE LINEITEM DROP COLUMN L_SURRKEY;
--SQL命令解析：删除表中的列L_SURRKEY：

--**ROP TABLE**
DROP TABLE ORDERS;
--由于主外键约束的存在而不能删除，需要先删除所参照的表后再删除
DROP TABLE LINEITEM;
DROP TABLE ORDERS;
--级联删除方法，先删除所有下级，再删除上级

--***前沿技术，内存表*
--创建文件组
ALTER DATABASE TPCH ADD FILEGROUP TPCH_mod CONTAINS MEMORY_OPTIMIZED_DATA  
ALTER DATABASE TPCH ADD FILE (NAME='TPCH_mod', FILENAME= 'C:\IM_DATA\TPCH_mod') TO FILEGROUP TPCH_mod;  
--创建内存表
CREATE TABLE LINEITEM_IM (
	L_ORDERKEY  		integer     	not null,
	L_PARTKEY 			integer     	not null,
	L_SUPPKEY  			integer     	not null,
	L_LINENUMBER 		integer     	not null,
	L_QUANTITY  		decimal     	not null,
	L_EXTENDEDPRICE  	decimal     	not null, 
	L_DISCOUNT  		decimal     	not null, 
	L_TAX  				decimal     	not null, 
	L_RETURNFLAG 		char(1)     	not null, 
	L_LINESTATUS  		char(1)     	not null, 
	L_SHIPDATE  		date     		not null, 
	L_COMMITDATE 		date     		not null, 
	L_RECEIPTDATE 		date     		not null, 
	L_SHIPINSTRUCT 		char(25)     	not null, 
	L_SHIPMODE  		char(10)     	not null, 
	L_COMMENT  			varchar(44)   	not null, 
	index ix_orderkey nonclustered hash (L_ORDERKEY,L_LINENUMBER ) with (bucket_count=8000000)
) WITH (MEMORY_OPTIMIZED=ON, DURABILITY=SCHEMA_ONLY);

--**CREATE INDEX**
--【例4-8】为TPC-H数据库的supplier表的s_name列创建唯一索引，为s_nation列和s_city列创建复合索引，其中s_nation为升序，s_city为降序。
drop table if exists SUPPLIER_nopk;
CREATE TABLE SUPPLIER_nopk
(	S_SUPPKEY   	integer 	,
	S_NAME  		char(25), 
	S_ADDRESS  		varchar(40), 
	S_NATIONKEY  	integer 	,
	S_PHONE  		char(15), 
	S_ACCTBAL  		decimal,
	S_COMMENT  		varchar(101) ); 
insert into SUPPLIER_nopk select * from SUPPLIER;
--查看无主键聚集索引的查找执行计划
select * from SUPPLIER_nopk where s_name='Supplier#000000728';
--查看带有主键聚集索引的查找执行计划
drop index if exists supplier.s_name_Inx;
select * from supplier where s_name='Supplier#000000728';
--查找操作执行计划
CREATE UNIQUE INDEX s_name_Inx ON supplier(s_name);
CREATE INDEX s_n_c_Inx ON supplier(s_nationkey ASC, s_phone DESC);
--创建索引后的查找执行计划
select * from supplier where s_name='Supplier#000000728';

--无索引扫描
drop index if exists lineitem.csindx_lineorder;
SELECT l_returnflag, l_linestatus, SUM(l_extendedprice*(1-l_discount)*(1+l_tax))
FROM lineitem
WHERE l_shipdate <= '1998-12-01'
GROUP BY l_returnflag, l_linestatus;

--创建列存储索引
CREATE NONCLUSTERED COLUMNSTORE INDEX csindx_lineorder
ON lineitem(l_returnflag, l_linestatus, l_extendedprice,l_discount,l_tax,l_shipdate);
--自动在列存储索引上扫描
SELECT l_returnflag, l_linestatus, SUM(l_extendedprice*(1-l_discount)*(1+l_tax))
FROM lineitem
WHERE l_shipdate <= '1998-12-01'
GROUP BY l_returnflag, l_linestatus;

--**DROP INDEX**
DROP INDEX supplier.s_n_c_Inx; 
DROP INDEX s_name_Inx ON supplier;

--**单表查询**
--投影操作
--【例4 11】查询PART表中全部的记录。
SELECT * FROM PART;
--或
SELECT P_RETAILPRICE, P_MFGR,P_BRAND, P_TYPE, 
P_SIZE, P_CONTAINER,  P_COMMENT ,P_PARTKEY, P_NAME
FROM PART;
--查询指定列
--【例4 12】查询PART表中P_NAME、P_BRAND和P_CONTAINER列。
SELECT P_NAME, P_BRAND, P_CONTAINER FROM PART;
--查询表达式列
Select L_COMMITDATE, L_RECEIPTDATE, 'Interval Days:' as Receipting, 
DATEDIFF (DAY, L_COMMITDATE, L_RECEIPTDATE) as IntervalDay,
L_EXTENDEDPRICE*(1-L_DISCOUNT) as DiscountedPrice,
L_EXTENDEDPRICE*(1-L_DISCOUNT)*(1+L_TAX) as DiscountedTaxedPrice
from LINEITEM;
--投影出列中不同的成员
--【例4-14】查出LINEITEM表中各订单项的L_SHIPMODE方式以及查询共有哪些L_SHIPMODE方式。
select L_SHIPMODE from LINEITEM;
--SQL命令解析：输出L_SHIPMODE列中全部的取值，包括了重复的取值。
select distinct L_SHIPMODE from LINEITEM;
--SQL命令解析：通过DISTINCT短语指定列L_SHIPMODE只输出不同取值的成员，列中的每个取值只输出一次。
select distinct l_orderkey,l_linenumber  from LINEITEM;
select count(*) from lineitem;
select distinct ps_partkey,ps_suppkey  from partsupp;
select count(*) from partsupp;
--行数相同，说明每个复合键只出现一次
select ps_partkey,ps_suppkey, count(*) as counter from partsupp group by ps_partkey,ps_suppkey
--检验partsupp表中的复合主键是否唯一

--**选择操作**
--比较大小
--【例4-15】输出LINEITEM表中满足条件的记录。
select * from LINEITEM where L_QUANTITY!<45;
--SQL命令解析：输出LINEITEM表中L_QUANTITY大于45的记录。
select * from LINEITEM where L_SHIPINSTRUCT='COLLECT COD';
--SQL命令解析：输出表中L_SHIPINSTRUCT值为COLLECT COD的记录。
select * from LINEITEM where NOT L_COMMITDATE>L_SHIPDATE;
--SQL命令解析：输出表中L_COMMITDATE时间不晚于L_SHIPDATE时间的记录。
select * from LINEITEM where DATEDIFF(DAY,L_COMMITDATE,L_RECEIPTDATE)> 10;
--SQL命令解析：输出表中RECEIPTDATE与COMMITDATE超过10天的记录。
--范围判断
--【例4-16】输出LINEITEM表中指定范围之间的记录。
select * from LINEITEM 
where L_COMMITDATE between L_SHIPDATE and L_RECEIPTDATE;
--SQL命令解析：输出LINEITEM表中COMMITDATE介于SHIPDATE和RECEIPTDATE之间的记录。
select * from LINEITEM 
where L_COMMITDATE not between '1996-01-01' and '1997-12-31';
--SQL命令解析：输出LINEITEM表中1996至1997年之外的记录。

--日期函数示例
select 
l_shipdate,
DATEADD(YY,5,l_shipdate) as date_5Year_after,
DATEADD(Q,5,l_shipdate) as date_5Quarter_after,
DATEADD(WW,5,l_shipdate) as date_5Week_after,
DATEADD(DD,-25,l_shipdate) as date_25D_before,
DATEDIFF(D,l_shipdate,l_receiptdate) as daygap
from LINEITEM;

--集合判断
--【例4 17】输出LINEITEM表中集合之内的记录。
select * from LINEITEM where L_SHIPMODE in ('MAIL', 'SHIP');
--SQL命令解析：输出L_SHIPMODE类型为MAIL和SHIP的记录。
select * from PART where P_SIZE not in (49,14,23,45,19,3,36,9);
--SQL命令解析：输出PART表中为P_SIZE不是49,14,23,45,19,3,36,9的记录

--字符匹配
--【例4-18】输出模糊查询的结果。
select * from PART where P_TYPE like 'PROMO%';
--SQL命令解析：输出PART表中P_TYPE列中以PROMO开头的记录。
select * from SUPPLIER where S_COMMENT like '%Customer%Complaints%';
--SQL命令解析：输出SUPPLIER表中S_COMMENT中任意位置包含Customer并且后面字符中包含Complaints的记录。
select * from PART where P_CONTAINER like '% _AG';
--SQL命令解析：输出PART表P_CONTAINER列中倒数第3个为任意字符，最后2个字符为AG的记录。
select * from LINEITEM where L_COMMENT like '%return rate __\%for%' ESCAPE '%';
--SQL命令解析：输出LINEITEM表L_COMMENT列中包含return rate 和两位数字、百分比符号和for字符的记录，其中_为通配符，由'\'表示其后的%为百分比符号

--空值判断
--【例4-19】输出LINEITEM表中没有客户评价L_COMMENT的记录。
select * from LINEITEM where L_COMMENT is NULL;
--SQL命令解析：输出LINEITEM表中L_COMMENT列为空值的记录。

--复合条件表达式
--【例4-20】输出LINEITEM表中满足复合条件的记录。
select sum(L_EXTENDEDPRICE*L_DISCOUNT) as revenue from LINEITEM
where L_SHIPDATE between '1996-01-01' and '1996-12-31' 
and L_DISCOUNT between 0.06 - 0.01 and 0.06 + 0.01 and L_QUANTITY > 24;
--SQL命令解析：输出LINEITEM表中SHIPDATE在1994年、折扣在5%-7%之间、数量小于24的订单项记录。多个查询条件用AND、OR连接，AND优先级高于OR
select * from LINEITEM 
where L_SHIPMODE in ('AIR', 'AIR REG') 
and L_SHIPINSTRUCT ='DELIVER IN PERSON' 
and ((L_QUANTITY >= 10 and L_QUANTITY <= 20) or (L_QUANTITY >= 30 and L_QUANTITY <= 40));
--SQL命令解析：输出LINEITEM表中SHIPMODE列为AIR或AIR REG，SHIPINSTRUCT类型为DELIVER IN PERSON，QUANTITY在10与20之间或30与40之间的记录。

--**聚集操作**
--【例4-21】执行TPC-H查询Q1中聚集计算部分。
select
sum(L_QUANTITY) as sum_qty,
sum(L_EXTENDEDPRICE) as sum_base_price,
sum(L_EXTENDEDPRICE*(1-L_DISCOUNT)) as sum_disc_price,
sum(L_EXTENDEDPRICE*(1-L_DISCOUNT)*(1+L_TAX)) as sum_charge,
avg(L_QUANTITY) as avg_qty,
avg(L_EXTENDEDPRICE) as avg_price,
avg(L_DISCOUNT) as avg_disc,
count(*) as count_order
from LINEITEM

--【例4-22】统计LINEITEM表中L_QUANTITY列的数据特征。
select count(distinct L_QUANTITY) as CARD, max(L_QUANTITY) as MaxValue, 
min(L_QUANTITY) as MinValue from LINEITEM;
--SQL命令分析：统计LINEITEM表中L_QUANTITY列中不同取值的数量，最大值与最小值。
--【例4-23】统计ORDERS表中高优化级与低优化级订单的数量。
select sum(case 
when O_ORDERPRIORITY ='1-URGENT' or O_ORDERPRIORITY ='2-HIGH' 
then 1 else 0 end) as high_line_count,
sum(case 
when O_ORDERPRIORITY <> '1-URGENT' and O_ORDERPRIORITY <> '2-HIGH'
then 1 else 0 end) as low_line_count
from ORDERS;
--SQL命令分析：通过case语句根据构建的选择条件输出分支结果，并对结果进行聚集计算。
select O_ORDERPRIORITY,sum(o_totalprice) as revenue from orders group by O_ORDERPRIORITY;

select 
sum(case when O_ORDERPRIORITY ='1-URGENT' then o_totalprice else 0 end) as '1-URGENT',
sum(case when O_ORDERPRIORITY ='2-HIGH' then o_totalprice else 0 end) as '2-HIGH',
sum(case when O_ORDERPRIORITY ='3-MEDIUM' then o_totalprice else 0 end) as '3-MEDIUM',
sum(case when O_ORDERPRIORITY ='4-NOT SPECIFIED' then o_totalprice else 0 end) as '4-NOT SPECIFIED',
sum(case when O_ORDERPRIORITY ='5-LOW' then o_totalprice else 0 end) as '5-LOW'
from ORDERS;
--输出结果转置

--**分组操作**
--【例4-24】对LINEITEM表按RETURNFLAG,SHIPMODE不同的方式统计销售数量。
select sum(L_QUANTITY) as sum_quantity from LINEITEM;
--SQL命令解析：统计LINEITEM表所有记录L_QUANTITY的汇总值。
select L_RETURNFLAG,sum(L_QUANTITY) as sum_quantity from LINEITEM group by L_RETURNFLAG;
--SQL命令解析：按L_RETURNFLAG属性分组统计LINEITEM表所有记录L_QUANTITY的汇总值。
select L_RETURNFLAG,L_LINESTATUS,sum(L_QUANTITY) as sum_quantity from LINEITEM group by L_RETURNFLAG,L_LINESTATUS;
--SQL命令解析：按L_RETURNFLAG和L_LINESTATUS属性分组统计LINEITEM表所有记录L_QUANTITY的汇总值。

--（1）简单GROUP BY分组
select L_RETURNFLAG, L_LINESTATUS, L_SHIPINSTRUCT, 
sum(L_QUANTITY) as sum_quantity 
from LINEITEM 
group by L_RETURNFLAG, L_LINESTATUS, L_SHIPINSTRUCT;
--SQL命令解析：查询按L_RETURNFLAG、L_LINESTATUS、L_SHIPINSTRUCT三个属性直接进行分组聚集计算
--（2）ROLLUP GROUP BY分组
select L_RETURNFLAG, L_LINESTATUS, L_SHIPINSTRUCT, 
sum(L_QUANTITY) as sum_quantity 
from LINEITEM 
group by ROLLUP (L_RETURNFLAG, L_LINESTATUS, L_SHIPINSTRUCT);
--SQL命令解析：查询以L_RETURNFLAG、L_LINESTATUS、L_SHIPINSTRUCT三个属性为基础，以L_RETURNFLAG为上卷轴由细到粗进行多个分组属性聚集计算
--（3）CUBE GROUP BY分组
select L_RETURNFLAG, L_LINESTATUS, L_SHIPINSTRUCT, 
sum(L_QUANTITY) as sum_quantity 
from LINEITEM 
group by CUBE (L_RETURNFLAG, L_LINESTATUS, L_SHIPINSTRUCT)
order by L_RETURNFLAG, L_LINESTATUS, L_SHIPINSTRUCT;
--SQL命令解析：查询以L_RETURNFLAG 、 L_LINESTATUS和L_SHIPINSTRUCT三个属性为基础，为每一个分组属性组合进行分组聚集计算

--【例4-26】输出LINEITEM表订单中项目超过5项的订单号。
select L_ORDERKEY, count(*) as order_counter
from LINEITEM 
group by L_ORDERKEY 
having count(*)>=5;
--SQL命令解析：HAVING短语中的COUNT(*)>5作为分组聚集计算结果的过滤条件，对分组聚集结果进行筛选。
--【例4-27】输出LINEITEM表订单中项目超过5项并且平均销售数量在28和30之间的订单的平均销售价格。
select L_ORDERKEY, avg(L_EXTENDEDPRICE) 
from LINEITEM 
group by L_ORDERKEY 
having avg(L_QUANTITY) between 28 and 30 and count(*)>5;
--SQL命令解析：HAVING短语中可以使用输出目标列中没有的聚集函数表达式。如HAVING avg(L_QUANTITY) between 28 and 30 and count(*)>5短语中表达式avg(L_QUANTITY) between 28 and 30和count(*)>5均不是查询输出的聚集函数表达式，只用于对分组聚集计算结果进行筛选

--**排序操作**
--【例4-28】对LINEITEM表进行分组聚集计算，输出排序的查询结果。
select L_RETURNFLAG,L_LINESTATUS,
sum(L_QUANTITY) as sum_quantity 
from LINEITEM 
group by L_RETURNFLAG,L_LINESTATUS
order by L_RETURNFLAG,L_LINESTATUS;
--SQL命令解析：对查询结果按分组属性排序，第一排序属性为L_RETURNFLAG，第二排序属性为L_LINESTATUS。
select L_RETURNFLAG,L_LINESTATUS,
sum(L_QUANTITY) as sum_quantity 
from LINEITEM 
group by L_RETURNFLAG,L_LINESTATUS
order by sum(L_QUANTITY) DESC;
--按表达式排序
select L_RETURNFLAG,L_LINESTATUS,
sum(L_QUANTITY) as sum_quantity 
from LINEITEM 
group by L_RETURNFLAG,L_LINESTATUS
order by sum_quantity DESC;
--SQL命令解析：对分组聚集结果按聚集表达式别名排列

--TPCH案例查询：Q1,Q6

--**连接查询**
--笛卡尔连接
select * from NATION, REGION;
select * from nation;
select * from region;
--SQL命令解析：不指定连接条件时，将两个表的记录进行笛卡尔乘操作，任意两两连接
--【例4-29】执行NATION表和REGION表上的等值连接操作。
select * from NATION, REGION where N_REGIONKEY=R_REGIONKEY;
--SQL命令解析：NATION表的N_REGIONKEY属性为外码，参照REGION表上的主码R_REGIONKEY，连接条件设置为主、外码相等表示将两个表中REGIONKEY相同的元组连接起来作为查询结果。
select * from NATION INNER JOIN REGION on N_REGIONKEY=R_REGIONKEY;
--SQL命令解析：等值连接操作还可以采用内连接的语法结构表示

--复杂多表连接
--【例4-30】执行表CUSTOMER、ORDERS、LINEITEM上的查询操作。
select L_ORDERKEY, sum(L_EXTENDEDPRICE*(1-L_DISCOUNT)) as revenue,
       O_ORDERDATE, O_SHIPPRIORITY
from CUSTOMER, ORDERS, LINEITEM
where C_MKTSEGMENT = 'BUILDING' and C_CUSTKEY = O_CUSTKEY
      and L_ORDERKEY = O_ORDERKEY and O_ORDERDATE < '1995-03-15'
      and L_SHIPDATE > '1995-03-15'
group by L_ORDERKEY, O_ORDERDATE, O_SHIPPRIORITY
order by revenue DESC, O_ORDERDATE;
--SQL命令解析：如图4-27所示，CUSTOMER、ORDERS、LINEITEM表间存在主码-外码参照关系，CUSTOMER与ORDERS表之间的主-外码等值连接表达式为C_CUSTKEY = O_CUSTKEY，ORDERS表与LINEITEM表之间的主-外码等值连接表达式为L_ORDERKEY = O_ORDERKEY，与其他不同表上的选择条件构成复合条件，完成连接表上的分组聚集计算

--自身连接
--【例4-31】输出LINEITEM表上订单中L_SHIPINSTRUCT既包含DELIVER IN PERSON又包含TAKE BACK RETURN的订单号。
select distinct L1.L_ORDERKEY 
from LINEITEM L1, LINEITEM L2
where L1.L_SHIPINSTRUCT='DELIVER IN PERSON' 
and L2.L_SHIPINSTRUCT='TAKE BACK RETURN' 
and L1.L_ORDERKEY=L2.L_ORDERKEY;
--检验自连接结果
select *
from LINEITEM L1, LINEITEM L2
where L1.L_SHIPINSTRUCT='DELIVER IN PERSON' 
and L2.L_SHIPINSTRUCT='TAKE BACK RETURN' 
and L1.L_ORDERKEY=L2.L_ORDERKEY;
--检查特定订单
select *
from LINEITEM
where L_ORDERKEY=3;

--SQL命令解析：LINEITEM表中一个订单包含多个订单项，每个订单项包含特定的L_SHIPINSTRUCT值，存在一个订单不同的订单项L_SHIPINSTRUCT值既包含DELIVER IN PERSON又包含TAKE BACK RETURN的元组。查询在LINEITEM表中选择L_SHIPINSTRUCT值为DELIVER IN PERSON的元组，再从相同的LINEITEM表以别名的方式选择L_SHIPINSTRUCT值为TAKE BACK RETURN的元组，并且满足两个元组集上L_ORDERKE等值条件。自身连接通过别名将一个表用作多个表，然后按查询需求进行连接

--外连接
--【例4-32】输出ORDERS表与CUSTOMER表左外连接与右外连接的结果。
select O_ORDERKEY, O_CUSTKEY, C_CUSTKEY
from ORDERS left outer join CUSTOMER on O_CUSTKEY=C_CUSTKEY;
select O_ORDERKEY, O_CUSTKEY, C_CUSTKEY
from ORDERS right outer join CUSTOMER on O_CUSTKEY=C_CUSTKEY;

--多表连接
--【例4 33】在TPC-H数据库中执行PARTSUPP表与PART表、SUPPLIER表的星形连接操作。
select P_NAME,P_BRAND, S_NAME,S_NAME,PS_AVAILQTY
from PART,SUPPLIER,PARTSUPP
where PS_PARTKEY=P_PARTKEY and PS_SUPPKEY=S_SUPPKEY;
--SQL命令解析：PARTSUPP表与PART表、SUPPLIER表存在主码-外码参照关系，PARTSUPP表分别与PART表、part表、SUPPLIER表通过主、外码进行等值连接。SQL命令中FROM子句包含3个连接表名，WHERE子句中包含PARTSUPP表与2个表基于主、外码的等值连接条件，分别对应3个表间连接关系

--若使用INNER JOIN语法，则SQL命令如下所示：
select P_NAME,P_BRAND, S_NAME,S_NAME,PS_AVAILQTY
from PARTSUPP inner join PART on PS_PARTKEY=P_PARTKEY 
inner join SUPPLIER on PS_SUPPKEY=S_SUPPKEY; 

SELECT PART.P_NAME, PART.P_BRAND, SUPPLIER.S_NAME, PARTSUPP.PS_AVAILQTY
FROM   PART INNER JOIN
          PARTSUPP ON PART.P_PARTKEY = PARTSUPP.PS_PARTKEY INNER JOIN
          SUPPLIER ON PARTSUPP.PS_SUPPKEY = SUPPLIER.S_SUPPKEY

--【例4 34】在TPC-H数据库中执行雪花型连接操作。
select C_NAME,O_ORDERDATE,S_NAME,P_NAME,N_NAME,R_NAME,
L_EXTENDEDPRICE*(1-L_DISCOUNT)- PS_SUPPLYCOST * L_QUANTITY as amount
from PART, SUPPLIER, PARTSUPP, LINEITEM, ORDERS, CUSTOMER, 
NATION, REGION
where S_SUPPKEY = L_SUPPKEY
and PS_SUPPKEY = L_SUPPKEY
and PS_PARTKEY = L_PARTKEY
and P_PARTKEY = L_PARTKEY
and O_ORDERKEY = L_ORDERKEY
and C_CUSTKEY=O_CUSTKEY
and S_NATIONKEY = N_NATIONKEY
and C_NATIONKEY=N_NATIONKEY
and N_REGIONKEY=R_REGIONKEY;

--测试多表连接是否正确
select count(*) from LINEITEM;
--连接计数
select count(*)
from PART, SUPPLIER, PARTSUPP, LINEITEM, ORDERS, CUSTOMER, 
NATION, REGION
where S_SUPPKEY = L_SUPPKEY
and PS_SUPPKEY = L_SUPPKEY
and PS_PARTKEY = L_PARTKEY
and P_PARTKEY = L_PARTKEY
and O_ORDERKEY = L_ORDERKEY
and C_CUSTKEY=O_CUSTKEY
and S_NATIONKEY = N_NATIONKEY
and C_NATIONKEY=N_NATIONKEY
and N_REGIONKEY=R_REGIONKEY;
--连接计数，按TPCH模式图设置
select count(*)
from PART, SUPPLIER, PARTSUPP, LINEITEM, ORDERS, CUSTOMER, 
NATION, REGION
where PS_SUPPKEY = L_SUPPKEY
and PS_PARTKEY = L_PARTKEY
and O_ORDERKEY = L_ORDERKEY
and C_CUSTKEY=O_CUSTKEY
and PS_PARTKEY=P_PARTKEY
and PS_SUPPKEY=S_SUPPKEY
and S_NATIONKEY = N_NATIONKEY
--and C_NATIONKEY=N_NATIONKEY
and N_REGIONKEY=R_REGIONKEY;
--共享表连接限制，产生异常语义，供应商和客户国籍相同
select count(*)
from PART, SUPPLIER, PARTSUPP, LINEITEM, ORDERS, CUSTOMER, 
NATION n1, REGION r1,NATION n2, REGION r2 
where PS_SUPPKEY = L_SUPPKEY
and PS_PARTKEY = L_PARTKEY
and O_ORDERKEY = L_ORDERKEY
and C_CUSTKEY=O_CUSTKEY
and PS_PARTKEY=P_PARTKEY
and PS_SUPPKEY=S_SUPPKEY
and S_NATIONKEY = n1.N_NATIONKEY
and n1.N_REGIONKEY=r1.R_REGIONKEY
and C_NATIONKEY=n2.N_NATIONKEY
and n2.N_REGIONKEY=r2.R_REGIONKEY;
--修订查询
select C_NAME,O_ORDERDATE,S_NAME,P_NAME,n1.N_NAME,r1.R_NAME,
L_EXTENDEDPRICE*(1-L_DISCOUNT)- PS_SUPPLYCOST * L_QUANTITY as amount
from PART, SUPPLIER, PARTSUPP, LINEITEM, ORDERS, CUSTOMER, 
NATION n1, REGION r1,NATION n2, REGION r2 
where PS_SUPPKEY = L_SUPPKEY
and PS_PARTKEY = L_PARTKEY
and O_ORDERKEY = L_ORDERKEY
and C_CUSTKEY=O_CUSTKEY
and PS_PARTKEY=P_PARTKEY
and PS_SUPPKEY=S_SUPPKEY
and S_NATIONKEY = n1.N_NATIONKEY
and n1.N_REGIONKEY=r1.R_REGIONKEY
and C_NATIONKEY=n2.N_NATIONKEY
and n2.N_REGIONKEY=r2.R_REGIONKEY;

--TPCH案例查询：Q2,Q5,Q10,Q12,Q14,Q19


--**嵌套查询**
select sum(L_QUANTITY) 
from LINEITEM 
where L_PARTKEY in
                  (select P_PARTKEY
				   from PART
				   where P_CONTAINER='med case');
--1.包含IN谓词的子查询
--【例4-35】带有IN子查询的嵌套查询执行。
select P_BRAND, P_TYPE, P_SIZE, count (distinct ps_suppkey) as supplier_cnt
from PARTSUPP, PART
where P_PARTKEY = PS_PARTKEY and P_BRAND <> 'Brand#45'
and P_TYPE not like 'MEDIUM POLISHED%'
and P_SIZE in (49, 14, 23, 45, 19, 3, 36, 9)
and PS_SUPPKEY not in (
select S_SUPPKEY
from SUPPLIER
where S_COMMENT like '%Customer%Complaints%'
)
group by P_BRAND, P_TYPE, P_SIZE
order by supplier_cnt desc, P_BRAND, P_TYPE, P_SIZE;
--不相关子查询转换为连接操作
select P_BRAND, P_TYPE, P_SIZE, count (distinct PS_SUPPKEY) as supplier_cnt
from PARTSUPP, PART, SUPPLIER
where P_PARTKEY = PS_PARTKEY and S_SUPPKEY=PS_SUPPKEY
and P_BRAND <> 'Brand#45' and P_TYPE not like 'MEDIUM POLISHED%'
and P_SIZE in (49, 14, 23, 45, 19, 3, 36, 9) 
and S_COMMENT not like '%Customer%Complaints%'
group by P_BRAND, P_TYPE, P_SIZE
order by supplier_cnt desc, P_BRAND, P_TYPE, P_SIZE;

--【例4-36】通过IN子查询完成CUSTOMER、NATION与REGION表间的查询，统计ASIA地区顾客的数量。
SELECT count(*) FROM CUSTOMER WHERE C_NATIONKEY IN
       (SELECT N_NATIONKEY FROM NATION WHERE N_REGIONKEY IN
               (SELECT R_REGIONKEY FROM REGION
WHERE R_NAME='ASIA'));
--当前嵌套子查询可以转换为连接查询：
select count(*) 
from CUSTOMER, NATION, REGION
where C_NATIONKEY=N_NATIONKEY and N_REGIONKEY=R_REGIONKEY
and R_NAME='ASIA';

select * from nation,region where N_REGIONKEY+R_REGIONKEY=8 order by N_NAME;

--2.带有比较运算符的相关子查询
--【例4-37】带有=比较运算符的子查询。
select S_ACCTBAL, S_NAME, N_NAME, P_PARTKEY, P_MFGR, S_ADDRESS, S_PHONE, S_COMMENT
from PART, SUPPLIER, PARTSUPP, NATION, REGION
where P_PARTKEY = PS_PARTKEY and S_SUPPKEY = PS_SUPPKEY
and P_SIZE = 15 and P_TYPE like '%BRASS'
and S_NATIONKEY = N_NATIONKEY and N_REGIONKEY = R_REGIONKEY
and R_NAME = 'EUROPE' 
and PS_SUPPLYCOST = (
select min(PS_SUPPLYCOST)
from PARTSUPP, SUPPLIER, NATION, REGION
where P_PARTKEY = PS_PARTKEY and S_SUPPKEY = PS_SUPPKEY
and S_NATIONKEY = N_NATIONKEY and N_REGIONKEY = R_REGIONKEY
and R_NAME = 'EUROPE'
)
order by S_ACCTBAL desc, N_NAME, S_NAME, P_PARTKEY;

select S_ACCTBAL, S_NAME, N_NAME, P_PARTKEY, P_MFGR, S_ADDRESS, S_PHONE, S_COMMENT
from PART, SUPPLIER, PARTSUPP, NATION, REGION
where P_PARTKEY = PS_PARTKEY and S_SUPPKEY = PS_SUPPKEY
and P_SIZE = 15 and P_TYPE like '%BRASS'
and S_NATIONKEY = N_NATIONKEY and N_REGIONKEY = R_REGIONKEY
and R_NAME = 'EUROPE' 
and PS_SUPPLYCOST = (
select min(PS_SUPPLYCOST)
from PARTSUPP, SUPPLIER, NATION, REGION,PART
where P_PARTKEY = PS_PARTKEY and S_SUPPKEY = PS_SUPPKEY
and S_NATIONKEY = N_NATIONKEY and N_REGIONKEY = R_REGIONKEY
and R_NAME = 'EUROPE'
)
order by S_ACCTBAL desc, N_NAME, S_NAME, P_PARTKEY;

--SUPPLIER,  NATION, REGION因为是输出属性，连接需要出现在父查询中，父查询中R_NAME = 'EUROPE'条件与子查询相同可去掉
select S_ACCTBAL, S_NAME, N_NAME, P_PARTKEY, P_MFGR, S_ADDRESS, S_PHONE, S_COMMENT
from PART,PARTSUPP, SUPPLIER,  NATION, REGION
where P_PARTKEY = PS_PARTKEY and S_SUPPKEY = PS_SUPPKEY
and P_SIZE = 15 and P_TYPE like '%BRASS'
and S_NATIONKEY = N_NATIONKEY and N_REGIONKEY = R_REGIONKEY
--and R_NAME = 'EUROPE' 
and PS_SUPPLYCOST = (
select min(PS_SUPPLYCOST)
from PARTSUPP, SUPPLIER, NATION, REGION
where P_PARTKEY = PS_PARTKEY and S_SUPPKEY = PS_SUPPKEY
and S_NATIONKEY = N_NATIONKEY and N_REGIONKEY = R_REGIONKEY
and R_NAME = 'EUROPE'
)
order by S_ACCTBAL desc, N_NAME, S_NAME, P_PARTKEY;

--改写后的查询如下：
WITH ps_supplycostTable (min_supplycost, partkey)
AS
(
    select min(PS_SUPPLYCOST) as min_ps_supplycost, P_PARTKEY
    from PARTSUPP, SUPPLIER, NATION, REGION, PART
    where P_PARTKEY = PS_PARTKEY and S_SUPPKEY = PS_SUPPKEY
and P_SIZE = 15 and P_TYPE like '%BRASS'
and S_NATIONKEY = N_NATIONKEY and N_REGIONKEY = R_REGIONKEY 
and R_NAME = 'EUROPE'
    group by P_PARTKEY 
)
select
S_ACCTBAL, S_NAME, N_NAME, P_PARTKEY, PS_SUPPLYCOST, P_MFGR, S_ADDRESS, S_PHONE, S_COMMENT
from PART, SUPPLIER, PARTSUPP, NATION, REGION, ps_supplycostTable
where P_PARTKEY = PS_PARTKEY and S_SUPPKEY = PS_SUPPKEY
and PARTKEY=P_PARTKEY   --增加与派生表partkey连接表达式
and PS_SUPPLYCOST =min_supplycost   --增加与派生表supplycost等值表达式
and P_SIZE = 15 and P_TYPE like '%BRASS'
and S_NATIONKEY = N_NATIONKEY and N_REGIONKEY = R_REGIONKEY
and R_NAME = 'EUROPE' 
order by S_ACCTBAL DESC, N_NAME, S_NAME, P_PARTKEY;

--3.带有ANY或ALL谓词的子查询
--【例4-38】统计LINEITEM表中L_EXTENDEDPRICE大于任何一个中国顾客订单L_EXTENDEDPRICE记录的数量。
select count(*) from LINEITEM where L_EXTENDEDPRICE>ANY(
select L_EXTENDEDPRICE from LINEITEM, SUPPLIER, NATION
where L_SUPPKEY=S_SUPPKEY and S_NATIONKEY=N_NATIONKEY 
and N_NAME='CHINA');
-->ANY子查询可以改写为子查询中的最小值，即：
select count(*) from LINEITEM where L_EXTENDEDPRICE>(
select min(L_EXTENDEDPRICE) from LINEITEM, SUPPLIER, NATION
where L_SUPPKEY=S_SUPPKEY and S_NATIONKEY=N_NATIONKEY 
and N_NAME='CHINA');

--4.带有EXIST谓词的子查询
--【例4-39】分析下面查询exists子查询的作用。
select O_ORDERPRIORITY, count(*) as order_count
from ORDERS
where O_ORDERDATE >= '1993-07-01' 
and O_ORDERDATE < DATEADD(MONTH, 3,'1993-07-01' )
and exists (
select *
from LINEITEM
where L_ORDERKEY = O_ORDERKEY and L_COMMITDATE < L_RECEIPTDATE )
group by O_ORDERPRIORITY
order by O_ORDERPRIORITY;
--该查询可以改写为使用连接运算的SQL语句：
select O_ORDERPRIORITY, count (distinct L_ORDERKEY) as order_count
from ORDERS, LINEITEM
where O_ORDERKEY=L_ORDERKEY and O_ORDERDATE >= '1993-07-01' 
and O_ORDERDATE < DATEADD (MONTH, 3,'1993-07-01')
and L_COMMITDATE < L_RECEIPTDATE 
group by O_ORDERPRIORITY
order by O_ORDERPRIORITY;
--【例4-40】查询在没有购买任何商品的顾客的数量。
select count(C_CUSTKEY)
from CUSTOMER
where not exists(
select * from ORDERS, LINEITEM
where L_ORDERKEY=O_ORDERKEY and O_CUSTKEY=C_CUSTKEY
);
--右连接判断
select count(C_CUSTKEY)
from ORDERS right outer join CUSTOMER on O_CUSTKEY=C_CUSTKEY
where O_ORDERKEY is NULL;

--【例4-41】查询在1993年7月起的3个月内没有购买任何商品的顾客的数量。
select count(C_CUSTKEY)
from CUSTOMER
where not exists(
select * from ORDERS
where O_CUSTKEY=C_CUSTKEY 
and O_ORDERDATE between '1993-07-01' and DATEADD(MONTH,3,'1993-07-01')
);
--查询的结果还可以通过集合操作来验证。注：查看记录条数
select C_CUSTKEY from CUSTOMER
except
select distinct O_CUSTKEY from ORDERS, CUSTOMER 
where O_CUSTKEY=C_CUSTKEY 
and O_ORDERDATE between '1993-07-01' and DATEADD(MONTH,3,'1993-07-01');

--**四、集合查询**
--集合并运算
--【例4-42】查询LINEITEM表中L_SHIPMODE模式为AIR或AIR REG，以及L_SHIPINSTRUCT方式为DELIVER IN PERSON的订单号。
select distinct L_ORDERKEY from LINEITEM
where L_SHIPMODE in ('AIR','AIR REG')
union
select distinct L_ORDERKEY from LINEITEM
where L_SHIPINSTRUCT ='DELIVER IN PERSON'
order by L_ORDERKEY;

--集合操作自动去重，不加distinct语句结果相同
select L_ORDERKEY from LINEITEM
where L_SHIPMODE in ('AIR','AIR REG')
union
select L_ORDERKEY from LINEITEM
where L_SHIPINSTRUCT ='DELIVER IN PERSON'
order by L_ORDERKEY;


select distinct L_ORDERKEY from LINEITEM
where L_SHIPMODE in ('AIR','AIR REG')
union all
select distinct L_ORDERKEY from LINEITEM
where L_SHIPINSTRUCT ='DELIVER IN PERSON'
order by L_ORDERKEY;
--增加排序语句以便比较查询结果中是否存在重复值

--当在相同的表上执行union操作时，可以将union操作转换为选择谓词的或or表达式，如：
select distinct L_ORDERKEY from LINEITEM
where L_SHIPMODE in ('AIR','AIR REG') or L_SHIPINSTRUCT ='DELIVER IN PERSON'
order by L_ORDERKEY;

--集合交运算
--【例4-43】查询CONTAINER为WRAP BOX、MED CASE、JUMBO PACK，并且PS_AVAILQTY低于1000的产品名称。
select P_NAME from PART
where P_CONTAINER in ('WRAP BOX','MED CASE','JUMBO PACK')
intersect
select P_NAME from PART, PARTSUPP
where P_PARTKEY=PS_PARTKEY and PS_AVAILQTY<1000;

--本例可以改写为基于连接操作的查询，但需要注意的是P_PARTKEY在输出时需要通过distinct消除连接操作产生的重复值，改写的SQL命令如下：
select distinct P_NAME from PART, PARTSUPP
where P_PARTKEY=PS_PARTKEY and PS_AVAILQTY<1000 
and P_CONTAINER in ('WRAP BOX','MED CASE','JUMBO PACK')
order by P_NAME;

--集合差运算
--【例4-44】查询ORDERS表中O_ORDERPRIORITY类型为1-URGENT和2-HIGH，但O_ORDERSTATUS状态不为F的订单号。
Select O_ORDERKEY from ORDERS
where O_ORDERPRIORITY in ('1-URGENT','2-HIGH')
except
select O_ORDERKEY from ORDERS
where O_ORDERSTATUS='F';

select O_ORDERKEY from ORDERS
where O_ORDERPRIORITY in ('1-URGENT','2-HIGH') and not O_ORDERSTATUS='F';

--多值列集合差运算
--【例4-45】查询LINEITEM表中执行L_SHIPMODE模式为AIR或AIR REG，但L_SHIPINSTRUCT方式不是DELIVER IN PERSON的订单号。
--按查询要求将查询条件L_SHIPMODE模式为AIR或AIR REG作为一个集合，查询条件L_SHIPINSTRUCT方式是DELIVER IN PERSON作为另一个集合，然后求集合差操作。查询命令如下：
select L_ORDERKEY from LINEITEM
where L_SHIPMODE in ('AIR','REG AIR')
except
select L_ORDERKEY from LINEITEM
where L_SHIPINSTRUCT ='DELIVER IN PERSON';
--当改写此查询时，在输出的L_ORDERKEY前面需要手工增加distinct语句对结果集去重，差操作集合谓词条件改为L_SHIPINSTRUCT! ='DELIVER IN PERSON'，查询命令如下：
select distinct L_ORDERKEY from LINEITEM
where L_SHIPMODE in ('AIR','REG AIR') and L_SHIPINSTRUCT! ='DELIVER IN PERSON';
--数据分析原因
select * from lineitem;
--改写成自连接方法，结果不一致
select distinct L1.L_ORDERKEY from LINEITEM L1,LINEITEM L2
where L1.L_SHIPMODE in ('AIR','REG AIR') and L2.L_SHIPINSTRUCT! ='DELIVER IN PERSON'
and L1.L_ORDERKEY=L2.L_ORDERKEY;
--查数据，找原因
select L1.L_ORDERKEY,L1.L_SHIPMODE,L2.L_SHIPINSTRUCT from LINEITEM L1,LINEITEM L2
where L1.L_SHIPMODE in ('AIR','REG AIR') and L2.L_SHIPINSTRUCT! ='DELIVER IN PERSON'
and L1.L_ORDERKEY=L2.L_ORDERKEY;
--表示包含满足条件L_SHIPMODE in ('AIR','REG AIR')但不满足条件L_SHIPINSTRUCT ='DELIVER IN PERSON'的记录，缺乏一票否决机制
select L1.L_ORDERKEY,L1.L_SHIPMODE,L2.L_SHIPINSTRUCT from LINEITEM L1,LINEITEM L2
where L1.L_ORDERKEY=L2.L_ORDERKEY and L1.L_ORDERKEY=1;
--只要包含条件L_SHIPMODE in ('AIR','REG AIR')且条件L_SHIPINSTRUCT ='DELIVER IN PERSON'存在则该记录不满足条件
select distinct L1.L_ORDERKEY from LINEITEM L1,LINEITEM L2
where L1.L_SHIPMODE in ('AIR','REG AIR') and L2.L_SHIPINSTRUCT='DELIVER IN PERSON'
and L1.L_ORDERKEY=L2.L_ORDERKEY order by L1.L_ORDERKEY;
--不满足条件的记录号
--第一种改写方式
Select distinct L_ORDERKEY from LINEITEM
where L_SHIPMODE in ('AIR','REG AIR') and L_ORDERKEY not in (
select L_ORDERKEY from LINEITEM 
where L_SHIPINSTRUCT ='DELIVER IN PERSON');
--第二种改写方法
Select distinct L_ORDERKEY from LINEITEM L1
where L_SHIPMODE in ('AIR','REG AIR') and not exists (
select * from LINEITEM L2 where L1.L_ORDERKEY=L2.L_ORDERKEY 
and L_SHIPINSTRUCT ='DELIVER IN PERSON');

--**五、基于派生表查询**
--【例4-46】分析下面查询中派生表的作用。
select C_COUNT, count (*) as custdist
from (
select C_CUSTKEY, count (O_ORDERKEY)
from CUSTOMER left outer join ORDERS on C_CUSTKEY = O_CUSTKEY
and O_COMMENT not like '%special%requests%'
group by C_CUSTKEY
) as C_ORDERS (C_CUSTKEY, C_COUNT)
group by C_COUNT
order by CUSTDIST desc, C_COUNT desc;
--with改写
WITH C_ORDERS (C_CUSTKEY, C_COUNT)
AS (
select C_CUSTKEY, count (O_ORDERKEY)
from CUSTOMER left outer join ORDERS on C_CUSTKEY = O_CUSTKEY
and O_COMMENT not like '%special%requests%'
group by C_CUSTKEY)
select C_COUNT, count (*) as custdist
from C_ORDERS group by C_COUNT
order by CUSTDIST desc, C_COUNT desc;

--【例4-47】通过ROW_NUMBER函数对以C_CUSTKEY分组统计的订单数量按大小排列和C_CUSTKEY排序并分配行号。
select C_CUSTKEY, count (*) AS counter, 
ROW_NUMBER() over (ORDER BY counter) as RowNum
from ORDERS, CUSTOMER 
where O_CUSTKEY=C_CUSTKEY
group by C_CUSTKEY
order by counter, C_CUSTKEY;
--通过WITH表达式解决问题
WITH custkey_counter(CUSTKEY, counter) 
AS (
select C_CUSTKEY, count (*) 
from ORDERS, CUSTOMER 
where O_CUSTKEY=C_CUSTKEY
group by C_CUSTKEY)
select CUSTKEY, counter, ROW_NUMBER() over (order by counter) as rownum 
from custkey_counter 
order by counter, CUSTKEY;

--TPCH案例：掌握带有子查询的SQL命令使用方法

--插入元组，先复制一个实验表
drop table if exists region_test;
select * into region_test from region;
select * from region_test;
--插入新记录
insert into region_test(R_REGIONKEY, R_NAME)
values (5,'NORTH AMERICA');
insert into region_test
values(6,'SOURCE AMERICA',null);
--查看插入记录
select * from region_test;

--插入子查询结果
--先创建表
drop table if exists custkey_counter;
create table custkey_counter(CUSTKEY int, counter int);
--将查询结果插入创建的表中
insert into custkey_counter
select C_CUSTKEY, count (*) 
from ORDERS, CUSTOMER 
where O_CUSTKEY=C_CUSTKEY
group by C_CUSTKEY;
--查看结果
select CUSTKEY, counter, ROW_NUMBER() over (order by counter) as rownum 
from custkey_counter 
order by counter, CUSTKEY;
--分组聚集结果插入表
drop table if exists custkey_counter1;
select C_CUSTKEY, count(*) as counter into custkey_counter1
from ORDERS, CUSTOMER 
where O_CUSTKEY=C_CUSTKEY
group by C_CUSTKEY;
--查看结果
select * from custkey_counter1;

--Update修改操作
select * from region_test;
update region_test set R_COMMENT='including Canada and USA' 
where R_NAME='NORTH AMERICA';
select * from region_test;
--恢复原始空值
update region_test set R_COMMENT=Null 
where R_NAME='NORTH AMERICA';

--按条件查询
update ORDERS set O_ORDERPRIORITY ='1-URGENT' 
from
(select L_ORDERKEY, 
avg (DATEDIFF(DAY, L_COMMITDATE,L_SHIPDATE)) as avg_delay
from LINEITEM
group by L_ORDERKEY 
having avg(DATEDIFF(DAY, L_COMMITDATE,L_SHIPDATE))>60) as order_delay
where L_ORDERKEY=O_ORDERKEY;
--通过in子查询构造复合更新条件
update SUPPLIER set S_ACCTBAL=S_ACCTBAL*1.05
where S_NATIONKEY in (
select N_NATIONKEY from NATION where N_NAME='INDONESIA');


--PS表复合主键单主键处理
--PS表复合主键转换为单主键，类似的方法转换order表与lineitem表主键surrogate：
--创建PS辅助表，用于增加自增字段作为单属性主键
--创建辅助表PARTSUPP_S，从PARTSUPP表中加载数据
drop table if exists PARTSUPP_S;
select * into PARTSUPP_S from PARTSUPP;
--修改表结构，增加一个自增字段作为新的单属性主键
alter table PARTSUPP_S add PS_KEY int Identity(1,1);
select * from PARTSUPP_S;
--创建Lineitem辅助表，用于增加单外键
--加载LINEITEM表记录到辅助表LINEITEM_S中
drop table if exists LINEITEM_S;
select * into LINEITEM_S from LINEITEM;
--增加新的字段作为单属性外键，注意不是自增字段，外键值需要通过连接操作更新
alter table LINEITEM_S add L_KEY int;
--测试创建的辅助表，查看记录及新增的字段
select top 20 * from PARTSUPP_S order by PS_KEY;
select top 20 * from LINEITEM_S;
--用复合主外键连接，用PS表单主键值更新L表单外键值
update LINEITEM_S set L_KEY =PS_KEY
from PARTSUPP_S
where LINEITEM_S.l_partkey=PARTSUPP_S.ps_partkey and LINEITEM_S.l_suppkey=PARTSUPP_S.ps_suppkey;
--测试新的单属性主外键是否与原来的双属性主外键等价
--使用双属性主外键连接并输出连接记录数量
select count(*) from LINEITEM,PARTSUPP
where L_PARTKEY=PS_PARTKEY and L_SUPPKEY=PS_SUPPKEY;
--使用单属性主外键连接并输出连接记录数量
select count(*) from LINEITEM_S,PARTSUPP_S
where L_KEY=PS_KEY;


--delete删除命令
删除表中全部记录
select * from custkey_counter1;
delete from custkey_counter1;
select * from custkey_counter1;
--恢复删除表，insert入空表
insert into custkey_counter1
select C_CUSTKEY, count(*) as counter 
from ORDERS, CUSTOMER 
where O_CUSTKEY=C_CUSTKEY
group by C_CUSTKEY;
--条件删除
select * from region_test;
delete from region_test WHERE R_NAME='SOURCE AMERICA';
--关联表记录删除
delete from LINEITEM
where L_ORDERKEY in (
select O_ORDERKEY from ORDERS where O_ORDERSTATUS='F');

--事务
select * from PARTSUPP where PS_PARTKEY=6 and PS_SUPPKEY=507;
select * from LINEITEM where L_ORDERKEY=578 and L_LINENUMBER=3;
begin transaction orderitem
update PARTSUPP set PS_AVAILQTY=PS_AVAILQTY-100
where PS_PARTKEY=6 and PS_SUPPKEY=507;
insert into LINEITEM (L_ORDERKEY, L_LINENUMBER, L_PARTKEY, L_SUPPKEY, L_QUANTITY) values(578,3,6,507,100);
commit transaction
--查询及删除插入的记录
select * from LINEITEM where L_ORDERKEY=578 and L_LINENUMBER=3;
delete from LINEITEM where L_ORDERKEY=578 and L_LINENUMBER=3;
--视图的使用
drop view if exists revenue;
create view revenue (SUPPLIER_NO, TOTAL_REVENUE) as
select L_SUPPKEY, sum(L_EXTENDEDPRICE*(1-L_DISCOUNT))
from LINEITEM
where L_SHIPDATE>='1996-01-01' and L_SHIPDATE<DATEADD(MONTH,3,'1996-01-01' )
group by L_SUPPKEY;

select * from revenue;

select S_SUPPKEY, S_NAME, S_ADDRESS, S_PHONE, TOTAL_REVENUE
from SUPPLIER, REVENUE
where S_SUPPKEY=SUPPLIER_NO and TOTAL_REVENUE = (
select max(TOTAL_REVENUE)
from REVENUE )
order by S_SUPPKEY;

drop view REVENUE;

--视图改写
WITH revenue (supplier_no, total_revenue) as (
select l_suppkey, sum(l_extendedprice*(1-l_discount))
from lineitem
where l_shipdate>='1996-01-01' and l_shipdate<DATEADD(MONTH,3,'1996-01-01' )
group by l_suppkey)
select s_suppkey, s_name, s_address, s_phone, total_revenue
from supplier, revenue
where s_suppkey=supplier_no and total_revenue = (
select max(total_revenue)
from revenue )
order by s_suppkey;

--TPCH连接视图
--思考：共享表连接可能带来的异常限制
drop view if exists TPCH_view;
create view TPCH_view as
select *
from PART,SUPPLIER,PARTSUPP,LINEITEM,ORDERS,CUSTOMER,NATION,REGION
where S_SUPPKEY = L_SUPPKEY
and PS_SUPPKEY = L_SUPPKEY
and PS_PARTKEY = L_PARTKEY
and P_PARTKEY = L_PARTKEY
and O_ORDERKEY = L_ORDERKEY
and C_CUSTKEY=O_CUSTKEY
and S_NATIONKEY = N_NATIONKEY
and C_NATIONKEY=N_NATIONKEY
and N_REGIONKEY=R_REGIONKEY;
select * from TPCH_view;
--尝试使用别名nation与region完成连接
drop view if exists TPCH_view0;
create view TPCH_view0 as
select *
from PART,SUPPLIER,PARTSUPP,LINEITEM,ORDERS,CUSTOMER,NATION n1,REGION r1,NATION n2,REGION r2
where S_SUPPKEY = L_SUPPKEY
and PS_SUPPKEY = L_SUPPKEY
and PS_PARTKEY = L_PARTKEY
and P_PARTKEY = L_PARTKEY
and O_ORDERKEY = L_ORDERKEY
and C_CUSTKEY=O_CUSTKEY
and S_NATIONKEY = n1.N_NATIONKEY
and C_NATIONKEY=n2.N_NATIONKEY
and n1.N_REGIONKEY=r1.R_REGIONKEY
and n2.N_REGIONKEY=r2.R_REGIONKEY
;
--违背视图中列名唯一性约束


--解决方案1：在视图中只保留supplier或customer表其中之一与nation和region的连接关系
drop view if exists TPCH_view1;
create view TPCH_view1 as
select *
from PARTSUPP,LINEITEM,ORDERS,CUSTOMER,PART,SUPPLIER,NATION,REGION
where PS_PARTKEY = L_PARTKEY
and PS_SUPPKEY=L_SUPPKEY
and O_ORDERKEY = L_ORDERKEY
and C_CUSTKEY=O_CUSTKEY
and P_PARTKEY = PS_PARTKEY
and S_SUPPKEY = PS_SUPPKEY
and S_NATIONKEY = N_NATIONKEY
--and C_NATIONKEY=N_NATIONKEY
and N_REGIONKEY=R_REGIONKEY
;
--解决方案2：通过派生表创建nation1与region1表
drop view if exists TPCH_view2;
create view TPCH_view2 as
select *
from PARTSUPP,LINEITEM,ORDERS,CUSTOMER,PART,SUPPLIER,NATION,REGION,
(select * from NATION) nation1(n1_nationkey,n1_name,n1_regionkey,n1_comment),
(select * from region) region1(r1_regionkey,r1_name,r1_comment)
where PS_PARTKEY = L_PARTKEY
and PS_SUPPKEY=L_SUPPKEY
and O_ORDERKEY = L_ORDERKEY
and C_CUSTKEY=O_CUSTKEY
and P_PARTKEY = PS_PARTKEY
and S_SUPPKEY = PS_SUPPKEY
and S_NATIONKEY = N_NATIONKEY
and N_REGIONKEY=R_REGIONKEY
and C_NATIONKEY=N1_NATIONKEY
and n1_regionkey=r1_regionkey
;
--解决方案3：通过with创建nation1与region1表后直接使用
drop view if exists TPCH_view3;
create view TPCH_view3 as
with nation1(n1_nationkey,n1_name,n1_regionkey,n1_comment)
as (select * from NATION),--注意：第2个with定义缺省with，但两个公共表定义之间用逗号分隔
region1(r1_regionkey,r1_name,r1_comment)
as (select * from region)
select *
from PARTSUPP,LINEITEM,ORDERS,CUSTOMER,PART,SUPPLIER,NATION,REGION,nation1,region1
where PS_PARTKEY = L_PARTKEY
and PS_SUPPKEY=L_SUPPKEY
and O_ORDERKEY = L_ORDERKEY
and C_CUSTKEY=O_CUSTKEY
and P_PARTKEY = PS_PARTKEY
and S_SUPPKEY = PS_SUPPKEY
and S_NATIONKEY = N_NATIONKEY
and N_REGIONKEY=R_REGIONKEY
and C_NATIONKEY=N1_NATIONKEY
and n1_regionkey=r1_regionkey
;
--验证几种视图查询结果的正确性
select count(*) from TPCH_view;
select count(*) from TPCH_view1;
select count(*) from TPCH_view2;
select count(*) from TPCH_view3;
select count(*) from LINEITEM;
--经验总结：视图中使用别名产生同名字段问题

--删除视图
drop view revenue;

--视图查询
select count(*) from TPCH_view1 
where P_CONTAINER in ('WRAP BOX','MED CASE','JUMBO PACK');
--SQL解析：根据视图定义与视图上的查询转换成下面等价的SQL命令：
select count(*)
from PARTSUPP,LINEITEM,ORDERS,CUSTOMER,PART,SUPPLIER,NATION,REGION
where PS_PARTKEY = L_PARTKEY
and PS_SUPPKEY=L_SUPPKEY
and O_ORDERKEY = L_ORDERKEY
and C_CUSTKEY=O_CUSTKEY
and P_PARTKEY = PS_PARTKEY
and S_SUPPKEY = PS_SUPPKEY
and S_NATIONKEY = N_NATIONKEY
--and C_NATIONKEY=N_NATIONKEY
and N_REGIONKEY=R_REGIONKEY
and P_CONTAINER in ('WRAP BOX','MED CASE','JUMBO PACK');

select count(*)
from PART,LINEITEM
where P_PARTKEY = L_PARTKEY
and P_CONTAINER in ('WRAP BOX','MED CASE','JUMBO PACK');
--思考：BI工具关系上的查询可能产生冗余计算问题
--1.单表上的视图更新
--【例4-61】分析下面视图上支持的更新操作。
drop view if exists order_vital_items;
create view order_vital_items as
select O_ORDERKEY, O_ORDERSTATUS, O_TOTALPRICE,
O_ORDERDATE, O_ORDERPRIORITY 
from ORDERS 
where O_ORDERPRIORITY in ('1-URGENT','2-HIGH');
select * from order_vital_items where O_ORDERKEY=8 ;
select * from ORDERS where O_ORDERKEY=8 ;
delete from orders where O_ORDERKEY=8 ;
--可插入，但视图中不显示
insert into order_vital_items values(8,'F',23453,'1998-03-23','3-MEDIUM');
--视图更新等价SQL命令
update order_vital_items set O_ORDERPRIORITY='3-MEDIUM' where O_ORDERDATE='1994-07-10';
update ORDERS set O_ORDERPRIORITY='3-MEDIUM' 
where O_ORDERDATE='1994-07-10' and O_ORDERPRIORITY in ('1-URGENT','2-HIGH');

--2.单表上的聚集视图更新
--【例4-62】分析下面视图上支持的更新操作。
--视图ORDERPRIORITY_count为ORDERS表上分组聚集结果集。
drop view if exists ORDERPRIORITY_count;
create view ORDERPRIORITY_count as 
select O_ORDERPRIORITY, count(*) as counter
from ORDERS
group by O_ORDERPRIORITY;
select * from ORDERPRIORITY_count;
--不支持对聚集记录的更新操作
insert into ORDERPRIORITY_count values('6-VERY LOW',50678);
update ORDERPRIORITY_count set counter=50678 
where O_ORDERPRIORITY='1-URGENT';
delete from ORDERPRIORITY_count where O_ORDERPRIORITY='1-URGENT';
--3.多表连接视图更新
--【例4-63】分析下面视图上支持的更新操作。
--创建NATION与REGION基本表的连接视图nation_region。
drop view if exists nation_region;
create view nation_region as
select * from NATION, REGION where N_REGIONKEY=R_REGIONKEY;
select * from nation_region;
--插入操作被拒绝，因为视图中的记录来自两个基本表，无法满足基本表上的主码-外码参照关系。
insert into nation_region values(25,'USA',1,1,'AMERICA');
--删除操作被拒绝，视图对应的NATION表与REGION表上存在主码-外码参照关系，不允许通过视图删除记录。
delete from nation_region where R_NAME='ASIA';
delete from nation_region where N_NAME='ALGERIA';
--修改操作可执行。第一条update命令修改视图中NATION表属性，转换为在NATION表上的update命令update NATION set N_NAME='ALG' where N_NAME='ALGERIA';
update nation_region set N_NAME='ALG' where N_NAME='ALGERIA';
--第二条update命令修改视图中REGION表属性，等价的SQL命令为update REGION set R_NAME='AFR' where R_NAME='AFRICA';更新后视图中显示多条记录相关列被更新，实际对应REGION表中一条记录更新。
update nation_region set R_NAME='AFR' where R_NAME='AFRICA';
update nation_region set R_NAME='AME'  where R_NAME='AMERICA' and N_NAME='CANADA' ;

select * from NATION;
select * from REGION;
select * from nation_region;
--恢复原始数据
update nation set N_NAME='ALGERIA' where N_NAME='ALG';
update region set R_NAME='AFRICA' where R_NAME='AFR';

--1.解析JSON数据
DECLARE @jsonVariable NVARCHAR(MAX)
SET @jsonVariable = N'[  
        {  
		  "id":0,
          "Location": {  
            "Horizontal_region":"Eastern hemisphere",  
            "Vertical_region":"Sourthern Hemisphere"  
          },  
          "Population_B":0.78,  
          "Area_million_km2": 30.37
        },  
        {  
		  "id":1,
          "Location": {  
            "Horizontal_region":"Western hemisphere",  
            "Vertical_region":"Northern Hemisphere"  
          },  
          "Population_B":0.822,  
          "Area_million_km2": 42.07
        },
		{  
		  "id":2,
          "Location": {  
            "Horizontal_region":"Eastern hemisphere",  
            "Vertical_region":"Northern Hemisphere"  
          },  
          "Population_B":3.8,  
          "Area_million_km2": 44
        },
		{  
		  "id":3,
          "Location": {  
            "Horizontal_region":"Western hemisphere",  
            "Vertical_region":"Northern Hemisphere"  
          },  
          "Population_B":0.8,  
          "Area_million_km2":10.16
        },
		{  
		  "id":4,
          "Location": {  
            "Horizontal_region":"Eastern hemisphere",  
            "Vertical_region":"Northern Hemisphere"  
          },  
          "Population_B":0.36,  
          "Area_million_km2": 6.5
        }  
  ]'
SELECT *  
FROM OPENJSON(@jsonVariable)  
  WITH (id int 'strict $.id',  
        Location_Horizontal nvarchar(50) '$.Location.Horizontal_region', 
		Location_Vertical nvarchar(50) '$.Location.Vertical_region',  
        Population_B real, Area_million_km2 real);
--2.JSON数据转换为关系数据
drop table if exists region_json;
SELECT * into region_json 
FROM OPENJSON(@jsonVariable)  
  WITH (id int 'strict $.id',  
        Location_Horizontal nvarchar(50) '$.Location.Horizontal_region', 
		Location_Vertical nvarchar(50) '$.Location.Vertical_region',  
        Population_B real, Area_million_km2 real);
select * from region_json;
--3.JSON数据更新为关系数据列
--（1）在REGION表中增加一个JSON数据列。
drop table if exists region_json;
select * into region_json from region;
alter table region_json add json_col NVARCHAR(MAX);
--（2）将JSON数据更新到JSON列中。
DECLARE @jsonVariable0 NVARCHAR(MAX)
SET @jsonVariable0 = '{"id":0,"Location":{"Horizontal_region":"Eastern hemisphere",
"Vertical_region":"Sourthern Hemisphere"}, 
"Population_B":0.78,"Area_million_km2":30.37}'
DECLARE @jsonVariable1 NVARCHAR(MAX)
SET @jsonVariable1 ='{"id":1,"Location":{"Horizontal_region":"Western hemisphere",
 "Vertical_region":"Northern Hemisphere"}, 
"Population_B":0.822,"Area_million_km2":42.07}'
DECLARE @jsonVariable2 NVARCHAR(MAX)
SET @jsonVariable2 = '{"id":2,"Location":{"Horizontal_region":"Eastern hemisphere", 
"Vertical_region":"Northern Hemisphere"}, 
"Population_B":3.8,"Area_million_km2":44}'
DECLARE @jsonVariable3 NVARCHAR(MAX)
SET @jsonVariable3 = '{"id":3,"Location":{"Horizontal_region":"Western hemisphere",
"Vertical_region":"Northern Hemisphere"},
"Population_B":0.8,"Area_million_km2":10.16}'
DECLARE @jsonVariable4 NVARCHAR(MAX)
SET @jsonVariable4 = '{"id":4,"Location":{"Horizontal_region":"Eastern hemisphere",
"Vertical_region":"Northern Hemisphere"},
"Population_B":0.36,"Area_million_km2":6.5}'
update region_json set json_col=@jsonVariable0 where r_regionkey=0;
update region_json set json_col=@jsonVariable1 where r_regionkey=1;
update region_json set json_col=@jsonVariable2 where r_regionkey=2;
update region_json set json_col=@jsonVariable3 where r_regionkey=3;
update region_json set json_col=@jsonVariable4 where r_regionkey=4;
select * from region_json;
--（3）查看表中关系与JSON数据。
SELECT  
r_name,
JSON_VALUE(json_col, '$.Location.Horizontal_region') AS Loca_H,
JSON_VALUE(json_col, '$.Location.Vertical_region') AS Loca_V,
JSON_VALUE(json_col, '$.Population_B') AS People, 
JSON_VALUE(json_col, '$.Area_million_km2') AS Area
FROM region_json;
select * from region_json;
--4.在SQL查询中使用关系和JSON数据
SELECT R.R_NAME, Detail.Loca_H, Detail.Loca_V, Detail.People,Detail.Area
FROM   region_json AS R  
          CROSS APPLY  
     OPENJSON (R.json_col)  
           WITH (  
              Loca_H   varchar(50) N'$.Location.Horizontal_region',   
              Loca_V   varchar(50) N'$.Location.Vertical_region',  
              People   real        N'$.Population_B',   
              Area     real        N'$.Area_million_km2'  
           )  
  AS Detail  
WHERE ISJSON(json_col)>0 AND Detail.People>0.8
ORDER BY JSON_VALUE(json_col,'$.Area_million_km2');
--5. JSON索引
--当查询中使用JSON值作为过滤条件查询时，可以为JSON值创建索引。
SELECT R_NAME,
JSON_VALUE(json_col, '$.Location.Horizontal_region') AS Loca_H,
JSON_VALUE(json_col, '$.Location.Vertical_region') AS Loca_V,
JSON_VALUE(json_col, '$.Population_B') AS People, 
JSON_VALUE(json_col, '$.Area_million_km2') AS Area
FROM region_json
WHERE JSON_VALUE(json_col,'$.Location.Horizontal_region')='Eastern hemisphere';
--为JSON属性值创建索引需要如下步骤：
--1.表中创建一个虚拟列，返回JSON中检索的属性值；
--2.在虚拟列上创建索引。
ALTER TABLE region_json 
ADD vHorizontal_region AS JSON_VALUE(json_col, '$.Location.Horizontal_region');
CREATE INDEX idx_json_Horizontal_region ON region_json(vHorizontal_region);
--6.关系数据库输出为JSON数据格式
--将NATION表输出为JSON数据格式。
select * from NATION FOR JSON AUTO;
select * from NATION FOR JSON PATH,ROOT('Nations');
--https://www.sojson.com/simple_json.html，JSON在线转换器
--1.创建图数据库
--创建示例图数据库graphdemo。
drop DATABASE  if exists graphdemo;
CREATE DATABASE graphdemo;
USE  graphdemo;
--SQL命令解析：创建图数据库graphdemo并打开graphdemo。
drop table if exists Person;
CREATE TABLE Person (
  ID INTEGER PRIMARY KEY, 
  name VARCHAR(100)
) AS NODE;
drop table if exists Restaurant;
CREATE TABLE Restaurant (
  ID INTEGER NOT NULL, 
  name VARCHAR(100), 
  city VARCHAR(100)
) AS NODE;
drop table if exists City;
CREATE TABLE City (
  ID INTEGER PRIMARY KEY, 
  name VARCHAR(100), 
  stateName VARCHAR(100)
) AS NODE;
--SQL解析：创建节点表Person、Restaurant、City。

drop table if exists likes;
drop table if exists friendOf;
drop table if exists livesIn;
drop table if exists locatedIn;
CREATE TABLE likes (rating INTEGER) AS EDGE;
CREATE TABLE friendOf AS EDGE;
CREATE TABLE livesIn AS EDGE;
CREATE TABLE locatedIn AS EDGE;
--SQL解析：创建边表likes、friendOf、livesIn、locatedIn，rating为边likes的属性。
--2.插入图数据 
--通过insert命令在图数据库graphdemo中构造示例数据。
INSERT INTO Person VALUES (1,'John');
INSERT INTO Person VALUES (2,'Mary');
INSERT INTO Person VALUES (3,'Alice');
INSERT INTO Person VALUES (4,'Jacob');
INSERT INTO Person VALUES (5,'Julie');
--SQL解析：在节点表Person中插入示例数据。

INSERT INTO Restaurant VALUES (1,'Taco Dell','Bellevue');
INSERT INTO Restaurant VALUES (2,'Ginger and Spice','Seattle');
INSERT INTO Restaurant VALUES (3,'Noodle Land', 'Redmond');
--SQL解析：在节点表Restaurant中插入示例数据。

INSERT INTO City VALUES (1,'Bellevue','wa');
INSERT INTO City VALUES (2,'Seattle','wa');
INSERT INTO City VALUES (3,'Redmond','wa');
--SQL解析：在节点表City中插入示例数据。

INSERT INTO likes VALUES ((SELECT $node_id FROM Person WHERE id = 1), 
       (SELECT $node_id FROM Restaurant WHERE id = 1),9);
INSERT INTO likes VALUES ((SELECT $node_id FROM Person WHERE id = 2), 
      (SELECT $node_id FROM Restaurant WHERE id = 2),9);
INSERT INTO likes VALUES ((SELECT $node_id FROM Person WHERE id = 3), 
      (SELECT $node_id FROM Restaurant WHERE id = 3),9);
INSERT INTO likes VALUES ((SELECT $node_id FROM Person WHERE id = 4), 
      (SELECT $node_id FROM Restaurant WHERE id = 3),9);
INSERT INTO likes VALUES ((SELECT $node_id FROM Person WHERE id = 5), 
      (SELECT $node_id FROM Restaurant WHERE id = 3),9);
--SQL解析：在边表likes中插入示例数据，需要为边likes的列$from_id和$to_id设置$node_id值。

INSERT INTO livesIn VALUES ((SELECT $node_id FROM Person WHERE id = 1),
      (SELECT $node_id FROM City WHERE id = 1));
INSERT INTO livesIn VALUES ((SELECT $node_id FROM Person WHERE id = 2),
      (SELECT $node_id FROM City WHERE id = 2));
INSERT INTO livesIn VALUES ((SELECT $node_id FROM Person WHERE id = 3),
      (SELECT $node_id FROM City WHERE id = 3));
INSERT INTO livesIn VALUES ((SELECT $node_id FROM Person WHERE id = 4),
      (SELECT $node_id FROM City WHERE id = 3));
INSERT INTO livesIn VALUES ((SELECT $node_id FROM Person WHERE id = 5),
      (SELECT $node_id FROM City WHERE id = 1));
--SQL解析：在边表livesIn中插入示例数据。

INSERT INTO locatedIn VALUES ((SELECT $node_id FROM Restaurant WHERE id = 1),
      (SELECT $node_id FROM City WHERE id =1));
INSERT INTO locatedIn VALUES ((SELECT $node_id FROM Restaurant WHERE id = 2),
      (SELECT $node_id FROM City WHERE id =2));
INSERT INTO locatedIn VALUES ((SELECT $node_id FROM Restaurant WHERE id = 3),
      (SELECT $node_id FROM City WHERE id =3));
--SQL解析：在边表locatedIn中插入示例数据。

INSERT INTO friendof VALUES ((SELECT $NODE_ID FROM person WHERE ID = 1), (SELECT $NODE_ID FROM person WHERE ID = 2));
INSERT INTO friendof VALUES ((SELECT $NODE_ID FROM person WHERE ID = 2), (SELECT $NODE_ID FROM person WHERE ID = 3));
INSERT INTO friendof VALUES ((SELECT $NODE_ID FROM person WHERE ID = 3), (SELECT $NODE_ID FROM person WHERE ID = 1));
INSERT INTO friendof VALUES ((SELECT $NODE_ID FROM person WHERE ID = 4), (SELECT $NODE_ID FROM person WHERE ID = 2));
INSERT INTO friendof VALUES ((SELECT $NODE_ID FROM person WHERE ID = 5), (SELECT $NODE_ID FROM person WHERE ID = 4));
--SQL解析：在边表friendof中插入示例数据。
--3.图数据查询
--查找好友。
SELECT Person2.name AS FriendName
FROM Person Person1, friendOf, Person Person2
WHERE MATCH(Person1-(friendOf)->Person2)
AND Person1.name = 'John';
--SQL解析：在节点表Person中查找与John有朋友关系边（friendOf）的节点。
--查找好友的好友。
SELECT Person3.name AS FriendName 
FROM Person Person1, friendOf, Person Person2, friendOf friend2, Person Person3
WHERE MATCH(Person1-(friendOf)->Person2-(friend2)->Person3)
AND Person1.name = 'John';
--SQL解析：在节点表Person中查找与John朋友的朋友，通过边别名两次遍历节点。
--查找共同的好友。
SELECT Person1.name AS Friend1, Person2.name AS Friend2
FROM Person Person1, friendOf friend1, Person Person2, 
        friendOf friend2, Person Person0
WHERE MATCH(Person1-(friend1)->Person0<-(friend2)-Person2);
--SQL解析：查找与Person0共同具有朋友关系的Person。
--查找John喜欢的餐馆。
SELECT Restaurant.name
FROM Person, likes, Restaurant
WHERE MATCH (Person-(likes)->Restaurant)
AND Person.name = 'John';
--SQL解析：查找John喜欢的餐馆。
--查找John的朋友喜欢的餐馆。
SELECT Restaurant.name 
FROM Person person1, Person person2, likes, friendOf, Restaurant
WHERE MATCH(person1-(friendOf)->person2-(likes)->Restaurant)
AND person1.name='John';
--SQL解析：通过friendOf边表查找John的朋友，再查找John朋友喜欢的餐馆。
--查找喜欢的餐馆与居住地位于相同城市的人。
SELECT Person.name
FROM Person, likes, Restaurant, livesIn, City, locatedIn
WHERE MATCH (Person-(likes)->Restaurant-(locatedIn)->City 
AND Person-(livesIn)->City);
--SQL解析：通过likes边表查找餐馆，通过locatedIn边表查找所处城市，同时满足居住在相同的城市。

--查询SQL server数据页链表结构
DBCC IND('TPCH_TEST','CUSTOMER',1)
--查看SQL server数据页内部存储结构
DBCC TRACEON(2432)
DBCC PAGE(TPCH_TEST,1,2432,1)
DBCC PAGE(TPCH_TEST,1,2432,3)
--查看SQL server查询时缓冲区工作状态。
use TPCH_TEST
DBCC DROPCLEANBUFFERS
DBCC FREEPROCCACHE
SET STATISTICS IO ON  
SET STATISTICS TIME ON
SELECT SUM(P_SIZE) FROM PART;
SELECT SUM(P_SIZE) FROM PART;
SET STATISTICS IO OFF
SET STATISTICS TIME OFF
--查看在没有索引和创建索引情况下的数据库查找操作的数据访问性能。
SET STATISTICS IO ON  
SET STATISTICS TIME ON
DBCC DROPCLEANBUFFERS
DBCC FREEPROCCACHE
SELECT * FROM LINEITEM;
DBCC DROPCLEANBUFFERS
DBCC FREEPROCCACHE
SELECT L_PARTKEY FROM LINEITEM;
DBCC DROPCLEANBUFFERS
DBCC FREEPROCCACHE
SELECT * FROM LINEITEM WHERE L_PARTKEY= 152774;
CREATE INDEX PARTKY ON LINEITEM(L_PARTKEY);
DBCC DROPCLEANBUFFERS
DBCC FREEPROCCACHE
SELECT * FROM LINEITEM WHERE L_PARTKEY= 152774;
SET STATISTICS IO OFF  
SET STATISTICS TIME OFF

exec sp_spaceused 'LINEITEM';
exec sp_helpindex LINEITEM;
--为TPC-H（TPCH）数据库的LINEITEM表创建内存表。
--（1）为数据库TPCH创建内存优化数据文件组并为文件组增加容器
ALTER DATABASE TPC_H ADD FILEGROUP TPCH_FG CONTAINS MEMORY_OPTIMIZED_DATA  
ALTER DATABASE TPC_H ADD FILE (NAME='TPCH_FG', FILENAME= 'C:\IM_DATA\TPCH_FG') TO FILEGROUP TPCH_FG;  
--（2）创建内存表
drop table  if exists LINEITEM_IM
CREATE TABLE LINEITEM_IM (
	L_ORDERKEY  	integer     	not null,
	L_PARTKEY 	integer     	not null,
	L_SUPPKEY  	integer     	not null,
	L_LINENUMBER 	integer     	not null,
	L_QUANTITY  	float     		not null,
	L_EXTENDEDPRICE  	float     		not null, 
	L_DISCOUNT  	float     		not null, 
	L_TAX  	float     		not null, 
	L_RETURNFLAG 	char(1)     	not null, 
	L_LINESTATUS  	char(1)     	not null, 
	L_SHIPDATE  	date     		not null, 
	L_COMMITDATE 	date     		not null, 
	L_RECEIPTDATE 	date     		not null, 
	L_SHIPINSTRUCT 	char(25)     	not null, 
	L_SHIPMODE  	char(10)     	not null, 
	L_COMMENT  	varchar(44)   	not null, 
	PRIMARY KEY NONCLUSTERED (L_ORDERKEY,L_LINENUMBER),
	index ix_orderkey hash (L_ORDERKEY,L_LINENUMBER ) with (bucket_count=8000000)) 
WITH (MEMORY_OPTIMIZED=ON, DURABILITY=SCHEMA_AND_DATA);
--（3）将数据从lineorder表导入内存表
insert into LINEITEM_IM select * from LINEITEM;
--（4）SQL查询性能对比测试
--Disk Table LINEITEM
SELECT L_RETURNFLAG,L_LINESTATUS,
SUM(L_QUANTITY) AS SUM_QTY,
SUM(L_EXTENDEDPRICE) AS SUM_BASE_PRICE,
SUM(L_EXTENDEDPRICE*(1-L_DISCOUNT)) AS SUM_DISC_PRICE,
SUM(L_EXTENDEDPRICE*(1-L_DISCOUNT)*(1+L_TAX)) AS SUM_CHARGE,
AVG(L_QUANTITY) AS AVG_QTY,AVG(L_EXTENDEDPRICE) AS AVG_PRICE,
AVG(L_DISCOUNT) AS AVG_DISC,COUNT(*) AS COUNT_ORDER
FROM LINEITEM
WHERE L_SHIPDATE <= '1998-12-01' 
GROUP BY L_RETURNFLAG,L_LINESTATUS
ORDER BY L_RETURNFLAG,L_LINESTATUS;
--Memory Table LINEITEM_IM
SELECT L_RETURNFLAG,L_LINESTATUS,
SUM(L_QUANTITY) AS SUM_QTY,
SUM(L_EXTENDEDPRICE) AS SUM_BASE_PRICE,
SUM(L_EXTENDEDPRICE*(1-L_DISCOUNT)) AS SUM_DISC_PRICE,
SUM(L_EXTENDEDPRICE*(1-L_DISCOUNT)*(1+L_TAX)) AS SUM_CHARGE,
AVG(L_QUANTITY) AS AVG_QTY,AVG(L_EXTENDEDPRICE) AS AVG_PRICE,
AVG(L_DISCOUNT) AS AVG_DISC,COUNT(*) AS COUNT_ORDER
FROM LINEITEM_IM
WHERE L_SHIPDATE <= '1998-12-01' 
GROUP BY L_RETURNFLAG,L_LINESTATUS
ORDER BY L_RETURNFLAG,L_LINESTATUS;

--创建列存储索引命令如下：
CREATE NONCLUSTERED COLUMNSTORE INDEX csindx_LINEITEM
ON LINEITEM (L_QUANTITY, L_EXTENDEDPRICE, L_DISCOUNT, L_TAX, L_SHIPDATE, L_RETURNFLAG, L_LINESTATUS);
select sum(L_QUANTITY) from LINEITEM_IM;
select sum(L_QUANTITY) from LINEITEM;
--创建内存列存储索引
drop table  if exists LINEITEM_IM_CSI
CREATE TABLE LINEITEM_IM_CSI (
	L_ORDERKEY  		integer     	not null,
	L_PARTKEY 			integer     	not null,
	L_SUPPKEY  		integer     	not null,
	L_LINENUMBER 		integer     	not null,
	L_QUANTITY  		float     	not null,
	L_EXTENDEDPRICE 	float     	not null, 
	L_DISCOUNT  		float     	not null, 
	L_TAX  				float     	not null, 
	L_RETURNFLAG 		char(1)     	not null, 
	L_LINESTATUS  		char(1)     	not null, 
	L_SHIPDATE  		date     		not null, 
	L_COMMITDATE 		date     		not null, 
	L_RECEIPTDATE 		date     		not null, 
	L_SHIPINSTRUCT 	char(25)     	not null, 
	L_SHIPMODE  		char(10)     	not null, 
	L_COMMENT  		varchar(44)   not null, 
	PRIMARY KEY NONCLUSTERED (L_ORDERKEY,L_LINENUMBER),
	INDEX LINEITEM_IMCCI CLUSTERED COLUMNSTORE
) WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);
--导入数据
insert into LINEITEM_IM_CSI select * from LINEITEM;
--测试
select sum(L_QUANTITY) from LINEITEM;
select sum(L_QUANTITY) from LINEITEM_IM_CSI;
select sum(L_QUANTITY) from LINEITEM_IM;

--Q2
select
s_acctbal,s_name,n_name,p_partkey,p_mfgr,s_address,s_phone,s_comment
from
part,supplier,partsupp,nation,region
where
p_partkey = ps_partkey and s_suppkey = ps_suppkey
and p_size = 15 and p_type like '%BRASS'
and s_nationkey = n_nationkey and n_regionkey = r_regionkey
and r_name = 'EUROPE' and ps_supplycost = (
select
min(ps_supplycost)
from
partsupp, supplier,nation, region
where
p_partkey = ps_partkey and s_suppkey = ps_suppkey
and s_nationkey = n_nationkey and n_regionkey = r_regionkey and r_name = 'EUROPE'
)
order by
s_acctbal desc, n_name,s_name,p_partkey;
--改写后查询
WITH ps_supplycostTable(min_supplycost,partkey)
AS
(
    select min(ps_supplycost) as min_ps_supplycost,p_partkey
    from partsupp, supplier,nation, region,part
    where p_partkey = ps_partkey and s_suppkey = ps_suppkey
    and p_size = 15 and p_type like '%BRASS'
    and s_nationkey = n_nationkey and n_regionkey = r_regionkey and r_name = 'EUROPE'
    group by p_partkey 
)
select
s_acctbal,s_name,n_name,p_partkey,ps_supplycost,p_mfgr,s_address,s_phone,s_comment
from
part,supplier,partsupp,nation,region,ps_supplycostTable
where
p_partkey = ps_partkey and s_suppkey = ps_suppkey
and partkey=p_partkey   --增加与派生表partkey连接表达式
and ps_supplycost =min_supplycost   --增加与派生表supplycost等值表达式
and p_size = 15 and p_type like '%BRASS'
and s_nationkey = n_nationkey and n_regionkey = r_regionkey
and r_name = 'EUROPE' 
order by s_acctbal desc, n_name,s_name,p_partkey;

EXEC sp_configure 'external scripts enabled', 1;
RECONFIGURE WITH OVERRIDE
sp_configure
--在SQL Server服务中启动launchpad

--python数据挖掘案例
--SQL语句如下：
--新建表Recency，用于存储Recency维度的数据
drop table if exists Recency;
CREATE TABLE Recency(r_custkey VARCHAR(50),orderdate date, recency int);
INSERT INTO Recency SELECT c_custkey,o_orderdate,c_custkey FROM customer c,orders o
where c.c_custkey=o.o_custkey
GROUP BY c_custkey,o_orderdate;
UPDATE Recency SET recency= datediff(day,orderdate,'09-01-1998');
select * from recency
order by r_custkey;
--新建视图RFM_Model，用于存储每一位用户RFM三个维度的数据
drop view if exists RFM_Model;
CREATE VIEW RFM_Model(c_custkey,monetary,frequency,recency)
AS
SELECT c_custkey,cast(SUM(o_totalprice) as int),count(o_orderdate),min(recency)
FROM customer c,orders o,recency r
WHERE c.c_custkey=o.o_custkey and c.c_custkey=r_custkey
GROUP BY c_custkey;
--如不加cast数据类型转换，sum结果自动设置为decimal(38,0),导致聚类时数据类型不支持
select * from RFM_Model
order by c_custkey;

--在SQL Server中执行Python脚本，实现聚类分析，语句如下：
--创建存储过程customer_clusters
DROP procedure IF EXISTS [dbo].[customer_clusters];
CREATE procedure [dbo].[customer_clusters]
AS

BEGIN
    DECLARE
--读入视图RFM_Model中存储的数据
	@input_query NVARCHAR(MAX) = N'
select c_custkey,monetary,frequency,recency
from RFM_Model
'
--1）运行Python脚本命令，进行聚类分析
EXEC sp_execute_external_script
@language = N'Python' 
, @script = N'
import pandas as pd
from sklearn.cluster import KMeans

customer_data = my_input_data

n_clusters = 4

est = KMeans(n_clusters=n_clusters, 
random_state=111).fit(customer_data[["monetary","frequency","recency"]])
clusters = est.labels_ 
customer_data["cluster"] = clusters
OutputDataSet = customer_data
 '
, @input_data_1 = @input_query
, @input_data_1_name = N'my_input_data'
--with result sets (("c_custkey" int, "monetary" float,"frequency" float,"recency"float,"cluster" float)); 
with result sets (("c_custkey" int, "monetary" int,"frequency" int,"recency"int,"cluster" int)); 
END;
GO
--2）执行存储过程，将聚类结果存储在表 py_customer_clusters 中
--创建存储聚类结果的表
DROP TABLE IF EXISTS [dbo].[py_customer_clusters];
GO
--表中存储聚类预测结果
CREATE TABLE [dbo].[py_customer_clusters](
[c_custkey] [bigint] NULL, 
[monetary] [int] NULL, 
[frequency] [int] NULL, 
[recency] [int] NULL, 
[cluster] [int] NULL,
) ON [PRIMARY]
GO
--执行聚类操作并将聚类结果插入表中
INSERT INTO py_customer_clusters
EXEC [dbo].[customer_clusters];
--3）查看聚类结果
--数据概览
SELECT * FROM py_customer_clusters; 

