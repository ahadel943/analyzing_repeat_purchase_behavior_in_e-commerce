-- Time-Based Purchasing Trends
-- Has repeat purchase behavior changed over time, or remained stable throughout the observed period?

select min(order_date) from orders;

select
  customer_id,
  min(order_date) as first_order_date
from orders
where status = 'completed'
group by customer_id;

with first_completed_order as (
  select
      customer_id,
      min(order_date) as first_order_date
  from orders
  where status = 'completed'
  group by customer_id
)
select
  extract(year from o.order_date) as "year",
  extract(month from o.order_date) as "month",
  to_char(o.order_date,'Mon') as month_name,
  count(distinct o.customer_id) as total_customers,
  count(distinct o.customer_id) filter (where fco.first_order_date < date_trunc('month', o.order_date)) as repeat_customers,
  round(
    100.0 * count(distinct o.customer_id) filter (where fco.first_order_date < date_trunc('month', o.order_date))
    / count(distinct o.customer_id),
    2
  ) as repeat_purchase_rate
from orders as o
join first_completed_order as fco on o.customer_id = fco.customer_id
where o.status = 'completed'
group by "year", "month", month_name
order by "year", "month", month_name;
