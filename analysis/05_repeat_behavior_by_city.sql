-- Geographic Differences in Repeat Behavior
-- Does repeat purchase behavior vary across different cities or regions

with customer_completed_orders as (
  select
    customer_id,
    count(order_id) as completed_orders_count
  from orders
  where status = 'completed'
  group by customer_id
), customers_city as (
  select
    customer_id,
    city
  from customers
)
select
  cc.city,
  count(distinct cc.customer_id) as total_customers,
  count(distinct cco.customer_id) filter(where completed_orders_count > 1) as repeat_customers,
  round(
    100 * count(distinct cco.customer_id) filter(where completed_orders_count > 1) / count(distinct cco.customer_id),
  2) as repeat_purchase_rate
from customers_city as cc
left join customer_completed_orders as cco on cc.customer_id = cco.customer_id
group by cc.city
order by repeat_purchase_rate desc;









