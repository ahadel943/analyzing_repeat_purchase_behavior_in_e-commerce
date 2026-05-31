-- Repeat Purchase by Product Category
-- Do certain product categories show weaker repeat purchase behavior compared to others?

with customers_category as (
  select
    p.category,
    o.customer_id
  from orders as o
  join order_items as oi 
    on o.order_id = oi.order_id
  join products as p
    on oi.product_id = p.product_id
  where o.status = 'completed'
), customer_completed_orders as (
  select
    o.customer_id,
    count(o.order_id) as completed_orders_count
  from orders as o
  where o.status = 'completed'
  group by o.customer_id
)
select
  cc.category,
  count(distinct cc.customer_id) as total_customers,
  count(distinct cc.customer_id) filter(where completed_orders_count > 1) as repeat_customers,
  round(count(distinct cc.customer_id) filter(where completed_orders_count > 1) * 100 / count(distinct cc.customer_id), 2) as repeat_purchase_rate_by_category
from customers_category as cc
join customer_completed_orders as cco
  on cc.customer_id = cco.customer_id
group by cc.category;


-- repeat_purchase_rate_by_category






