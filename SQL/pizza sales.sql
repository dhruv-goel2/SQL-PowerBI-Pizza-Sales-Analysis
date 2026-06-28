create database pizza_db;
use pizza_db;
select * from pizza_sales;
select count(*) from pizza_sales;
set sql_safe_updates = 0;
alter table pizza_sales
add column order_date_new date;
UPDATE pizza_sales
SET order_date_new = STR_TO_DATE(order_date,'%d-%m-%Y');
alter table pizza_sales
RENAME column order_date_new TO order_date;


## Total Revenue
select sum(total_price) AS Total_Revenue from pizza_sales;

## Average Order values
select sum(total_price) / count(distinct order_id) AS Average_Order_value from pizza_sales;

## Total pizza sold
select sum(quantity) AS Total_Pizza_Sold from pizza_sales;

## Total Orders
select count(distinct order_id) AS Total_Orders from pizza_sales;

## Average Pizzas per Order
select sum(quantity) / count(distinct order_id)AS Average_Pizza_Per_Order from pizza_sales;

select * from pizza_sales;

/* CHARTS content
    Daily Trend For Orders*/

SELECT DAYNAME(order_date) AS order_day,
       COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales
GROUP BY DAYOFWEEK(order_date), DAYNAME(order_date)
ORDER BY DAYOFWEEK(order_date);

## MONTHLY TREND FOR ORDERS
SELECT monthname(order_date) AS Month_Name,
	   count(distinct order_id) AS Total_Orders
from pizza_sales
GROUP BY monthname(order_date)
ORDER BY Total_Orders desc;

## PERCENTAGE OF PIZZA SALES BY CATEGORY
select pizza_category, sum(total_price) * 100 / (select sum(total_price) from pizza_sales) AS PCT_Total_Sales
from pizza_sales 
GROUP BY pizza_category;

## PERCENTAGE OF PIZZA SALES BY SIZE
select pizza_size,CAST(sum(total_price) AS DECIMAL(10,2)) AS total_revenue ,
cast(sum(total_price) * 100 / (select sum(total_price) from pizza_sales) AS DECIMAL(10,2))AS PCT
from pizza_sales 
GROUP BY pizza_size
ORDER BY pizza_size;

## TOP 5 BEST SELLERS BY REVENUE , TOTAL QUANTITY AND TOTAL ORDERS 
SELECT pizza_name, sum(total_price) AS Total_Revenue 
from pizza_sales 
GROUP BY pizza_name
ORDER BY Total_Revenue desc
LIMIT 5;

## BOTTOM 5 PIZZA
SELECT pizza_name, sum(total_price) AS Total_Revenue 
from pizza_sales 
GROUP BY pizza_name
ORDER BY Total_Revenue 
LIMIT 5;

## TOP 5 PIZZAS BY QUANTITY 
SELECT pizza_name, sum(quantity) AS Total_Quantity
from pizza_sales 
GROUP BY pizza_name
ORDER BY Total_Quantity DESC
LIMIT 5;

## BOTTOM 5 PIZZAS BY QUANTITY 
SELECT 
    pizza_name, SUM(quantity) AS Total_Quantity
FROM
    pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity
LIMIT 5;

## TOP 5 PIZZAS BY ORDERS 
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
from pizza_sales 
GROUP BY pizza_name
ORDER BY Total_Orders DESC
LIMIT 5;

## BOTTOM 5 PIZZAS BY ORDERS 
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
from pizza_sales 
GROUP BY pizza_name
ORDER BY Total_Orders 
LIMIT 5;

select @@hostname;

## Ranking Pizzas by Revenue 
SELECT
    pizza_name,
SUM(total_price) AS Revenue,
RANK() OVER (ORDER BY SUM(total_price) DESC) AS Revenue_Rank
FROM pizza_sales
GROUP BY pizza_name;

## Case Statement
## Revenue Category according to Revenue
select
    pizza_name,
    SUM(total_price) AS Revenue,
    CASE
        WHEN SUM(total_price) > 40000 THEN 'High Revenue'
        WHEN SUM(total_price) > 20000 THEN 'Medium Revenue'
        ELSE 'Low Revenue'
    END AS Revenue_Category
FROM pizza_sales
GROUP BY pizza_name;

## Running Total
SELECT
    order_date,
    SUM(total_price) AS Daily_Revenue,
    SUM(SUM(total_price)) 
    OVER (ORDER BY order_date) AS Running_Revenue
FROM pizza_sales
GROUP BY order_date;

## Dense Rank
SELECT
    pizza_category,
    pizza_name,
    SUM(total_price) AS Revenue,
    DENSE_RANK() OVER (
        PARTITION BY pizza_category
        ORDER BY SUM(total_price) DESC
    ) AS Category_Rank
FROM pizza_sales
GROUP BY pizza_category, pizza_name;