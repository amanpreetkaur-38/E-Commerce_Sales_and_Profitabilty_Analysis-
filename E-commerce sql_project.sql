create database ecommerce_sales;
use ecommerce_sales;
SELECT * FROM ORDERS;
select * from customers;
select * from products;
#Total Sales , Profit , Margin
 select
 sum(sales) as total_sales,
 sum(profit) as total_profit,
 sum(profit)/sum(sales)*100 as profit_margin_pct
 from orders;
 # Total Orders and Customers
 select 
 count(distinct customer_id) as total_customers,
 count(distinct order_id) as total_orders
 from orders;
 #Average Order Value
 select 
 round( sum(sales)/count(distinct order_id),2 )as avg_order_value
  from orders;
  #Sales, Profit and Margin by Category
  select p.Category,
   round( sum(o.sales) ,2)as total_sales,
   round(sum(o.profit) ,2)as total_profit,
   round(sum(o.profit)/ sum(o.sales)*100 ,2)as profit_margin_pct
  from orders o 
  join products p 
  on o.product_id=p.product_id
  group by p.category;
 
  #Category Contribution % to total Profit
  select p.Category,
   round(sum(o.profit),2) as total_profit,
   sum(o.profit)*100/ sum(sum(o.profit)) over(
   ) as pct_contribution 
   from orders o 
   join products p 
   on o.product_id=p.product_id
   group by p.category;
   #top 10 products by profit
   select p.product_name,
    sum(o.profit) as total_profit
    from orders o 
    join products p 
    on o.product_id=p.product_id
    group by p.product_name
    limit 10;
# High Sales but Low Profit products
select p.product_name,
sum(o.sales) as sales,
sum(o.profit) as profit
 from orders o	
 join products p 
 on o.product_id=p.product_id
 group by p.product_name
 having sum(o.sales)>(select avg(o.sales) from orders )
 and sum(o.profit)<0;
 #Customer lifetime value
 select c.customer_name,
 sum(o.profit) as lifetime_profit,
 sum(o.sales) as lifetime_sales
 from orders o 
 join customers c 
 on o.customer_id=c.customer_id
 group by c.customer_name;
 #Monthly Sales and Profit trends
 select month(order_date) as month,
 sum(sales)as monthly_sales,
 sum(profit) as monthly_profit 
 from orders 
 group by month
 order by month;
 #MoM Sales growth %
 with monthly_sales as (
 select month(order_date) as month,
 sum(sales) as sales
 from orders group by month)
 select month, sales, 
 (sales -lag(sales)over(order by month)/
 lag(sales) over(order by month))*100 as mom_growth_pct 
 from monthly_sales;
 


 





