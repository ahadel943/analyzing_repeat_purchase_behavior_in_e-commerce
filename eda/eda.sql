-- check current database
select current_database();

-- list tables in the current database
select tablename from pg_catalog.pg_tables where schemaname = 'public';

-- show column names
select column_name, data_type, is_nullable from information_schema.columns where table_name = 'customers';

-- check each table rows count
select 'customers' as table_name, count(*) as row_count from customers
union all
select 'products', count(*) from products
union all
select 'orders', count(*) from orders
union all
select 'order_items', count(*) from order_items;

-- data sample check, last 10 rows
select * from customers order by created_at desc limit 10;
select * from products order by created_at desc limit 10;
select * from orders order by order_date desc limit 10;

-- customers distribution by customer type
/*
  
*/
select 
  customer_type,
  customers_count,
  round((customers_count * 100.0 / (select count(*) from customers)), 2) as percentage
from (
  select
    customer_type,
    count(*) as customers_count
  from customers
  group by customer_type
) as d
order by customers_count desc;

-- customers distribution by city
select city, count(*) as customers_count
from customers
group by city
order by customers_count desc;

-- customers distribution by signup_date(year, month)
select
  extract(year from signup_date) as year,
  extract(month from signup_date) as month,
  count(*) as customers_count
from customers
group by year, month
order by year, month desc;

