--- SELECTING THE ENTIRE TABLE FROM PIZZA DATABASE
SELECT * FROM pizza_sales

---FIND TOTAL REVENUE : SUM OF THE TOTAL PRICE OF ALL PIZZA ORDERS.
SELECT SUM(total_price) AS total_revenue
FROM pizza_sales

---FIND AVERAGE ORDER VALUE: THE AVG AMOUNT SPENT PER ORDER, CALAULATED BY DIVIDING THE TOTAL REVENUE BY THE TOTAL NUMBER OF ORDERS
SELECT SUM(total_price)/COUNT(DISTINCT order_id) AS avg_order_value
FROM pizza_sales

---TOTAL PIZZAS SOLD: SUM OF THE QUANTITIES OF ALL PIZZAS SOLD
SELECT SUM(quantity) AS total_pizza_sold
FROM pizza_sales

---TOTAL ORDERS: THE TOTAL NUMBER OF ORDERS PLACED
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales

---AVERAGE PIZZA PER ORDER
SELECT CAST (
	CAST (SUM(quantity) AS DECIMAL(10,2))/ CAST (COUNT(DISTINCT order_id) AS DECIMAL(10,2)) 
	AS DECIMAL(10,2))  AS avg_pizza_per_order
FROM pizza_sales

---HOURLY TREND FOR TOTAL PIZZAS SOLD
SELECT DATEPART(HOUR, order_time) AS order_hour, SUM(quantity) AS totall_pizzas_sold
FROM pizza_sales
GROUP BY DATEPART(HOUR, order_time)
ORDER BY DATEPART(HOUR, order_time)

---WEEKLY TREND FOR TOTAL ORDERS 
SELECT DATEPART(ISO_WEEK, order_date) AS week_number, YEAR(order_date) AS order_year, COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY DATEPART(ISO_WEEK, order_date), YEAR (order_date)
ORDER BY DATEPART(ISO_WEEK, order_date), YEAR (order_date)

---PERCENTAGE OF SALES BY PIZZA CATEGORY
SELECT pizza_category, SUM(total_price)*100 /(SELECT SUM(total_price) FROM pizza_sales) AS PCT
FROM pizza_sales
GROUP BY pizza_category

---PERCENTAGE OF SALES BY PIZZA CATEGORY FOR FIRST MONTH(JAN)
SELECT pizza_category, SUM(total_price)*100 /(SELECT SUM(total_price) FROM pizza_sales WHERE MONTH(order_date) = 1) AS PCT
FROM pizza_sales
WHERE MONTH(order_date) = 1
GROUP BY pizza_category

---PERCENTAGE OF SALES BY PIZZA SIZE
SELECT pizza_size, SUM(total_price) AS total_sales, 
CAST (SUM(total_price)*100 /(SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL (10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY PCT DESC

---PERCENTAGE OF SALES BY PIZZA SIZE BY QUARTER
SELECT pizza_size, CAST (SUM(total_price) AS DECIMAL(10,2)) AS total_sales, 
CAST (SUM(total_price)*100 /(SELECT SUM(total_price) FROM pizza_sales WHERE DATEPART(QUARTER, order_date) = 1 ) AS DECIMAL (10,2)) AS PCT
FROM pizza_sales
WHERE DATEPART(QUARTER, order_date) = 1
GROUP BY pizza_size
ORDER BY PCT DESC

---TOTAL 5 BEST SELLERS BY REVENUE, TOTAL QUANTITY AND TOTAL ORDERS
SELECT TOP 5 pizza_name, SUM (total_price) AS total_revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue DESC
---LEAST SELLERS
SELECT TOP 5 pizza_name, SUM (total_price) AS total_revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue
--- BY QUANTITY
SELECT TOP 5 pizza_name, SUM (quantity) AS total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_quantity DESC
---BY ORDERS
SELECT TOP 5 pizza_name, SUM (DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders DESC