-- Revenue Contribution of Repeat Customers
-- How much do repeat customers contribute to overall revenue and order volume?

with customer_completed_orders as (
  select
    customer_id,
    count(order_id) as completed_orders_count
  from orders
  where status = 'completed'
  group by customer_id
), orders_revenue as (
  select 
    o.customer_id,
    o.total_amount,
    cco.completed_orders_count
  from orders as o
  join customer_completed_orders as cco on o.customer_id = cco.customer_id
  where o.status = 'completed'
), segmented_revenue as (
  select
    case 
      when completed_orders_count > 1 then 'repeat_customers'
      else 'one_time_customers'
    end as customer_segment,
    total_amount
  from orders_revenue
)
select
  customer_segment,
  sum(total_amount) as revenue,
  count(*) as orders_count,
  round(sum(total_amount) * 100.0 / sum(sum(total_amount)) over(), 2) as revenue_share
from segmented_revenue
group by customer_segment;
