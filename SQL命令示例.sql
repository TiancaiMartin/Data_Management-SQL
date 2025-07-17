--**CREATE TABLE����ʾ��**
drop database if exists TPCH_TEST;
create database TPCH_TEST;
use TPCH_TEST;

--����4-4������ͼ3-13��A��ģʽ��д��TPC-H���ݿ��и���Ķ������
drop table if exists REGION;
CREATE TABLE REGION
(	R_REGIONKEY 	integer ,
	R_NAME  		char(25), 
	R_COMMENT  		varchar(152) );
--û������Լ����������������������
drop table if exists REGION;
CREATE TABLE REGION
(	R_REGIONKEY 	integer 	PRIMARY KEY,
	R_NAME  		char(25), 
	R_COMMENT  		varchar(152) );
--��������Լ���������Զ�������������
drop table if exists NATION;
CREATE TABLE NATION
(	N_NATIONKEY 	integer 	PRIMARY KEY,
	N_NAME  		char(25), 
	N_REGIONKEY  	integer 	REFERENCES REGION (R_REGIONKEY),
	N_COMMENT  		varchar(152)  );
--���������ǰ���ǲι��REGION���ֶ�Ϊ������

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

--��TPCH_DEMO������TPCH_TEST���в����¼
insert into REGION select * from [TPCH_DEMO].[dbo].REGION;
insert into NATION select * from [TPCH_DEMO].[dbo].NATION;
insert into SUPPLIER select * from [TPCH_DEMO].[dbo].SUPPLIER;
insert into PART select * from [TPCH_DEMO].[dbo].PART;
insert into PARTSUPP select * from [TPCH_DEMO].[dbo].PARTSUPP;
insert into CUSTOMER select * from [TPCH_DEMO].[dbo].CUSTOMER;
insert into ORDERS select * from [TPCH_DEMO].[dbo].ORDERS;
insert into LINEITEM select * from [TPCH_DEMO].[dbo].LINEITEM;

--**ALTER TABLE����ʾ��**
ALTER TABLE LINEITEM ADD L_SURRKEY int;
--SQL�������������һ��int���͵���L_SURRKEY;
ALTER TABLE LINEITEM ALTER COLUMN L_QUANTITY SMALLINT;
--SQL�����������L_QUANTITY�е����������޸�ΪSMALLINT��
ALTER TABLE ORDERS ALTER COLUMN O_ORDERPRIORITY varchar(15) NOT NULL;
--SQL�����������O_ORDERPRIORITY�е�Լ���޸�ΪNOT NULLԼ����
ALTER TABLE LINEITEM ADD CONSTRAINT FK_S FOREIGN KEY (L_SURRKEY) REFERENCES SUPPLIER(S_SUPPKEY); 
--SQL�����������LINEITEM��������һ�����Լ����CONSTRAINT�ؼ��ֶ���Լ��������FK_S��Ȼ���������������Լ��������
ALTER TABLE LINEITEM DROP CONSTRAINT FK_S;
--SQL�����������LINEITEM����ɾ�����Լ��FK_S��
ALTER TABLE LINEITEM DROP COLUMN L_SURRKEY;
--SQL���������ɾ�����е���L_SURRKEY��

--**ROP TABLE**
DROP TABLE ORDERS;
--���������Լ���Ĵ��ڶ�����ɾ������Ҫ��ɾ�������յı����ɾ��
DROP TABLE LINEITEM;
DROP TABLE ORDERS;
--����ɾ����������ɾ�������¼�����ɾ���ϼ�

--***ǰ�ؼ������ڴ��*
--�����ļ���
ALTER DATABASE TPCH ADD FILEGROUP TPCH_mod CONTAINS MEMORY_OPTIMIZED_DATA  
ALTER DATABASE TPCH ADD FILE (NAME='TPCH_mod', FILENAME= 'C:\IM_DATA\TPCH_mod') TO FILEGROUP TPCH_mod;  
--�����ڴ��
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
--����4-8��ΪTPC-H���ݿ��supplier���s_name�д���Ψһ������Ϊs_nation�к�s_city�д�����������������s_nationΪ����s_cityΪ����
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
--�鿴�������ۼ������Ĳ���ִ�мƻ�
select * from SUPPLIER_nopk where s_name='Supplier#000000728';
--�鿴���������ۼ������Ĳ���ִ�мƻ�
drop index if exists supplier.s_name_Inx;
select * from supplier where s_name='Supplier#000000728';
--���Ҳ���ִ�мƻ�
CREATE UNIQUE INDEX s_name_Inx ON supplier(s_name);
CREATE INDEX s_n_c_Inx ON supplier(s_nationkey ASC, s_phone DESC);
--����������Ĳ���ִ�мƻ�
select * from supplier where s_name='Supplier#000000728';

--������ɨ��
drop index if exists lineitem.csindx_lineorder;
SELECT l_returnflag, l_linestatus, SUM(l_extendedprice*(1-l_discount)*(1+l_tax))
FROM lineitem
WHERE l_shipdate <= '1998-12-01'
GROUP BY l_returnflag, l_linestatus;

--�����д洢����
CREATE NONCLUSTERED COLUMNSTORE INDEX csindx_lineorder
ON lineitem(l_returnflag, l_linestatus, l_extendedprice,l_discount,l_tax,l_shipdate);
--�Զ����д洢������ɨ��
SELECT l_returnflag, l_linestatus, SUM(l_extendedprice*(1-l_discount)*(1+l_tax))
FROM lineitem
WHERE l_shipdate <= '1998-12-01'
GROUP BY l_returnflag, l_linestatus;

--**DROP INDEX**
DROP INDEX supplier.s_n_c_Inx; 
DROP INDEX s_name_Inx ON supplier;

--**�����ѯ**
--ͶӰ����
--����4 11����ѯPART����ȫ���ļ�¼��
SELECT * FROM PART;
--��
SELECT P_RETAILPRICE, P_MFGR,P_BRAND, P_TYPE, 
P_SIZE, P_CONTAINER,  P_COMMENT ,P_PARTKEY, P_NAME
FROM PART;
--��ѯָ����
--����4 12����ѯPART����P_NAME��P_BRAND��P_CONTAINER�С�
SELECT P_NAME, P_BRAND, P_CONTAINER FROM PART;
--��ѯ���ʽ��
Select L_COMMITDATE, L_RECEIPTDATE, 'Interval Days:' as Receipting, 
DATEDIFF (DAY, L_COMMITDATE, L_RECEIPTDATE) as IntervalDay,
L_EXTENDEDPRICE*(1-L_DISCOUNT) as DiscountedPrice,
L_EXTENDEDPRICE*(1-L_DISCOUNT)*(1+L_TAX) as DiscountedTaxedPrice
from LINEITEM;
--ͶӰ�����в�ͬ�ĳ�Ա
--����4-14�����LINEITEM���и��������L_SHIPMODE��ʽ�Լ���ѯ������ЩL_SHIPMODE��ʽ��
select L_SHIPMODE from LINEITEM;
--SQL������������L_SHIPMODE����ȫ����ȡֵ���������ظ���ȡֵ��
select distinct L_SHIPMODE from LINEITEM;
--SQL���������ͨ��DISTINCT����ָ����L_SHIPMODEֻ�����ͬȡֵ�ĳ�Ա�����е�ÿ��ȡֵֻ���һ�Ρ�
select distinct l_orderkey,l_linenumber  from LINEITEM;
select count(*) from lineitem;
select distinct ps_partkey,ps_suppkey  from partsupp;
select count(*) from partsupp;
--������ͬ��˵��ÿ�����ϼ�ֻ����һ��
select ps_partkey,ps_suppkey, count(*) as counter from partsupp group by ps_partkey,ps_suppkey
--����partsupp���еĸ��������Ƿ�Ψһ

--**ѡ�����**
--�Ƚϴ�С
--����4-15�����LINEITEM�������������ļ�¼��
select * from LINEITEM where L_QUANTITY!<45;
--SQL������������LINEITEM����L_QUANTITY����45�ļ�¼��
select * from LINEITEM where L_SHIPINSTRUCT='COLLECT COD';
--SQL����������������L_SHIPINSTRUCTֵΪCOLLECT COD�ļ�¼��
select * from LINEITEM where NOT L_COMMITDATE>L_SHIPDATE;
--SQL����������������L_COMMITDATEʱ�䲻����L_SHIPDATEʱ��ļ�¼��
select * from LINEITEM where DATEDIFF(DAY,L_COMMITDATE,L_RECEIPTDATE)> 10;
--SQL����������������RECEIPTDATE��COMMITDATE����10��ļ�¼��
--��Χ�ж�
--����4-16�����LINEITEM����ָ����Χ֮��ļ�¼��
select * from LINEITEM 
where L_COMMITDATE between L_SHIPDATE and L_RECEIPTDATE;
--SQL������������LINEITEM����COMMITDATE����SHIPDATE��RECEIPTDATE֮��ļ�¼��
select * from LINEITEM 
where L_COMMITDATE not between '1996-01-01' and '1997-12-31';
--SQL������������LINEITEM����1996��1997��֮��ļ�¼��

--���ں���ʾ��
select 
l_shipdate,
DATEADD(YY,5,l_shipdate) as date_5Year_after,
DATEADD(Q,5,l_shipdate) as date_5Quarter_after,
DATEADD(WW,5,l_shipdate) as date_5Week_after,
DATEADD(DD,-25,l_shipdate) as date_25D_before,
DATEDIFF(D,l_shipdate,l_receiptdate) as daygap
from LINEITEM;

--�����ж�
--����4 17�����LINEITEM���м���֮�ڵļ�¼��
select * from LINEITEM where L_SHIPMODE in ('MAIL', 'SHIP');
--SQL������������L_SHIPMODE����ΪMAIL��SHIP�ļ�¼��
select * from PART where P_SIZE not in (49,14,23,45,19,3,36,9);
--SQL������������PART����ΪP_SIZE����49,14,23,45,19,3,36,9�ļ�¼

--�ַ�ƥ��
--����4-18�����ģ����ѯ�Ľ����
select * from PART where P_TYPE like 'PROMO%';
--SQL������������PART����P_TYPE������PROMO��ͷ�ļ�¼��
select * from SUPPLIER where S_COMMENT like '%Customer%Complaints%';
--SQL������������SUPPLIER����S_COMMENT������λ�ð���Customer���Һ����ַ��а���Complaints�ļ�¼��
select * from PART where P_CONTAINER like '% _AG';
--SQL������������PART��P_CONTAINER���е�����3��Ϊ�����ַ������2���ַ�ΪAG�ļ�¼��
select * from LINEITEM where L_COMMENT like '%return rate __\%for%' ESCAPE '%';
--SQL������������LINEITEM��L_COMMENT���а���return rate ����λ���֡��ٷֱȷ��ź�for�ַ��ļ�¼������_Ϊͨ�������'\'��ʾ����%Ϊ�ٷֱȷ���

--��ֵ�ж�
--����4-19�����LINEITEM����û�пͻ�����L_COMMENT�ļ�¼��
select * from LINEITEM where L_COMMENT is NULL;
--SQL������������LINEITEM����L_COMMENT��Ϊ��ֵ�ļ�¼��

--�����������ʽ
--����4-20�����LINEITEM�������㸴�������ļ�¼��
select sum(L_EXTENDEDPRICE*L_DISCOUNT) as revenue from LINEITEM
where L_SHIPDATE between '1996-01-01' and '1996-12-31' 
and L_DISCOUNT between 0.06 - 0.01 and 0.06 + 0.01 and L_QUANTITY > 24;
--SQL������������LINEITEM����SHIPDATE��1994�ꡢ�ۿ���5%-7%֮�䡢����С��24�Ķ������¼�������ѯ������AND��OR���ӣ�AND���ȼ�����OR
select * from LINEITEM 
where L_SHIPMODE in ('AIR', 'AIR REG') 
and L_SHIPINSTRUCT ='DELIVER IN PERSON' 
and ((L_QUANTITY >= 10 and L_QUANTITY <= 20) or (L_QUANTITY >= 30 and L_QUANTITY <= 40));
--SQL������������LINEITEM����SHIPMODE��ΪAIR��AIR REG��SHIPINSTRUCT����ΪDELIVER IN PERSON��QUANTITY��10��20֮���30��40֮��ļ�¼��

--**�ۼ�����**
--����4-21��ִ��TPC-H��ѯQ1�оۼ����㲿�֡�
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

--����4-22��ͳ��LINEITEM����L_QUANTITY�е�����������
select count(distinct L_QUANTITY) as CARD, max(L_QUANTITY) as MaxValue, 
min(L_QUANTITY) as MinValue from LINEITEM;
--SQL���������ͳ��LINEITEM����L_QUANTITY���в�ͬȡֵ�����������ֵ����Сֵ��
--����4-23��ͳ��ORDERS���и��Ż�������Ż���������������
select sum(case 
when O_ORDERPRIORITY ='1-URGENT' or O_ORDERPRIORITY ='2-HIGH' 
then 1 else 0 end) as high_line_count,
sum(case 
when O_ORDERPRIORITY <> '1-URGENT' and O_ORDERPRIORITY <> '2-HIGH'
then 1 else 0 end) as low_line_count
from ORDERS;
--SQL���������ͨ��case�����ݹ�����ѡ�����������֧��������Խ�����оۼ����㡣
select O_ORDERPRIORITY,sum(o_totalprice) as revenue from orders group by O_ORDERPRIORITY;

select 
sum(case when O_ORDERPRIORITY ='1-URGENT' then o_totalprice else 0 end) as '1-URGENT',
sum(case when O_ORDERPRIORITY ='2-HIGH' then o_totalprice else 0 end) as '2-HIGH',
sum(case when O_ORDERPRIORITY ='3-MEDIUM' then o_totalprice else 0 end) as '3-MEDIUM',
sum(case when O_ORDERPRIORITY ='4-NOT SPECIFIED' then o_totalprice else 0 end) as '4-NOT SPECIFIED',
sum(case when O_ORDERPRIORITY ='5-LOW' then o_totalprice else 0 end) as '5-LOW'
from ORDERS;
--������ת��

--**�������**
--����4-24����LINEITEM��RETURNFLAG,SHIPMODE��ͬ�ķ�ʽͳ������������
select sum(L_QUANTITY) as sum_quantity from LINEITEM;
--SQL���������ͳ��LINEITEM�����м�¼L_QUANTITY�Ļ���ֵ��
select L_RETURNFLAG,sum(L_QUANTITY) as sum_quantity from LINEITEM group by L_RETURNFLAG;
--SQL�����������L_RETURNFLAG���Է���ͳ��LINEITEM�����м�¼L_QUANTITY�Ļ���ֵ��
select L_RETURNFLAG,L_LINESTATUS,sum(L_QUANTITY) as sum_quantity from LINEITEM group by L_RETURNFLAG,L_LINESTATUS;
--SQL�����������L_RETURNFLAG��L_LINESTATUS���Է���ͳ��LINEITEM�����м�¼L_QUANTITY�Ļ���ֵ��

--��1����GROUP BY����
select L_RETURNFLAG, L_LINESTATUS, L_SHIPINSTRUCT, 
sum(L_QUANTITY) as sum_quantity 
from LINEITEM 
group by L_RETURNFLAG, L_LINESTATUS, L_SHIPINSTRUCT;
--SQL�����������ѯ��L_RETURNFLAG��L_LINESTATUS��L_SHIPINSTRUCT��������ֱ�ӽ��з���ۼ�����
--��2��ROLLUP GROUP BY����
select L_RETURNFLAG, L_LINESTATUS, L_SHIPINSTRUCT, 
sum(L_QUANTITY) as sum_quantity 
from LINEITEM 
group by ROLLUP (L_RETURNFLAG, L_LINESTATUS, L_SHIPINSTRUCT);
--SQL�����������ѯ��L_RETURNFLAG��L_LINESTATUS��L_SHIPINSTRUCT��������Ϊ��������L_RETURNFLAGΪ�Ͼ�����ϸ���ֽ��ж���������Ծۼ�����
--��3��CUBE GROUP BY����
select L_RETURNFLAG, L_LINESTATUS, L_SHIPINSTRUCT, 
sum(L_QUANTITY) as sum_quantity 
from LINEITEM 
group by CUBE (L_RETURNFLAG, L_LINESTATUS, L_SHIPINSTRUCT)
order by L_RETURNFLAG, L_LINESTATUS, L_SHIPINSTRUCT;
--SQL�����������ѯ��L_RETURNFLAG �� L_LINESTATUS��L_SHIPINSTRUCT��������Ϊ������Ϊÿһ������������Ͻ��з���ۼ�����

--����4-26�����LINEITEM��������Ŀ����5��Ķ����š�
select L_ORDERKEY, count(*) as order_counter
from LINEITEM 
group by L_ORDERKEY 
having count(*)>=5;
--SQL���������HAVING�����е�COUNT(*)>5��Ϊ����ۼ��������Ĺ����������Է���ۼ��������ɸѡ��
--����4-27�����LINEITEM��������Ŀ����5���ƽ������������28��30֮��Ķ�����ƽ�����ۼ۸�
select L_ORDERKEY, avg(L_EXTENDEDPRICE) 
from LINEITEM 
group by L_ORDERKEY 
having avg(L_QUANTITY) between 28 and 30 and count(*)>5;
--SQL���������HAVING�����п���ʹ�����Ŀ������û�еľۼ��������ʽ����HAVING avg(L_QUANTITY) between 28 and 30 and count(*)>5�����б��ʽavg(L_QUANTITY) between 28 and 30��count(*)>5�����ǲ�ѯ����ľۼ��������ʽ��ֻ���ڶԷ���ۼ�����������ɸѡ

--**�������**
--����4-28����LINEITEM����з���ۼ����㣬�������Ĳ�ѯ�����
select L_RETURNFLAG,L_LINESTATUS,
sum(L_QUANTITY) as sum_quantity 
from LINEITEM 
group by L_RETURNFLAG,L_LINESTATUS
order by L_RETURNFLAG,L_LINESTATUS;
--SQL����������Բ�ѯ����������������򣬵�һ��������ΪL_RETURNFLAG���ڶ���������ΪL_LINESTATUS��
select L_RETURNFLAG,L_LINESTATUS,
sum(L_QUANTITY) as sum_quantity 
from LINEITEM 
group by L_RETURNFLAG,L_LINESTATUS
order by sum(L_QUANTITY) DESC;
--�����ʽ����
select L_RETURNFLAG,L_LINESTATUS,
sum(L_QUANTITY) as sum_quantity 
from LINEITEM 
group by L_RETURNFLAG,L_LINESTATUS
order by sum_quantity DESC;
--SQL����������Է���ۼ�������ۼ����ʽ��������

--TPCH������ѯ��Q1,Q6

--**���Ӳ�ѯ**
--�ѿ�������
select * from NATION, REGION;
select * from nation;
select * from region;
--SQL�����������ָ����������ʱ����������ļ�¼���еѿ����˲�����������������
--����4-29��ִ��NATION���REGION���ϵĵ�ֵ���Ӳ�����
select * from NATION, REGION where N_REGIONKEY=R_REGIONKEY;
--SQL���������NATION���N_REGIONKEY����Ϊ���룬����REGION���ϵ�����R_REGIONKEY��������������Ϊ����������ȱ�ʾ����������REGIONKEY��ͬ��Ԫ������������Ϊ��ѯ�����
select * from NATION INNER JOIN REGION on N_REGIONKEY=R_REGIONKEY;
--SQL�����������ֵ���Ӳ��������Բ��������ӵ��﷨�ṹ��ʾ

--���Ӷ������
--����4-30��ִ�б�CUSTOMER��ORDERS��LINEITEM�ϵĲ�ѯ������
select L_ORDERKEY, sum(L_EXTENDEDPRICE*(1-L_DISCOUNT)) as revenue,
       O_ORDERDATE, O_SHIPPRIORITY
from CUSTOMER, ORDERS, LINEITEM
where C_MKTSEGMENT = 'BUILDING' and C_CUSTKEY = O_CUSTKEY
      and L_ORDERKEY = O_ORDERKEY and O_ORDERDATE < '1995-03-15'
      and L_SHIPDATE > '1995-03-15'
group by L_ORDERKEY, O_ORDERDATE, O_SHIPPRIORITY
order by revenue DESC, O_ORDERDATE;
--SQL�����������ͼ4-27��ʾ��CUSTOMER��ORDERS��LINEITEM����������-������չ�ϵ��CUSTOMER��ORDERS��֮�����-�����ֵ���ӱ��ʽΪC_CUSTKEY = O_CUSTKEY��ORDERS����LINEITEM��֮�����-�����ֵ���ӱ��ʽΪL_ORDERKEY = O_ORDERKEY����������ͬ���ϵ�ѡ���������ɸ���������������ӱ��ϵķ���ۼ�����

--��������
--����4-31�����LINEITEM���϶�����L_SHIPINSTRUCT�Ȱ���DELIVER IN PERSON�ְ���TAKE BACK RETURN�Ķ����š�
select distinct L1.L_ORDERKEY 
from LINEITEM L1, LINEITEM L2
where L1.L_SHIPINSTRUCT='DELIVER IN PERSON' 
and L2.L_SHIPINSTRUCT='TAKE BACK RETURN' 
and L1.L_ORDERKEY=L2.L_ORDERKEY;
--���������ӽ��
select *
from LINEITEM L1, LINEITEM L2
where L1.L_SHIPINSTRUCT='DELIVER IN PERSON' 
and L2.L_SHIPINSTRUCT='TAKE BACK RETURN' 
and L1.L_ORDERKEY=L2.L_ORDERKEY;
--����ض�����
select *
from LINEITEM
where L_ORDERKEY=3;

--SQL���������LINEITEM����һ������������������ÿ������������ض���L_SHIPINSTRUCTֵ������һ��������ͬ�Ķ�����L_SHIPINSTRUCTֵ�Ȱ���DELIVER IN PERSON�ְ���TAKE BACK RETURN��Ԫ�顣��ѯ��LINEITEM����ѡ��L_SHIPINSTRUCTֵΪDELIVER IN PERSON��Ԫ�飬�ٴ���ͬ��LINEITEM���Ա����ķ�ʽѡ��L_SHIPINSTRUCTֵΪTAKE BACK RETURN��Ԫ�飬������������Ԫ�鼯��L_ORDERKE��ֵ��������������ͨ��������һ�������������Ȼ�󰴲�ѯ�����������

--������
--����4-32�����ORDERS����CUSTOMER�������������������ӵĽ����
select O_ORDERKEY, O_CUSTKEY, C_CUSTKEY
from ORDERS left outer join CUSTOMER on O_CUSTKEY=C_CUSTKEY;
select O_ORDERKEY, O_CUSTKEY, C_CUSTKEY
from ORDERS right outer join CUSTOMER on O_CUSTKEY=C_CUSTKEY;

--�������
--����4 33����TPC-H���ݿ���ִ��PARTSUPP����PART��SUPPLIER����������Ӳ�����
select P_NAME,P_BRAND, S_NAME,S_NAME,PS_AVAILQTY
from PART,SUPPLIER,PARTSUPP
where PS_PARTKEY=P_PARTKEY and PS_SUPPKEY=S_SUPPKEY;
--SQL���������PARTSUPP����PART��SUPPLIER���������-������չ�ϵ��PARTSUPP��ֱ���PART��part��SUPPLIER��ͨ������������е�ֵ���ӡ�SQL������FROM�Ӿ����3�����ӱ�����WHERE�Ӿ��а���PARTSUPP����2���������������ĵ�ֵ�����������ֱ��Ӧ3��������ӹ�ϵ

--��ʹ��INNER JOIN�﷨����SQL����������ʾ��
select P_NAME,P_BRAND, S_NAME,S_NAME,PS_AVAILQTY
from PARTSUPP inner join PART on PS_PARTKEY=P_PARTKEY 
inner join SUPPLIER on PS_SUPPKEY=S_SUPPKEY; 

SELECT PART.P_NAME, PART.P_BRAND, SUPPLIER.S_NAME, PARTSUPP.PS_AVAILQTY
FROM   PART INNER JOIN
          PARTSUPP ON PART.P_PARTKEY = PARTSUPP.PS_PARTKEY INNER JOIN
          SUPPLIER ON PARTSUPP.PS_SUPPKEY = SUPPLIER.S_SUPPKEY

--����4 34����TPC-H���ݿ���ִ��ѩ�������Ӳ�����
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

--���Զ�������Ƿ���ȷ
select count(*) from LINEITEM;
--���Ӽ���
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
--���Ӽ�������TPCHģʽͼ����
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
--������������ƣ������쳣���壬��Ӧ�̺Ϳͻ�������ͬ
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
--�޶���ѯ
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

--TPCH������ѯ��Q2,Q5,Q10,Q12,Q14,Q19


--**Ƕ�ײ�ѯ**
select sum(L_QUANTITY) 
from LINEITEM 
where L_PARTKEY in
                  (select P_PARTKEY
				   from PART
				   where P_CONTAINER='med case');
--1.����INν�ʵ��Ӳ�ѯ
--����4-35������IN�Ӳ�ѯ��Ƕ�ײ�ѯִ�С�
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
--������Ӳ�ѯת��Ϊ���Ӳ���
select P_BRAND, P_TYPE, P_SIZE, count (distinct PS_SUPPKEY) as supplier_cnt
from PARTSUPP, PART, SUPPLIER
where P_PARTKEY = PS_PARTKEY and S_SUPPKEY=PS_SUPPKEY
and P_BRAND <> 'Brand#45' and P_TYPE not like 'MEDIUM POLISHED%'
and P_SIZE in (49, 14, 23, 45, 19, 3, 36, 9) 
and S_COMMENT not like '%Customer%Complaints%'
group by P_BRAND, P_TYPE, P_SIZE
order by supplier_cnt desc, P_BRAND, P_TYPE, P_SIZE;

--����4-36��ͨ��IN�Ӳ�ѯ���CUSTOMER��NATION��REGION���Ĳ�ѯ��ͳ��ASIA�����˿͵�������
SELECT count(*) FROM CUSTOMER WHERE C_NATIONKEY IN
       (SELECT N_NATIONKEY FROM NATION WHERE N_REGIONKEY IN
               (SELECT R_REGIONKEY FROM REGION
WHERE R_NAME='ASIA'));
--��ǰǶ���Ӳ�ѯ����ת��Ϊ���Ӳ�ѯ��
select count(*) 
from CUSTOMER, NATION, REGION
where C_NATIONKEY=N_NATIONKEY and N_REGIONKEY=R_REGIONKEY
and R_NAME='ASIA';

select * from nation,region where N_REGIONKEY+R_REGIONKEY=8 order by N_NAME;

--2.���бȽ������������Ӳ�ѯ
--����4-37������=�Ƚ���������Ӳ�ѯ��
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

--SUPPLIER,  NATION, REGION��Ϊ��������ԣ�������Ҫ�����ڸ���ѯ�У�����ѯ��R_NAME = 'EUROPE'�������Ӳ�ѯ��ͬ��ȥ��
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

--��д��Ĳ�ѯ���£�
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
and PARTKEY=P_PARTKEY   --������������partkey���ӱ��ʽ
and PS_SUPPLYCOST =min_supplycost   --������������supplycost��ֵ���ʽ
and P_SIZE = 15 and P_TYPE like '%BRASS'
and S_NATIONKEY = N_NATIONKEY and N_REGIONKEY = R_REGIONKEY
and R_NAME = 'EUROPE' 
order by S_ACCTBAL DESC, N_NAME, S_NAME, P_PARTKEY;

--3.����ANY��ALLν�ʵ��Ӳ�ѯ
--����4-38��ͳ��LINEITEM����L_EXTENDEDPRICE�����κ�һ���й��˿Ͷ���L_EXTENDEDPRICE��¼��������
select count(*) from LINEITEM where L_EXTENDEDPRICE>ANY(
select L_EXTENDEDPRICE from LINEITEM, SUPPLIER, NATION
where L_SUPPKEY=S_SUPPKEY and S_NATIONKEY=N_NATIONKEY 
and N_NAME='CHINA');
-->ANY�Ӳ�ѯ���Ը�дΪ�Ӳ�ѯ�е���Сֵ������
select count(*) from LINEITEM where L_EXTENDEDPRICE>(
select min(L_EXTENDEDPRICE) from LINEITEM, SUPPLIER, NATION
where L_SUPPKEY=S_SUPPKEY and S_NATIONKEY=N_NATIONKEY 
and N_NAME='CHINA');

--4.����EXISTν�ʵ��Ӳ�ѯ
--����4-39�����������ѯexists�Ӳ�ѯ�����á�
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
--�ò�ѯ���Ը�дΪʹ�����������SQL��䣺
select O_ORDERPRIORITY, count (distinct L_ORDERKEY) as order_count
from ORDERS, LINEITEM
where O_ORDERKEY=L_ORDERKEY and O_ORDERDATE >= '1993-07-01' 
and O_ORDERDATE < DATEADD (MONTH, 3,'1993-07-01')
and L_COMMITDATE < L_RECEIPTDATE 
group by O_ORDERPRIORITY
order by O_ORDERPRIORITY;
--����4-40����ѯ��û�й����κ���Ʒ�Ĺ˿͵�������
select count(C_CUSTKEY)
from CUSTOMER
where not exists(
select * from ORDERS, LINEITEM
where L_ORDERKEY=O_ORDERKEY and O_CUSTKEY=C_CUSTKEY
);
--�������ж�
select count(C_CUSTKEY)
from ORDERS right outer join CUSTOMER on O_CUSTKEY=C_CUSTKEY
where O_ORDERKEY is NULL;

--����4-41����ѯ��1993��7�����3������û�й����κ���Ʒ�Ĺ˿͵�������
select count(C_CUSTKEY)
from CUSTOMER
where not exists(
select * from ORDERS
where O_CUSTKEY=C_CUSTKEY 
and O_ORDERDATE between '1993-07-01' and DATEADD(MONTH,3,'1993-07-01')
);
--��ѯ�Ľ��������ͨ�����ϲ�������֤��ע���鿴��¼����
select C_CUSTKEY from CUSTOMER
except
select distinct O_CUSTKEY from ORDERS, CUSTOMER 
where O_CUSTKEY=C_CUSTKEY 
and O_ORDERDATE between '1993-07-01' and DATEADD(MONTH,3,'1993-07-01');

--**�ġ����ϲ�ѯ**
--���ϲ�����
--����4-42����ѯLINEITEM����L_SHIPMODEģʽΪAIR��AIR REG���Լ�L_SHIPINSTRUCT��ʽΪDELIVER IN PERSON�Ķ����š�
select distinct L_ORDERKEY from LINEITEM
where L_SHIPMODE in ('AIR','AIR REG')
union
select distinct L_ORDERKEY from LINEITEM
where L_SHIPINSTRUCT ='DELIVER IN PERSON'
order by L_ORDERKEY;

--���ϲ����Զ�ȥ�أ�����distinct�������ͬ
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
--������������Ա�Ƚϲ�ѯ������Ƿ�����ظ�ֵ

--������ͬ�ı���ִ��union����ʱ�����Խ�union����ת��Ϊѡ��ν�ʵĻ�or���ʽ���磺
select distinct L_ORDERKEY from LINEITEM
where L_SHIPMODE in ('AIR','AIR REG') or L_SHIPINSTRUCT ='DELIVER IN PERSON'
order by L_ORDERKEY;

--���Ͻ�����
--����4-43����ѯCONTAINERΪWRAP BOX��MED CASE��JUMBO PACK������PS_AVAILQTY����1000�Ĳ�Ʒ���ơ�
select P_NAME from PART
where P_CONTAINER in ('WRAP BOX','MED CASE','JUMBO PACK')
intersect
select P_NAME from PART, PARTSUPP
where P_PARTKEY=PS_PARTKEY and PS_AVAILQTY<1000;

--�������Ը�дΪ�������Ӳ����Ĳ�ѯ������Ҫע�����P_PARTKEY�����ʱ��Ҫͨ��distinct�������Ӳ����������ظ�ֵ����д��SQL�������£�
select distinct P_NAME from PART, PARTSUPP
where P_PARTKEY=PS_PARTKEY and PS_AVAILQTY<1000 
and P_CONTAINER in ('WRAP BOX','MED CASE','JUMBO PACK')
order by P_NAME;

--���ϲ�����
--����4-44����ѯORDERS����O_ORDERPRIORITY����Ϊ1-URGENT��2-HIGH����O_ORDERSTATUS״̬��ΪF�Ķ����š�
Select O_ORDERKEY from ORDERS
where O_ORDERPRIORITY in ('1-URGENT','2-HIGH')
except
select O_ORDERKEY from ORDERS
where O_ORDERSTATUS='F';

select O_ORDERKEY from ORDERS
where O_ORDERPRIORITY in ('1-URGENT','2-HIGH') and not O_ORDERSTATUS='F';

--��ֵ�м��ϲ�����
--����4-45����ѯLINEITEM����ִ��L_SHIPMODEģʽΪAIR��AIR REG����L_SHIPINSTRUCT��ʽ����DELIVER IN PERSON�Ķ����š�
--����ѯҪ�󽫲�ѯ����L_SHIPMODEģʽΪAIR��AIR REG��Ϊһ�����ϣ���ѯ����L_SHIPINSTRUCT��ʽ��DELIVER IN PERSON��Ϊ��һ�����ϣ�Ȼ���󼯺ϲ��������ѯ�������£�
select L_ORDERKEY from LINEITEM
where L_SHIPMODE in ('AIR','REG AIR')
except
select L_ORDERKEY from LINEITEM
where L_SHIPINSTRUCT ='DELIVER IN PERSON';
--����д�˲�ѯʱ���������L_ORDERKEYǰ����Ҫ�ֹ�����distinct���Խ����ȥ�أ����������ν��������ΪL_SHIPINSTRUCT! ='DELIVER IN PERSON'����ѯ�������£�
select distinct L_ORDERKEY from LINEITEM
where L_SHIPMODE in ('AIR','REG AIR') and L_SHIPINSTRUCT! ='DELIVER IN PERSON';
--���ݷ���ԭ��
select * from lineitem;
--��д�������ӷ����������һ��
select distinct L1.L_ORDERKEY from LINEITEM L1,LINEITEM L2
where L1.L_SHIPMODE in ('AIR','REG AIR') and L2.L_SHIPINSTRUCT! ='DELIVER IN PERSON'
and L1.L_ORDERKEY=L2.L_ORDERKEY;
--�����ݣ���ԭ��
select L1.L_ORDERKEY,L1.L_SHIPMODE,L2.L_SHIPINSTRUCT from LINEITEM L1,LINEITEM L2
where L1.L_SHIPMODE in ('AIR','REG AIR') and L2.L_SHIPINSTRUCT! ='DELIVER IN PERSON'
and L1.L_ORDERKEY=L2.L_ORDERKEY;
--��ʾ������������L_SHIPMODE in ('AIR','REG AIR')������������L_SHIPINSTRUCT ='DELIVER IN PERSON'�ļ�¼��ȱ��һƱ�������
select L1.L_ORDERKEY,L1.L_SHIPMODE,L2.L_SHIPINSTRUCT from LINEITEM L1,LINEITEM L2
where L1.L_ORDERKEY=L2.L_ORDERKEY and L1.L_ORDERKEY=1;
--ֻҪ��������L_SHIPMODE in ('AIR','REG AIR')������L_SHIPINSTRUCT ='DELIVER IN PERSON'������ü�¼����������
select distinct L1.L_ORDERKEY from LINEITEM L1,LINEITEM L2
where L1.L_SHIPMODE in ('AIR','REG AIR') and L2.L_SHIPINSTRUCT='DELIVER IN PERSON'
and L1.L_ORDERKEY=L2.L_ORDERKEY order by L1.L_ORDERKEY;
--�����������ļ�¼��
--��һ�ָ�д��ʽ
Select distinct L_ORDERKEY from LINEITEM
where L_SHIPMODE in ('AIR','REG AIR') and L_ORDERKEY not in (
select L_ORDERKEY from LINEITEM 
where L_SHIPINSTRUCT ='DELIVER IN PERSON');
--�ڶ��ָ�д����
Select distinct L_ORDERKEY from LINEITEM L1
where L_SHIPMODE in ('AIR','REG AIR') and not exists (
select * from LINEITEM L2 where L1.L_ORDERKEY=L2.L_ORDERKEY 
and L_SHIPINSTRUCT ='DELIVER IN PERSON');

--**�塢�����������ѯ**
--����4-46�����������ѯ������������á�
select C_COUNT, count (*) as custdist
from (
select C_CUSTKEY, count (O_ORDERKEY)
from CUSTOMER left outer join ORDERS on C_CUSTKEY = O_CUSTKEY
and O_COMMENT not like '%special%requests%'
group by C_CUSTKEY
) as C_ORDERS (C_CUSTKEY, C_COUNT)
group by C_COUNT
order by CUSTDIST desc, C_COUNT desc;
--with��д
WITH C_ORDERS (C_CUSTKEY, C_COUNT)
AS (
select C_CUSTKEY, count (O_ORDERKEY)
from CUSTOMER left outer join ORDERS on C_CUSTKEY = O_CUSTKEY
and O_COMMENT not like '%special%requests%'
group by C_CUSTKEY)
select C_COUNT, count (*) as custdist
from C_ORDERS group by C_COUNT
order by CUSTDIST desc, C_COUNT desc;

--����4-47��ͨ��ROW_NUMBER��������C_CUSTKEY����ͳ�ƵĶ�����������С���к�C_CUSTKEY���򲢷����кš�
select C_CUSTKEY, count (*) AS counter, 
ROW_NUMBER() over (ORDER BY counter) as RowNum
from ORDERS, CUSTOMER 
where O_CUSTKEY=C_CUSTKEY
group by C_CUSTKEY
order by counter, C_CUSTKEY;
--ͨ��WITH���ʽ�������
WITH custkey_counter(CUSTKEY, counter) 
AS (
select C_CUSTKEY, count (*) 
from ORDERS, CUSTOMER 
where O_CUSTKEY=C_CUSTKEY
group by C_CUSTKEY)
select CUSTKEY, counter, ROW_NUMBER() over (order by counter) as rownum 
from custkey_counter 
order by counter, CUSTKEY;

--TPCH���������մ����Ӳ�ѯ��SQL����ʹ�÷���

--����Ԫ�飬�ȸ���һ��ʵ���
drop table if exists region_test;
select * into region_test from region;
select * from region_test;
--�����¼�¼
insert into region_test(R_REGIONKEY, R_NAME)
values (5,'NORTH AMERICA');
insert into region_test
values(6,'SOURCE AMERICA',null);
--�鿴�����¼
select * from region_test;

--�����Ӳ�ѯ���
--�ȴ�����
drop table if exists custkey_counter;
create table custkey_counter(CUSTKEY int, counter int);
--����ѯ������봴���ı���
insert into custkey_counter
select C_CUSTKEY, count (*) 
from ORDERS, CUSTOMER 
where O_CUSTKEY=C_CUSTKEY
group by C_CUSTKEY;
--�鿴���
select CUSTKEY, counter, ROW_NUMBER() over (order by counter) as rownum 
from custkey_counter 
order by counter, CUSTKEY;
--����ۼ���������
drop table if exists custkey_counter1;
select C_CUSTKEY, count(*) as counter into custkey_counter1
from ORDERS, CUSTOMER 
where O_CUSTKEY=C_CUSTKEY
group by C_CUSTKEY;
--�鿴���
select * from custkey_counter1;

--Update�޸Ĳ���
select * from region_test;
update region_test set R_COMMENT='including Canada and USA' 
where R_NAME='NORTH AMERICA';
select * from region_test;
--�ָ�ԭʼ��ֵ
update region_test set R_COMMENT=Null 
where R_NAME='NORTH AMERICA';

--��������ѯ
update ORDERS set O_ORDERPRIORITY ='1-URGENT' 
from
(select L_ORDERKEY, 
avg (DATEDIFF(DAY, L_COMMITDATE,L_SHIPDATE)) as avg_delay
from LINEITEM
group by L_ORDERKEY 
having avg(DATEDIFF(DAY, L_COMMITDATE,L_SHIPDATE))>60) as order_delay
where L_ORDERKEY=O_ORDERKEY;
--ͨ��in�Ӳ�ѯ���츴�ϸ�������
update SUPPLIER set S_ACCTBAL=S_ACCTBAL*1.05
where S_NATIONKEY in (
select N_NATIONKEY from NATION where N_NAME='INDONESIA');


--PS������������������
--PS��������ת��Ϊ�����������Ƶķ���ת��order����lineitem������surrogate��
--����PS�������������������ֶ���Ϊ����������
--����������PARTSUPP_S����PARTSUPP���м�������
drop table if exists PARTSUPP_S;
select * into PARTSUPP_S from PARTSUPP;
--�޸ı�ṹ������һ�������ֶ���Ϊ�µĵ���������
alter table PARTSUPP_S add PS_KEY int Identity(1,1);
select * from PARTSUPP_S;
--����Lineitem�������������ӵ����
--����LINEITEM���¼��������LINEITEM_S��
drop table if exists LINEITEM_S;
select * into LINEITEM_S from LINEITEM;
--�����µ��ֶ���Ϊ�����������ע�ⲻ�������ֶΣ����ֵ��Ҫͨ�����Ӳ�������
alter table LINEITEM_S add L_KEY int;
--���Դ����ĸ������鿴��¼���������ֶ�
select top 20 * from PARTSUPP_S order by PS_KEY;
select top 20 * from LINEITEM_S;
--�ø�����������ӣ���PS������ֵ����L�����ֵ
update LINEITEM_S set L_KEY =PS_KEY
from PARTSUPP_S
where LINEITEM_S.l_partkey=PARTSUPP_S.ps_partkey and LINEITEM_S.l_suppkey=PARTSUPP_S.ps_suppkey;
--�����µĵ�����������Ƿ���ԭ����˫����������ȼ�
--ʹ��˫������������Ӳ�������Ӽ�¼����
select count(*) from LINEITEM,PARTSUPP
where L_PARTKEY=PS_PARTKEY and L_SUPPKEY=PS_SUPPKEY;
--ʹ�õ�������������Ӳ�������Ӽ�¼����
select count(*) from LINEITEM_S,PARTSUPP_S
where L_KEY=PS_KEY;


--deleteɾ������
ɾ������ȫ����¼
select * from custkey_counter1;
delete from custkey_counter1;
select * from custkey_counter1;
--�ָ�ɾ����insert��ձ�
insert into custkey_counter1
select C_CUSTKEY, count(*) as counter 
from ORDERS, CUSTOMER 
where O_CUSTKEY=C_CUSTKEY
group by C_CUSTKEY;
--����ɾ��
select * from region_test;
delete from region_test WHERE R_NAME='SOURCE AMERICA';
--�������¼ɾ��
delete from LINEITEM
where L_ORDERKEY in (
select O_ORDERKEY from ORDERS where O_ORDERSTATUS='F');

--����
select * from PARTSUPP where PS_PARTKEY=6 and PS_SUPPKEY=507;
select * from LINEITEM where L_ORDERKEY=578 and L_LINENUMBER=3;
begin transaction orderitem
update PARTSUPP set PS_AVAILQTY=PS_AVAILQTY-100
where PS_PARTKEY=6 and PS_SUPPKEY=507;
insert into LINEITEM (L_ORDERKEY, L_LINENUMBER, L_PARTKEY, L_SUPPKEY, L_QUANTITY) values(578,3,6,507,100);
commit transaction
--��ѯ��ɾ������ļ�¼
select * from LINEITEM where L_ORDERKEY=578 and L_LINENUMBER=3;
delete from LINEITEM where L_ORDERKEY=578 and L_LINENUMBER=3;
--��ͼ��ʹ��
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

--��ͼ��д
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

--TPCH������ͼ
--˼������������ӿ��ܴ������쳣����
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
--����ʹ�ñ���nation��region�������
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
--Υ����ͼ������Ψһ��Լ��


--�������1������ͼ��ֻ����supplier��customer������֮һ��nation��region�����ӹ�ϵ
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
--�������2��ͨ����������nation1��region1��
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
--�������3��ͨ��with����nation1��region1���ֱ��ʹ��
drop view if exists TPCH_view3;
create view TPCH_view3 as
with nation1(n1_nationkey,n1_name,n1_regionkey,n1_comment)
as (select * from NATION),--ע�⣺��2��with����ȱʡwith����������������֮���ö��ŷָ�
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
--��֤������ͼ��ѯ�������ȷ��
select count(*) from TPCH_view;
select count(*) from TPCH_view1;
select count(*) from TPCH_view2;
select count(*) from TPCH_view3;
select count(*) from LINEITEM;
--�����ܽ᣺��ͼ��ʹ�ñ�������ͬ���ֶ�����

--ɾ����ͼ
drop view revenue;

--��ͼ��ѯ
select count(*) from TPCH_view1 
where P_CONTAINER in ('WRAP BOX','MED CASE','JUMBO PACK');
--SQL������������ͼ��������ͼ�ϵĲ�ѯת��������ȼ۵�SQL���
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
--˼����BI���߹�ϵ�ϵĲ�ѯ���ܲ��������������
--1.�����ϵ���ͼ����
--����4-61������������ͼ��֧�ֵĸ��²�����
drop view if exists order_vital_items;
create view order_vital_items as
select O_ORDERKEY, O_ORDERSTATUS, O_TOTALPRICE,
O_ORDERDATE, O_ORDERPRIORITY 
from ORDERS 
where O_ORDERPRIORITY in ('1-URGENT','2-HIGH');
select * from order_vital_items where O_ORDERKEY=8 ;
select * from ORDERS where O_ORDERKEY=8 ;
delete from orders where O_ORDERKEY=8 ;
--�ɲ��룬����ͼ�в���ʾ
insert into order_vital_items values(8,'F',23453,'1998-03-23','3-MEDIUM');
--��ͼ���µȼ�SQL����
update order_vital_items set O_ORDERPRIORITY='3-MEDIUM' where O_ORDERDATE='1994-07-10';
update ORDERS set O_ORDERPRIORITY='3-MEDIUM' 
where O_ORDERDATE='1994-07-10' and O_ORDERPRIORITY in ('1-URGENT','2-HIGH');

--2.�����ϵľۼ���ͼ����
--����4-62������������ͼ��֧�ֵĸ��²�����
--��ͼORDERPRIORITY_countΪORDERS���Ϸ���ۼ��������
drop view if exists ORDERPRIORITY_count;
create view ORDERPRIORITY_count as 
select O_ORDERPRIORITY, count(*) as counter
from ORDERS
group by O_ORDERPRIORITY;
select * from ORDERPRIORITY_count;
--��֧�ֶԾۼ���¼�ĸ��²���
insert into ORDERPRIORITY_count values('6-VERY LOW',50678);
update ORDERPRIORITY_count set counter=50678 
where O_ORDERPRIORITY='1-URGENT';
delete from ORDERPRIORITY_count where O_ORDERPRIORITY='1-URGENT';
--3.���������ͼ����
--����4-63������������ͼ��֧�ֵĸ��²�����
--����NATION��REGION�������������ͼnation_region��
drop view if exists nation_region;
create view nation_region as
select * from NATION, REGION where N_REGIONKEY=R_REGIONKEY;
select * from nation_region;
--����������ܾ�����Ϊ��ͼ�еļ�¼���������������޷�����������ϵ�����-������չ�ϵ��
insert into nation_region values(25,'USA',1,1,'AMERICA');
--ɾ���������ܾ�����ͼ��Ӧ��NATION����REGION���ϴ�������-������չ�ϵ��������ͨ����ͼɾ����¼��
delete from nation_region where R_NAME='ASIA';
delete from nation_region where N_NAME='ALGERIA';
--�޸Ĳ�����ִ�С���һ��update�����޸���ͼ��NATION�����ԣ�ת��Ϊ��NATION���ϵ�update����update NATION set N_NAME='ALG' where N_NAME='ALGERIA';
update nation_region set N_NAME='ALG' where N_NAME='ALGERIA';
--�ڶ���update�����޸���ͼ��REGION�����ԣ��ȼ۵�SQL����Ϊupdate REGION set R_NAME='AFR' where R_NAME='AFRICA';���º���ͼ����ʾ������¼����б����£�ʵ�ʶ�ӦREGION����һ����¼���¡�
update nation_region set R_NAME='AFR' where R_NAME='AFRICA';
update nation_region set R_NAME='AME'  where R_NAME='AMERICA' and N_NAME='CANADA' ;

select * from NATION;
select * from REGION;
select * from nation_region;
--�ָ�ԭʼ����
update nation set N_NAME='ALGERIA' where N_NAME='ALG';
update region set R_NAME='AFRICA' where R_NAME='AFR';

--1.����JSON����
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
--2.JSON����ת��Ϊ��ϵ����
drop table if exists region_json;
SELECT * into region_json 
FROM OPENJSON(@jsonVariable)  
  WITH (id int 'strict $.id',  
        Location_Horizontal nvarchar(50) '$.Location.Horizontal_region', 
		Location_Vertical nvarchar(50) '$.Location.Vertical_region',  
        Population_B real, Area_million_km2 real);
select * from region_json;
--3.JSON���ݸ���Ϊ��ϵ������
--��1����REGION��������һ��JSON�����С�
drop table if exists region_json;
select * into region_json from region;
alter table region_json add json_col NVARCHAR(MAX);
--��2����JSON���ݸ��µ�JSON���С�
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
--��3���鿴���й�ϵ��JSON���ݡ�
SELECT  
r_name,
JSON_VALUE(json_col, '$.Location.Horizontal_region') AS Loca_H,
JSON_VALUE(json_col, '$.Location.Vertical_region') AS Loca_V,
JSON_VALUE(json_col, '$.Population_B') AS People, 
JSON_VALUE(json_col, '$.Area_million_km2') AS Area
FROM region_json;
select * from region_json;
--4.��SQL��ѯ��ʹ�ù�ϵ��JSON����
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
--5. JSON����
--����ѯ��ʹ��JSONֵ��Ϊ����������ѯʱ������ΪJSONֵ����������
SELECT R_NAME,
JSON_VALUE(json_col, '$.Location.Horizontal_region') AS Loca_H,
JSON_VALUE(json_col, '$.Location.Vertical_region') AS Loca_V,
JSON_VALUE(json_col, '$.Population_B') AS People, 
JSON_VALUE(json_col, '$.Area_million_km2') AS Area
FROM region_json
WHERE JSON_VALUE(json_col,'$.Location.Horizontal_region')='Eastern hemisphere';
--ΪJSON����ֵ����������Ҫ���²��裺
--1.���д���һ�������У�����JSON�м���������ֵ��
--2.���������ϴ���������
ALTER TABLE region_json 
ADD vHorizontal_region AS JSON_VALUE(json_col, '$.Location.Horizontal_region');
CREATE INDEX idx_json_Horizontal_region ON region_json(vHorizontal_region);
--6.��ϵ���ݿ����ΪJSON���ݸ�ʽ
--��NATION�����ΪJSON���ݸ�ʽ��
select * from NATION FOR JSON AUTO;
select * from NATION FOR JSON PATH,ROOT('Nations');
--https://www.sojson.com/simple_json.html��JSON����ת����
--1.����ͼ���ݿ�
--����ʾ��ͼ���ݿ�graphdemo��
drop DATABASE  if exists graphdemo;
CREATE DATABASE graphdemo;
USE  graphdemo;
--SQL�������������ͼ���ݿ�graphdemo����graphdemo��
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
--SQL�����������ڵ��Person��Restaurant��City��

drop table if exists likes;
drop table if exists friendOf;
drop table if exists livesIn;
drop table if exists locatedIn;
CREATE TABLE likes (rating INTEGER) AS EDGE;
CREATE TABLE friendOf AS EDGE;
CREATE TABLE livesIn AS EDGE;
CREATE TABLE locatedIn AS EDGE;
--SQL�����������߱�likes��friendOf��livesIn��locatedIn��ratingΪ��likes�����ԡ�
--2.����ͼ���� 
--ͨ��insert������ͼ���ݿ�graphdemo�й���ʾ�����ݡ�
INSERT INTO Person VALUES (1,'John');
INSERT INTO Person VALUES (2,'Mary');
INSERT INTO Person VALUES (3,'Alice');
INSERT INTO Person VALUES (4,'Jacob');
INSERT INTO Person VALUES (5,'Julie');
--SQL�������ڽڵ��Person�в���ʾ�����ݡ�

INSERT INTO Restaurant VALUES (1,'Taco Dell','Bellevue');
INSERT INTO Restaurant VALUES (2,'Ginger and Spice','Seattle');
INSERT INTO Restaurant VALUES (3,'Noodle Land', 'Redmond');
--SQL�������ڽڵ��Restaurant�в���ʾ�����ݡ�

INSERT INTO City VALUES (1,'Bellevue','wa');
INSERT INTO City VALUES (2,'Seattle','wa');
INSERT INTO City VALUES (3,'Redmond','wa');
--SQL�������ڽڵ��City�в���ʾ�����ݡ�

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
--SQL�������ڱ߱�likes�в���ʾ�����ݣ���ҪΪ��likes����$from_id��$to_id����$node_idֵ��

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
--SQL�������ڱ߱�livesIn�в���ʾ�����ݡ�

INSERT INTO locatedIn VALUES ((SELECT $node_id FROM Restaurant WHERE id = 1),
      (SELECT $node_id FROM City WHERE id =1));
INSERT INTO locatedIn VALUES ((SELECT $node_id FROM Restaurant WHERE id = 2),
      (SELECT $node_id FROM City WHERE id =2));
INSERT INTO locatedIn VALUES ((SELECT $node_id FROM Restaurant WHERE id = 3),
      (SELECT $node_id FROM City WHERE id =3));
--SQL�������ڱ߱�locatedIn�в���ʾ�����ݡ�

INSERT INTO friendof VALUES ((SELECT $NODE_ID FROM person WHERE ID = 1), (SELECT $NODE_ID FROM person WHERE ID = 2));
INSERT INTO friendof VALUES ((SELECT $NODE_ID FROM person WHERE ID = 2), (SELECT $NODE_ID FROM person WHERE ID = 3));
INSERT INTO friendof VALUES ((SELECT $NODE_ID FROM person WHERE ID = 3), (SELECT $NODE_ID FROM person WHERE ID = 1));
INSERT INTO friendof VALUES ((SELECT $NODE_ID FROM person WHERE ID = 4), (SELECT $NODE_ID FROM person WHERE ID = 2));
INSERT INTO friendof VALUES ((SELECT $NODE_ID FROM person WHERE ID = 5), (SELECT $NODE_ID FROM person WHERE ID = 4));
--SQL�������ڱ߱�friendof�в���ʾ�����ݡ�
--3.ͼ���ݲ�ѯ
--���Һ��ѡ�
SELECT Person2.name AS FriendName
FROM Person Person1, friendOf, Person Person2
WHERE MATCH(Person1-(friendOf)->Person2)
AND Person1.name = 'John';
--SQL�������ڽڵ��Person�в�����John�����ѹ�ϵ�ߣ�friendOf���Ľڵ㡣
--���Һ��ѵĺ��ѡ�
SELECT Person3.name AS FriendName 
FROM Person Person1, friendOf, Person Person2, friendOf friend2, Person Person3
WHERE MATCH(Person1-(friendOf)->Person2-(friend2)->Person3)
AND Person1.name = 'John';
--SQL�������ڽڵ��Person�в�����John���ѵ����ѣ�ͨ���߱������α����ڵ㡣
--���ҹ�ͬ�ĺ��ѡ�
SELECT Person1.name AS Friend1, Person2.name AS Friend2
FROM Person Person1, friendOf friend1, Person Person2, 
        friendOf friend2, Person Person0
WHERE MATCH(Person1-(friend1)->Person0<-(friend2)-Person2);
--SQL������������Person0��ͬ�������ѹ�ϵ��Person��
--����Johnϲ���Ĳ͹ݡ�
SELECT Restaurant.name
FROM Person, likes, Restaurant
WHERE MATCH (Person-(likes)->Restaurant)
AND Person.name = 'John';
--SQL����������Johnϲ���Ĳ͹ݡ�
--����John������ϲ���Ĳ͹ݡ�
SELECT Restaurant.name 
FROM Person person1, Person person2, likes, friendOf, Restaurant
WHERE MATCH(person1-(friendOf)->person2-(likes)->Restaurant)
AND person1.name='John';
--SQL������ͨ��friendOf�߱����John�����ѣ��ٲ���John����ϲ���Ĳ͹ݡ�
--����ϲ���Ĳ͹����ס��λ����ͬ���е��ˡ�
SELECT Person.name
FROM Person, likes, Restaurant, livesIn, City, locatedIn
WHERE MATCH (Person-(likes)->Restaurant-(locatedIn)->City 
AND Person-(livesIn)->City);
--SQL������ͨ��likes�߱���Ҳ͹ݣ�ͨ��locatedIn�߱�����������У�ͬʱ�����ס����ͬ�ĳ��С�

--��ѯSQL server����ҳ����ṹ
DBCC IND('TPCH_TEST','CUSTOMER',1)
--�鿴SQL server����ҳ�ڲ��洢�ṹ
DBCC TRACEON(2432)
DBCC PAGE(TPCH_TEST,1,2432,1)
DBCC PAGE(TPCH_TEST,1,2432,3)
--�鿴SQL server��ѯʱ����������״̬��
use TPCH_TEST
DBCC DROPCLEANBUFFERS
DBCC FREEPROCCACHE
SET STATISTICS IO ON  
SET STATISTICS TIME ON
SELECT SUM(P_SIZE) FROM PART;
SELECT SUM(P_SIZE) FROM PART;
SET STATISTICS IO OFF
SET STATISTICS TIME OFF
--�鿴��û�������ʹ�����������µ����ݿ���Ҳ��������ݷ������ܡ�
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
--ΪTPC-H��TPCH�����ݿ��LINEITEM�����ڴ��
--��1��Ϊ���ݿ�TPCH�����ڴ��Ż������ļ��鲢Ϊ�ļ�����������
ALTER DATABASE TPC_H ADD FILEGROUP TPCH_FG CONTAINS MEMORY_OPTIMIZED_DATA  
ALTER DATABASE TPC_H ADD FILE (NAME='TPCH_FG', FILENAME= 'C:\IM_DATA\TPCH_FG') TO FILEGROUP TPCH_FG;  
--��2�������ڴ��
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
--��3�������ݴ�lineorder�����ڴ��
insert into LINEITEM_IM select * from LINEITEM;
--��4��SQL��ѯ���ܶԱȲ���
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

--�����д洢�����������£�
CREATE NONCLUSTERED COLUMNSTORE INDEX csindx_LINEITEM
ON LINEITEM (L_QUANTITY, L_EXTENDEDPRICE, L_DISCOUNT, L_TAX, L_SHIPDATE, L_RETURNFLAG, L_LINESTATUS);
select sum(L_QUANTITY) from LINEITEM_IM;
select sum(L_QUANTITY) from LINEITEM;
--�����ڴ��д洢����
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
--��������
insert into LINEITEM_IM_CSI select * from LINEITEM;
--����
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
--��д���ѯ
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
and partkey=p_partkey   --������������partkey���ӱ��ʽ
and ps_supplycost =min_supplycost   --������������supplycost��ֵ���ʽ
and p_size = 15 and p_type like '%BRASS'
and s_nationkey = n_nationkey and n_regionkey = r_regionkey
and r_name = 'EUROPE' 
order by s_acctbal desc, n_name,s_name,p_partkey;

EXEC sp_configure 'external scripts enabled', 1;
RECONFIGURE WITH OVERRIDE
sp_configure
--��SQL Server����������launchpad

--python�����ھ���
--SQL������£�
--�½���Recency�����ڴ洢Recencyά�ȵ�����
drop table if exists Recency;
CREATE TABLE Recency(r_custkey VARCHAR(50),orderdate date, recency int);
INSERT INTO Recency SELECT c_custkey,o_orderdate,c_custkey FROM customer c,orders o
where c.c_custkey=o.o_custkey
GROUP BY c_custkey,o_orderdate;
UPDATE Recency SET recency= datediff(day,orderdate,'09-01-1998');
select * from recency
order by r_custkey;
--�½���ͼRFM_Model�����ڴ洢ÿһλ�û�RFM����ά�ȵ�����
drop view if exists RFM_Model;
CREATE VIEW RFM_Model(c_custkey,monetary,frequency,recency)
AS
SELECT c_custkey,cast(SUM(o_totalprice) as int),count(o_orderdate),min(recency)
FROM customer c,orders o,recency r
WHERE c.c_custkey=o.o_custkey and c.c_custkey=r_custkey
GROUP BY c_custkey;
--�粻��cast��������ת����sum����Զ�����Ϊdecimal(38,0),���¾���ʱ�������Ͳ�֧��
select * from RFM_Model
order by c_custkey;

--��SQL Server��ִ��Python�ű���ʵ�־��������������£�
--�����洢����customer_clusters
DROP procedure IF EXISTS [dbo].[customer_clusters];
CREATE procedure [dbo].[customer_clusters]
AS

BEGIN
    DECLARE
--������ͼRFM_Model�д洢������
	@input_query NVARCHAR(MAX) = N'
select c_custkey,monetary,frequency,recency
from RFM_Model
'
--1������Python�ű�������о������
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
--2��ִ�д洢���̣����������洢�ڱ� py_customer_clusters ��
--�����洢�������ı�
DROP TABLE IF EXISTS [dbo].[py_customer_clusters];
GO
--���д洢����Ԥ����
CREATE TABLE [dbo].[py_customer_clusters](
[c_custkey] [bigint] NULL, 
[monetary] [int] NULL, 
[frequency] [int] NULL, 
[recency] [int] NULL, 
[cluster] [int] NULL,
) ON [PRIMARY]
GO
--ִ�о�����������������������
INSERT INTO py_customer_clusters
EXEC [dbo].[customer_clusters];
--3���鿴������
--���ݸ���
SELECT * FROM py_customer_clusters; 

