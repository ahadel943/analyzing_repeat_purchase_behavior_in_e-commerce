--Pricing Impact on Repeat Purchases
--Does product or order pricing influence customers’ likelihood of making repeat purchases?

with customers_order_value_buckets as (
  select
    o.customer_id,
    case
      when o.total_amount > 50 and o.total_amount < 500 then '50-500'
      when o.total_amount > 500 and o.total_amount < 1000 then '500-1000'
      when o.total_amount > 1000 and o.total_amount < 2000 then '1000-2000'
      when o.total_amount > 2000 and o.total_amount < 4000 then '2000-4000'
      when o.total_amount > 4000 and o.total_amount < 7000 then '4000-7000'
      when o.total_amount > 7000 and o.total_amount < 10000 then '7000-10000'
      else '10000+'
    end as order_value_bucket
  from orders as o
  where o.status = 'completed'
), customers_completed_orders as (
  select
    o.customer_id,
    count(order_id) as completed_orders_count
  from orders as o
  where o.status = 'completed'
  group by o.customer_id
)
select
  order_value_bucket,
  count(distinct covb.customer_id) as total_customers,
  count(distinct covb.customer_id) filter(where completed_orders_count > 1) as repeat_customers,
  round(100 * count(distinct covb.customer_id) filter(where completed_orders_count > 1) / count(distinct covb.customer_id), 2) as repeat_purchase_rate_by_order_value_buket
from customers_order_value_buckets as covb
join customers_completed_orders as cco
  on covb.customer_id = cco.customer_id
group by order_value_bucket;






