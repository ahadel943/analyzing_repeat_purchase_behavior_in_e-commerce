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
  round(customers_type_count * 100 / sum(customers_type_count) over(), 2) as percentage
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

-- customers by signup date
select 
  extract(year from signup_date) as year,
  extract(month from signup_date) as month,
  to_char(signup_date,'Mon') as month_name,
  count(customer_id) as customers_count
from customers
group by year, month, month_name
order by year, month, month_name;

-- customers count by signup date
select 
  extract(year from signup_date) as year,
  extract(month from signup_date) as month,
  extract(day from signup_date) as day,
  count(customer_id) as customers_count
from customers
group by year, month, day
order by year, month, day;

-- products distribution by category and product type
select
  category,
  product_type,
  count(product_id) as product_count
from products
group by category, product_type
order by category, product_type;

-- products price stats
select
  min(price) as min_price,
  max(price) as max_price,
  round(avg(price), 2) as avg_price,
  max(price) - min(price) as price_range,
  percentile_cont(0.25) within group (order by price) as "1st_quratile",
  percentile_cont(0.50) within group (order by price) as "median / 2nd_quratile",
  percentile_cont(0.75) within group (order by price) as "3rd_quratile",
  round(stddev_pop(price), 2) as standard_deviation
from products;

-- products price by category
select
  category,
  count(product_id) as product_count,
  round(avg(price), 2) as category_avg_price,
  min(price) as category_min_price,
  max(price) as category_max_price
from products
group by category
order by category_avg_price desc;

-- the 10 products with the highest prices
select
  product_name,
  category,
  price
from products
order by price desc
limit 10;

-- the 10 products with the lowest prices
select
  product_name,
  category,
  price
from products
order by price asc
limit 10;

-- orders by status
select
  status,
  count(order_id) as status_order_count,
  sum(count(order_id)) over() as tottal_order_count,
  round(count(order_id) * 100 / sum(count(order_id)) over(), 2) as percentage
from orders
group by status;

-- comleted orders over time (monthly)
select
  extract(year from order_date) as year,
  extract(month from order_date) as month,
  to_char(order_date, 'Mon') as month_name,
  count(order_id) as order_count,
  round(avg(total_amount), 2) as avg_order_value,
  sum(total_amount) as monthly_revenue
  -- round(sum(sum(total_amount)) over() / sum(count(order_id)) over(), 2) as total_aov
from orders
where status = 'completed'
group by year, month, month_name
order by year, month, month_name;

select min(order_date)
from orders; -- 2022-10-09 00:00:00

select max(order_date)
from orders; -- 2024-01-02 00:00:00

-- orders value stats
select
  min(total_amount) as min_order_value,
  max(total_amount) as max_order_value,
  round(avg(total_amount), 2) as avg_order_value,
  percentile_cont(0.25) within group (order by total_amount) as "1st_quartile",
  percentile_cont(0.50) within group (order by total_amount) as "median / 2nd_quartile",
  percentile_cont(0.75) within group (order by total_amount) as "3rd quartile"
from orders
where status = 'completed';

-- orders count ditribution by order value
select
  case
    when total_amount > 50 and total_amount < 500 then '50-500'
    when total_amount > 500 and total_amount < 1000 then '500-1000'
    when total_amount > 1000 and total_amount < 2000 then '1000-2000'
    when total_amount > 2000 and total_amount < 4000 then '2000-4000'
    when total_amount > 4000 and total_amount < 7000 then '4000-7000'
    when total_amount > 7000 and total_amount < 10000 then '7000-10000'
    else '10000+'
  end as order_value_bucket,
  count(order_id) as order_count
from orders
where status = 'completed'
group by order_value_bucket;

-- total sales by category
select
  p.category,
  sum(io.quantity) as total_quantity_sold,
  sum(io.quantity * io.price) as category_total_revenue,
  round(avg(io.price), 2) as avg_selling_price,
  sum(sum(io.quantity * io.price)) over() as overall_total_revenue
from order_items as io
join products as p on io.product_id = p.product_id
join orders as o on io.order_id = o.order_id
where o.status = 'completed'
group by p.category
order by category_total_revenue desc;

-- average order value by customer type
select 
  customer_type,
  count(distinct o.order_id) as orders_count,
  round(avg(o.total_amount), 2) as avg_order_value,
  sum(o.total_amount) as total_revenue
from orders as o
join customers as c on o.customer_id = c.customer_id
where o.status = 'completed'
group by c.customer_type
order by avg_order_value desc;




