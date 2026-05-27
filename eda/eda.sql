-- check current database
select current_database();

-- list tables in the current database
select tablename from pg_catalog.pg_tables where schemaname = 'public';

-- check columns names and datatypes
select column_name, data_type, is_nullable from information_schema.columns where table_name = 'customers';
select column_name, data_type, is_nullable from information_schema.columns where table_name = 'products';
select column_name, data_type, is_nullable from information_schema.columns where table_name = 'orders';
select column_name, data_type, is_nullable from information_schema.columns where table_name = 'order_items';

-- check for duplicates
/*
  - No missing valus in the customers table
  - No missing valus in the products table
  - No missing valus in the orders table
  - No missing valus in the orer_items table
*/
select
  count(*) - count(customer_id) as missing_customer_id,
  count(*) - count(signup_date) as missing_signup_date,
  count(*) - count(customer_type) as missing_customer_type,
  count(*) - count(city) as missing_city,
  count(*) - count(created_at) as missing_created_at
from customers;

select
  count(*) - count(product_id) as missing_product_id,
  count(*) - count(product_name) as missing_product_name,
  count(*) - count(category) as missing_category,
  count(*) - count(price) as missing_price,
  count(*) - count(product_type) as missing_product_type,
  count(*) - count(created_at) as missing_created_at
from products;

select
  count(*) - count(order_item_id) as missing_order_item_id,
  count(*) - count(order_id) as missing_order_id,
  count(*) - count(product_id) as missing_product_id,
  count(*) - count(quantity) as missing_quantity,
  count(*) - count(price) as missing_price
from order_items;

select
  count(*) - count(order_id) as missing_order_id,
  count(*) - count(customer_id) as missing_customer_id,
  count(*) - count(order_date) as missing_order_date,
  count(*) - count(total_amount) as missing_total_amount,
  count(*) - count(status) as missing_status,
  count(*) - count(created_at) as missing_created_at
from orders;

-- check for primary key (IDs) uniqueness
/*
  - No duplicates founf in the customer_id column
  - No duplicates founf in the product_id column
  - No duplicates founf in the order_id column
  - No duplicates founf in the order_item_id column
*/
select
  customer_id,
  count(*) as duplicates_count
from customers
group by customer_id
having count(*) > 1;

select
  product_id,
  count(*) as duplicates_count
from products
group by product_id
having count(*) > 1;

select
  order_id,
  count(*) as duplicates_count
from orders
group by order_id
having count(*) > 1;

select
  order_item_id,
  count(*) as duplicates_count
from order_items
group by order_item_id
having count(*) > 1;

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
select
  customer_type,
  customers_type_count,
  sum(customers_type_count) over() as total_count,
  round(customers_type_count / sum(customers_type_count) over(), 2) as percentage
from (
  select
    customer_type,
    count(*) as customers_type_count
  from customers
  group by customer_type
  order by customers_type_count desc
) as d;

-- customers distribution by city
select
  city,
  count(customer_id) as customer_count
from customers
group by city
order by 2 desc;






