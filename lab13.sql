alter session set nls_date_format='dd-mm-yyyy hh24:mi:ss';

create tablespace t1 datafile 't1.DAT'
size 10M reuse autoextend on next 2M maxsize 20M;
create tablespace t2 datafile 't2.DAT'
size 10M reuse autoextend on next 2M maxsize 20M;  
create tablespace t3 datafile 't3.DAT'
size 10M reuse autoextend on next 2M maxsize 20M;  
create tablespace t4 datafile 't4.DAT'
size 10M reuse autoextend on next 2M maxsize 20M;

grant create tablespace to sys;
alter user sys quota unlimited on t1;
alter user sys quota unlimited on t2;
alter user sys quota unlimited on t3;
alter user sys quota unlimited on t4;

drop table T_RANGE;
drop table T_INTERVAL;
drop table T_HASH;
drop table T_LIST;

//1.	Создайте таблицу T_RANGE c диапазонным секционированием. 
// Используйте ключ секционирования типа NUMBER.
create table T_RANGE( id number, TIME_ID date)
partition by range(id)
(
    partition P1 values less than (100) tablespace T1,
    partition P2 values less than (200) tablespace T2,
    partition P3 values less than (300) tablespace T3,
    partition PMAX values less than (maxvalue) tablespace T4
);
    
insert into T_RANGE(id, TIME_ID) values(50,  '01-02-2018');
insert into T_RANGE(id, TIME_ID) values(105, '01-02-2017');
insert into T_RANGE(id, TIME_ID) values(205, '01-02-2016');
insert into T_RANGE(id, TIME_ID) values(305, '01-02-2015');
insert into T_RANGE(id, TIME_ID) values(405, '01-02-2015');

select * from T_RANGE partition(p1);
select * from T_RANGE partition(p2);
select * from T_RANGE partition(p3);
select * from T_RANGE partition(pmax);

select TABLE_NAME, PARTITION_NAME, HIGH_VALUE, TABLESPACE_NAME
from USER_TAB_PARTITIONS 
where table_name = 'T_RANGE';

//2.	Создайте таблицу T_INTERVAL c интервальным секционированием. 
// Используйте ключ секционирования типа DATE.
create table T_INTERVAL(id number, time_id date)
partition by range(time_id)
interval (numtoyminterval(1,'month'))
(
    partition p0 values less than(to_date ('1-12-2009', 'dd-mm-yyyy')),
    partition p1 values less than(to_date ('1-12-2015', 'dd-mm-yyyy')),
    partition p2 values less than(to_date ('1-12-2018', 'dd-mm-yyyy'))
);

insert into T_INTERVAL(id, time_id) values(50, '01-02-2008');
insert into T_INTERVAL(id, time_id) values(105,'01-01-2009');
insert into T_INTERVAL(id, time_id) values(105,'01-01-2014');
insert into T_INTERVAL(id, time_id) values(205,'01-01-2015');
insert into T_INTERVAL(id, time_id) values(305,'01-01-2016');
insert into T_INTERVAL(id, time_id) values(405,'01-01-2018');
insert into T_INTERVAL(id, time_id) values(505,'01-01-2019');

select * from T_INTERVAL partition(p0);
select * from T_INTERVAL partition(p1);
select * from T_INTERVAL partition(P2);
select * from T_INTERVAL partition(SYS_P321);

select TABLE_NAME, PARTITION_NAME, HIGH_VALUE, TABLESPACE_NAME
from USER_TAB_PARTITIONS 
where table_name = 'T_INTERVAL';

//3.	Создайте таблицу T_HASH c хэш-секционированием. 
// Используйте ключ секционирования типа VARCHAR2.
create table T_HASH (str varchar2 (50), id number)
partition by hash (str)
(
    partition k1 tablespace t1,
    partition k2 tablespace t2,
    partition k3 tablespace t3,
    partition k4 tablespace t4
);

insert into T_HASH (STR,id) values('baby pudge', 1);
insert into T_HASH (str,id) values('leha aleskey', 2);
insert into T_HASH (STR,id) values('gg wp unluck', 3);
insert into T_HASH (STR,id) values('pudge hook', 4);
insert into T_HASH (str,id) values('fhfjfjskskdfksdf', 7);

select * from T_HASH partition(K1);
select * from T_HASH partition(k2);
select * from T_HASH partition(K3);
select * from T_HASH partition(K4);

select TABLE_NAME, PARTITION_NAME, HIGH_VALUE, TABLESPACE_NAME
from USER_TAB_PARTITIONS 
where table_name = 'T_HASH';

//4.	Создайте таблицу T_LIST со списочным секционированием. 
// Используйте ключ секционирования типа CHAR.
create table T_LIST(obj char(3))
partition by list (obj)
(
    partition p1 values ('1'),
    partition p2 values ('2'),
    partition p3 values ('3')
);

insert into T_LIST(obj) values('1');
insert into T_LIST(OBJ) values('2');
insert into T_LIST(OBJ) values('3');
insert into T_LIST(obj) values('4');

select * from T_LIST partition (p1);
select * from T_LIST partition (p2);
select * from T_LIST partition (p3);

select TABLE_NAME, PARTITION_NAME, HIGH_VALUE, TABLESPACE_NAME
from USER_TAB_PARTITIONS 
where table_name = 'T_LIST';

//6.	Продемонстрируйте для всех таблиц процесс перемещения строк между секциями, при изменении (оператор UPDATE) ключа секционирования.
alter table T_LIST enable row movement;
update T_LIST set obj='1' where obj='2';

alter table T_RANGE enable row movement;
update T_RANGE set id=55 where id=105;

alter table T_INTERVAL enable row movement;
update T_INTERVAL set time_id='01-01-2000' where time_id='01-01-2014';

drop table T_INTERVAL;
drop table T_RANGE;
drop table T_HASH;
drop table T_LIST;

//7.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE MERGE.
alter table T_RANGE merge partitions p1,p2 into partition p5;

select * from T_RANGE partition(p5);

//8.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE SPLIT.
alter table T_INTERVAL split partition p2 at (to_date ('1-06-2017', 'dd-mm-yyyy')) 
    into (partition p6 tablespace t4, partition p5 tablespace t2);
    
select * from T_INTERVAL partition (p5);
select * from T_INTERVAL partition (p6);

//9.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE EXCHANGE.
create table T_LIST1(obj char(3));
alter table T_LIST exchange partition  p3 
    with table T_LIST1 without validation;
        
select * from T_LIST partition (p3);
select * from T_LIST1;

// *. ref
create table salesR
(
    prod_id NUMBER,
    time_id DATE,
    fact_id NUMBER CONSTRAINT sales_pk PRIMARY KEY
)
PARTITION BY RANGE (time_id)
(
    PARTITION sales_11q1 VALUES LESS THAN (to_date ('01-04-2011', 'dd-mm-yyyy')),
    PARTITION sales_11q2 VALUES LESS THAN (to_date ('01-07-2011', 'dd-mm-yyyy')),
    PARTITION sales_max  VALUES LESS THAN (MAXVALUE)
);

create table salesR_details
(
    details_id NUMBER,
    fact_id NUMBER NOT NULL
    CONSTRAINT sales_details_fk REFERENCES salesR(fact_id)
)
PARTITION BY REFERENCE (sales_details_fk);

insert into SALESR(prod_id, time_id, fact_id) values(1,  '01-02-2010', 2);
insert into SALESR(prod_id, time_id, fact_id) values(2,  '01-02-2011', 3);
insert into SALESR(prod_id, time_id, fact_id) values(3,  '01-06-2011', 4);
insert into SALESR(prod_id, time_id, fact_id) values(4,  '01-02-2013', 5);

select * from SALESR partition (SALES_11Q1);
select * from SALESR partition (SALES_11Q2);
select * from SALESR partition (SALES_MAX);

insert into SALESR_DETAILS(details_id, fact_id) values(10, 2);
insert into SALESR_DETAILS(details_id, fact_id) values(11, 3);
insert into SALESR_DETAILS(details_id, fact_id) values(12, 4);
insert into SALESR_DETAILS(details_id, fact_id) values(13, 5);

select * from SALESR_DETAILS partition (SALES_11Q1);
select * from SALESR_DETAILS partition (SALES_11Q2);
select * from SALESR_DETAILS partition (SALES_MAX);

select TABLE_NAME, PARTITION_NAME, HIGH_VALUE, TABLESPACE_NAME
from USER_TAB_PARTITIONS 
where table_name = 'SALESR';

select TABLE_NAME, PARTITION_NAME, HIGH_VALUE, TABLESPACE_NAME
from USER_TAB_PARTITIONS 
where table_name = 'SALESR_DETAILS';