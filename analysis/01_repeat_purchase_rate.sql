-- Overall Repeat Purchase Behavior
-- What percentage of customers make repeat purchases, and does the platform demonstrate strong customer retention behavior?

with customer_completed_orders as (
  select
      customer_id,
      count(order_id) as completed_orders_count
  from orders
  where status = 'completed'
  group by customer_id
)
select
  count(customer_id) as total_customers_with_completed_orders,
  count(customer_id) filter(where completed_orders_count > 1) as customers_with_repeated_order,
  round(count(customer_id) filter (where completed_orders_count > 1) * 100.0 / count(*), 2) as repeat_purchase_rate
from customer_completed_orders;

with customer_completed_orders as (
  select
      o.customer_id,
      count(o.order_id) as completed_orders_count
  from orders as o
  where o.status = 'completed'
  group by o.customer_id
)
select
  count(customer_id) filter(where completed_orders_count = 1) as repeat_customers
from customer_completed_orders;




