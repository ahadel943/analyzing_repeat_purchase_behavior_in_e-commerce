-- Cancellation Impact on Customer Retention
-- Are customers with cancelled orders less likely to return and make future purchases?

-- NOTE: 2927 customers with at least one cancelled orders, 6910 customers with NO cancelled orders

with customers_with_cancelled_orders as (
  select distinct customer_id
  from orders
  where status = 'cancelled'
), all_customers as (
  select distinct customer_id
  from orders
), customer_completed_orders as (
  select
    customer_id,
    count(order_id) as completed_orders_count
  from orders
  where status = 'completed'
  group by customer_id
)
select
  case
    when cwco.customer_id is null then 'with_cancelled_orders'
    else 'without_cancelled_orders'
  end as customer_group,
  count(distinct ac.customer_id) as total_customers,
  count(distinct ac.customer_id) filter (where cco.completed_orders_count > 1) as repeat_customers,
  round(
    count(distinct ac.customer_id)
      filter (where cco.completed_orders_count > 1) * 100.0 / count(distinct ac.customer_id), 2
  ) as repeat_purchase_rate
from all_customers as ac
left join customers_with_cancelled_orders as cwco on ac.customer_id = cwco.customer_id
left join customer_completed_orders as cco on ac.customer_id = cco.customer_id
group by customer_group
order by repeat_purchase_rate desc;



