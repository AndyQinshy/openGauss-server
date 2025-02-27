create schema test_smp;
set search_path=test_smp;

create table t1(a int, b int, c int, d bigint);
insert into t1 values(generate_series(1, 100), generate_series(1, 10), generate_series(1, 2), generate_series(1, 50));
create table t2(a int, b int);
insert into t2 values(generate_series(1, 10), generate_series(1, 30));
create table t3(a int, b int, c int);
insert into t3 values(generate_series(1, 50), generate_series(1, 100), generate_series(1, 10));
create table t4(id int, val text);
insert into t4 values(generate_series(1,1000), random());
create index on t4(id);

analyze t1;
analyze t2;
analyze t3;
analyze t4;

set query_dop=1002;
explain (costs off) select * from t2 order by 1,2;
select * from t2 order by 1,2;

set enable_nestloop=on;
set enable_mergejoin=off;
set enable_hashjoin=off;
explain (costs off) select t1.a,t2.b from t1, t2 where t1.a = t2.a order by 1,2;
select t1.a,t2.b from t1, t2 where t1.a = t2.a order by 1,2;

set enable_nestloop=off;
set enable_hashjoin=on;
explain (costs off) select t1.a,t2.b,t3.c from t1, t2, t3 where t1.a = t2.a and t1.b = t3.c order by 1,2,3;
select t1.a,t2.b,t3.c from t1, t2, t3 where t1.a = t2.a and t1.b = t3.c order by 1,2,3;

set enable_nestloop=on;
explain (costs off) select a, avg(b), sum(c) from t1 group by a order by 1,2,3;
select a, avg(b), sum(c) from t1 group by a order by 1,2,3;

explain (costs off) select median(a) from t1;
select median(a) from t1;

explain (costs off) select first(a) from t1;
select first(a) from t1;

explain (costs off) select sum(b)+median(a) as result from t1;
select sum(b)+median(a) as result from t1;

explain (costs off) select a, count(distinct b) from t1 group by a order by 1 limit 10;
select a, count(distinct b) from t1 group by a order by 1 limit 10;

explain (costs off) select count(distinct b), count(distinct c) from t1 limit 10;
select count(distinct b), count(distinct c) from t1 limit 10;

explain (costs off) select distinct b from t1 union all select distinct a from t2 order by 1;
select distinct b from t1 union all select distinct a from t2 order by 1;

explain (costs off) select * from t1 where t1.a in (select t2.a from t2, t3 where t2.b = t3.c) order by 1,2,3;
select * from t1 where t1.a in (select t2.a from t2, t3 where t2.b = t3.c) order by 1,2,3;

explain (costs off) with s1 as (select t1.a as a, t3.b as b from t1,t3 where t1.b=t3.c) select * from t2, s1 where t2.b=s1.a order by 1,2,3,4;
with s1 as (select t1.a as a, t3.b as b from t1,t3 where t1.b=t3.c) select * from t2, s1 where t2.b=s1.a order by 1,2,3,4;

explain (costs off) select * from t1 order by a limit 10;
select * from t1 order by a limit 10;

explain (costs off) select * from t1 order by a limit 10 offset 20;
select * from t1 order by a limit 10 offset 20;

-- test limit and offset
explain (costs off) select * from t1 limit 1;

explain (costs off) select * from t1 limit 1 offset 10;

explain (costs off) select * from t1 order by 1 limit 1 offset 10;
-- test subquery recursive
explain (costs off) select (select max(id) from t4);
select (select max(id) from t4);

explain (costs off) select * from (select a, rownum as row from (select a from t3) where rownum <= 10) where row >=5;
select * from (select a, rownum as row from (select a from t3) where rownum <= 10) where row >=5;

CREATE TABLE bmsql_item (
i_id int NoT NULL,
i_name varchar(24),
i_price numeric(5,2),
i_data varchar( 50),
i_im_id int
);
insert into bmsql_item values ('1','sqltest_varchar_1','0.01','sqltest_varchar_1','1') ;
insert into bmsql_item values ('2','sqltest_varchar_2','0.02','sqltest_varchar_2','2') ;
insert into bmsql_item values ('3','sqltest_varchar_3','0.03','sqltest_varchar_3','3') ;
insert into bmsql_item values ('4','sqltest_varchar_4','0.04','sqltest_varchar_4','4') ;
insert into bmsql_item(i_id) values ('5');

create table bmsql_warehouse(
w_id int not null,
w_ytd numeric(12,2),
w_tax numeric(4,4),
w_name varchar(10),
w_street_1 varchar(20),
w_street_2 varchar(20),
w_city varchar(20),
w_state char(2),
w_zip char(9)
);
insert into bmsql_warehouse values('1','0.01','0.0001','sqltest_va','sqltest_varchar_1','sqltest_varchar_1','sqltest_varchar_1','sq','sqltest_b');
insert into bmsql_warehouse values('2','0.02','0.0002','sqltest_va','sqltest_varchar_2','sqltest_varchar_2','sqltest_varchar_2','sq','sqltest_b');
insert into bmsql_warehouse values('3','0.03','0.0003','sqltest_va','sqltest_varchar_3','sqltest_varchar_3','sqltest_varchar_3','sq','sqltest_b');
insert into bmsql_warehouse values('4','0.04','0.0004','sqltest_va','sqltest_varchar_4','sqltest_varchar_4','sqltest_varchar_4','sq','sqltest_b');
insert into bmsql_warehouse(w_id) values('5');

set query_dop=4;

explain (costs off) select 0.01
from bmsql_item
intersect
select first_value(i_price) over (order by 2)
from bmsql_item
where i_id <=(select w_id from bmsql_warehouse
where bmsql_item.i_name not like 'sqltest_varchar_2' order by 1 limit 1)
group by i_price;

select 0.01
from bmsql_item
intersect
select first_value(i_price) over (order by 2)
from bmsql_item
where i_id <=(select w_id from bmsql_warehouse
where bmsql_item.i_name not like 'sqltest_varchar_2' order by 1 limit 1)
group by i_price;

--clean
set search_path=public;
drop schema test_smp cascade;
