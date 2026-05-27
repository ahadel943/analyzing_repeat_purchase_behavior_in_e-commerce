-- data check
select * from customers limit 10;
select count(*) from customers; -- 10000 total customers

select * from orders limit 10;
select count(*) from orders; -- 25096 total orders

select * from products limit 10;
select count(*) from products; -- 1200 total products

select * from order_items limit 10;
select count(*) from order_items; -- 62454 total records/rows

-- customers count by customer type
select customer_type, count(*) as customer_type_count
from customers
group by customer_type
order by customer_type_count asc;
/*
loyal => 2000 customers
occasional => 3000 customers
one_time => 5000 customers
*/

select count(distinct city) from customers; -- customers distributed over 5 cities
select distinct city from customers;

-- customers count by city
select city, count(*) as customers_count
from customers
group by city
order by customers_count asc;
/*
Tanta => 1938 customers
Cairo => 1995 customers
Alex => 2010 customers
Giza => 2011 customers
Mansoura => 2046 customers
*/

select distinct extract(year from signup_date) as signup_year
from customers;

-- show column names
select column_name, data_type, is_nullable from information_schema.columns where table_name = 'order_items';

-- null check
-- no null values where found in customers table
SELECT
    count(*) filter ( where customer_id is null ) as customer_id_nulls,
    count(*) filter ( where signup_date is null ) as signup_date_nulls,
    count(*) filter ( where city is null ) as city_nulls,
    count(*) filter ( where created_at is null ) as created_at_nulls,
    count(*) filter ( where customer_type is null ) as customer_type_nulls
FROM customers;

-- no null values where found in orders table
select
    count(*) filter ( where order_id is null ) as order_id_nulls,
    count(*) filter ( where customer_id is null ) as customer_id_nulls,
    count(*) filter ( where order_date is null ) as order_date_nulls,
    count(*) filter ( where total_amount is null ) as total_amount_nulls,
    count(*) filter ( where status is null ) as status_nulls,
    count(*) filter ( where created_at is null ) as created_at_nulls
from orders;

-- no null values where found in products table
select
    count(*) filter ( where product_id is null ) as product_id_nulls,
    count(*) filter ( where product_name is null ) as product_name_nulls,
    count(*) filter ( where category is null ) as category_nulls,
    count(*) filter ( where price is null ) as price_nulls,
    count(*) filter ( where product_type is null ) as product_type_nulls,
    count(*) filter ( where created_at is null ) as created_at_nulls
from products;

-- no null values where found in order_items table
select
    count(*) filter ( where order_item_id is null ) as order_item_id_nulls,
    count(*) filter ( where order_id is null ) as order_id_nulls,
    count(*) filter ( where product_id is null ) as product_id_nulls,
    count(*) filter ( where quantity is null ) as quantity_nulls,
    count(*) filter ( where price is null ) as price_nulls
from order_items;

-- duplicates check
-- no duplicates
select
    customer_id,
    count(*) as du_count
from customers
group by customer_id, signup_date, city
having count(*) > 1; -- empty result means no duplicates

select count(*) = count( distinct customer_id ) null_check from customers; -- true means no duplicates