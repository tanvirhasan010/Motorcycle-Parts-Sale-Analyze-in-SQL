-- Create Database
CREATE DATABASE Analyzing_Motorcycle_Parts;

-- Create Tables
DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
   SL_number SERIAL PRIMARY KEY,
   order_number VARCHAR(100), 
   date Date,
    warehouse VARCHAR(100),
    client_type VARCHAR(100),
    product_line VARCHAR(100),
	quantity INT,
    unit_price NUMERIC(10, 2),
	total NUMERIC(10, 2),
	payment VARCHAR(100),
   payment_fee NUMERIC(10, 2));

   
SELECT * from sales;

--Queries

--1) Monthly Revenue Trend by Warehouse
SELECT
    warehouse,
    DATE_TRUNC('month', date) AS month,
    SUM(total) AS total_revenue,
    ROUND(SUM(total) * 100.0 / SUM(SUM(total)) OVER (PARTITION BY warehouse), 2) AS percentage_of_warehouse_revenue
FROM sales
GROUP BY warehouse, DATE_TRUNC('month', date)
ORDER BY warehouse, month;

--2)Top 3 Product Lines by Revenue per Client Type
WITH ranked_products AS (
    SELECT
        client_type,
        product_line,
        SUM(total) AS total_revenue,
        ROW_NUMBER() OVER (PARTITION BY client_type ORDER BY SUM(total) DESC) AS rank
    FROM sales
    GROUP BY client_type, product_line
)
SELECT
    client_type,
    product_line,
    total_revenue,
    ROUND(total_revenue * 100.0 / SUM(total_revenue) OVER (PARTITION BY client_type), 2) AS percentage
FROM ranked_products
WHERE rank <= 3
ORDER BY client_type, rank;

---3)Payment Method Analysis with Fee Impact
SELECT
    payment,
    COUNT(*) AS transaction_count,
    SUM(total) AS gross_revenue,
    SUM(total * payment_fee) AS total_fees,
    ROUND(SUM(total * (1 - payment_fee)) AS net_revenue,
    ROUND(AVG(payment_fee) * 100, 2) AS avg_fee_percentage
FROM sales
GROUP BY payment
ORDER BY net_revenue DESC;

--4)Moving Average of Daily Sales (7-day window)
SELECT
    date,
    warehouse,
    SUM(total) AS daily_revenue,
    ROUND(AVG(SUM(total)) OVER (
        PARTITION BY warehouse 
        ORDER BY date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_7d
FROM sales
GROUP BY date, warehouse
ORDER BY warehouse, date;

--5)Customer Value Analysis (Retail vs Wholesale)
WITH customer_stats AS (
    SELECT
        client_type,
        COUNT(DISTINCT order_number) AS unique_orders,
        SUM(quantity) AS total_units,
        SUM(total) AS total_revenue,
        ROUND(SUM(total) / COUNT(DISTINCT order_number), 2) AS avg_order_value
    FROM sales
    GROUP BY client_type
),
percentiles AS (
    SELECT
        client_type,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total) AS median_order_value,
        PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY total) AS p80_order_value
    FROM sales
    GROUP BY client_type
)
SELECT 
    c.client_type,
    c.unique_orders,
    c.total_units,
    c.total_revenue,
    c.avg_order_value,
    p.median_order_value,
    p.p80_order_value
FROM customer_stats c
JOIN percentiles p ON c.client_type = p.client_type;

--6)Total Sales by Product Line
SELECT product_line, SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

--7)Average Order Value per Warehouse
SELECT warehouse, ROUND(AVG(total), 2) AS avg_order_value
FROM sales
GROUP BY warehouse
ORDER BY avg_order_value DESC;

--8)Monthly Sales Count by Client Type
SELECT client_type, DATE_TRUNC('month', date) AS month, COUNT(order_number) AS orders
FROM sales
GROUP BY client_type, DATE_TRUNC('month', date)
ORDER BY month, client_type;

--9)Top 5 Biggest Orders
SELECT order_number, warehouse, client_type, total
FROM sales
ORDER BY total DESC
LIMIT 5;

--10)Units Sold vs. Revenue by Product Line
SELECT product_line, SUM(quantity) AS total_units, SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

--11)Average Unit Price by Payment Method
SELECT payment, ROUND(AVG(unit_price), 2) AS avg_unit_price
FROM sales
GROUP BY payment
ORDER BY avg_unit_price DESC;

--12)Revenue Contribution of Each Warehouse
SELECT warehouse,
       SUM(total) AS total_revenue,
       ROUND(SUM(total) * 100.0 / (SELECT SUM(total) FROM sales), 2) AS percentage_contribution
FROM sales
GROUP BY warehouse
ORDER BY total_revenue DESC;

--13)Repeat Orders (Customers with More Than 1 Order)
SELECT client_type, COUNT(DISTINCT order_number) AS order_count
FROM sales
GROUP BY client_type
HAVING COUNT(DISTINCT order_number) > 1
ORDER BY order_count DESC;

--14)Daily Sales Trend for a Specific Warehouse
SELECT date, SUM(total) AS daily_revenue
FROM sales
WHERE warehouse = 'Warehouse A'
GROUP BY date
ORDER BY date;

--15)Revenue Lost to Payment Fees
SELECT payment,
       SUM(total * payment_fee) AS total_fees,
       SUM(total) - SUM(total * payment_fee) AS net_revenue
FROM sales
GROUP BY payment
ORDER BY total_fees DESC;


--16)Average Quantity per Order by Client Type
SELECT client_type, ROUND(AVG(quantity), 2) AS avg_quantity_per_order
FROM sales
GROUP BY client_type
ORDER BY avg_quantity_per_order DESC;

--17)Month-over-Month Growth in Revenue
SELECT 
    DATE_TRUNC('month', date) AS month,
    SUM(total) AS monthly_revenue,
    ROUND((SUM(total) - LAG(SUM(total)) OVER (ORDER BY DATE_TRUNC('month', date))) 
          / NULLIF(LAG(SUM(total)) OVER (ORDER BY DATE_TRUNC('month', date)), 0) * 100, 2) AS mom_growth_percentage
FROM sales
GROUP BY DATE_TRUNC('month', date)
ORDER BY month;

--18)Product Lines Dominated by Wholesale vs Retail
SELECT product_line, client_type, SUM(total) AS revenue
FROM sales
GROUP BY product_line, client_type
ORDER BY product_line, revenue DESC;

--19) Top Payment Method per Warehouse
WITH payment_rank AS (
    SELECT warehouse, payment, SUM(total) AS revenue,
           ROW_NUMBER() OVER (PARTITION BY warehouse ORDER BY SUM(total) DESC) AS rank
    FROM sales
    GROUP BY warehouse, payment
)
SELECT warehouse, payment, revenue
FROM payment_rank
WHERE rank = 1;

--20) Year-to-Date (YTD) Revenue by Warehouse
SELECT warehouse,
       DATE_TRUNC('month', date) AS month,
       SUM(total) AS monthly_revenue,
       SUM(SUM(total)) OVER (PARTITION BY warehouse ORDER BY DATE_TRUNC('month', date)) AS ytd_revenue
FROM sales
GROUP BY warehouse, DATE_TRUNC('month', date)
ORDER BY warehouse, month;

--21) Seasonality Check: Average Monthly Revenue by Product Line
SELECT product_line,
       EXTRACT(MONTH FROM date) AS month,
       ROUND(AVG(total), 2) AS avg_monthly_revenue
FROM sales
GROUP BY product_line, EXTRACT(MONTH FROM date)
ORDER BY product_line, month;

--22) Contribution Margin per Product Line (after fees)
SELECT product_line,
       SUM(total) AS gross_revenue,
       SUM(total * payment_fee) AS total_fees,
       SUM(total) - SUM(total * payment_fee) AS net_revenue,
       ROUND((SUM(total) - SUM(total * payment_fee)) * 100.0 / SUM(total), 2) AS margin_percentage
FROM sales
GROUP BY product_line
ORDER BY margin_percentage DESC;

--23) Client Type Loyalty: % of Repeat Orders
WITH order_counts AS (
    SELECT client_type, order_number, COUNT(*) AS items
    FROM sales
    GROUP BY client_type, order_number
)
SELECT client_type,
       COUNT(*) AS total_orders,
       SUM(CASE WHEN items > 1 THEN 1 ELSE 0 END) AS repeat_orders,
       ROUND(SUM(CASE WHEN items > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS repeat_rate_percentage
FROM order_counts
GROUP BY client_type;

--24) Detect Anomalous Sales (Orders 2x Above Monthly Avg)
WITH monthly_stats AS (
    SELECT DATE_TRUNC('month', date) AS month,
           AVG(total) AS avg_order_value
    FROM sales
    GROUP BY DATE_TRUNC('month', date)
)
SELECT s.order_number, s.date, s.total, m.avg_order_value
FROM sales s
JOIN monthly_stats m ON DATE_TRUNC('month', s.date) = m.month
WHERE s.total > 2 * m.avg_order_value
ORDER BY s.total DESC;

--25) Warehouse Performance Ranking Across All Time
SELECT warehouse,
       SUM(total) AS total_revenue,
       RANK() OVER (ORDER BY SUM(total) DESC) AS revenue_rank,
       DENSE_RANK() OVER (ORDER BY SUM(quantity) DESC) AS quantity_rank
FROM sales
GROUP BY warehouse
ORDER BY revenue_rank;

--26) Rolling 30-Day Revenue per Warehouse
SELECT warehouse, date,
       SUM(total) AS daily_revenue,
       SUM(SUM(total)) OVER (
           PARTITION BY warehouse
           ORDER BY date
           ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
       ) AS rolling_30d_revenue
FROM sales
GROUP BY warehouse, date
ORDER BY warehouse, date;

--27) Payment Method Dependence by Client Type
SELECT client_type, payment,
       COUNT(*) AS transactions,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY client_type), 2) AS pct_usage
FROM sales
GROUP BY client_type, payment
ORDER BY client_type, pct_usage DESC;

--28) Profitability by Warehouse (After Fees)
SELECT warehouse,
       SUM(total) AS gross_revenue,
       SUM(total * payment_fee) AS total_fees,
       SUM(total) - SUM(total * payment_fee) AS net_revenue,
       ROUND((SUM(total) - SUM(total * payment_fee)) * 100.0 / SUM(total), 2) AS profit_margin_pct
FROM sales
GROUP BY warehouse
ORDER BY net_revenue DESC;

--29)Product Line Diversity per Order (Basket Size)
SELECT order_number,
       COUNT(DISTINCT product_line) AS unique_product_lines,
       SUM(quantity) AS total_units,
       SUM(total) AS order_value
FROM sales
GROUP BY order_number
ORDER BY unique_product_lines DESC, order_value DESC;

--30) Revenue Concentration (Pareto / 80-20 Rule)
WITH ranked_orders AS (
    SELECT order_number, SUM(total) AS order_value,
           ROW_NUMBER() OVER (ORDER BY SUM(total) DESC) AS rn
    FROM sales
    GROUP BY order_number
),
cumulative AS (
    SELECT order_number, order_value,
           SUM(order_value) OVER (ORDER BY order_value DESC) AS cum_revenue,
           SUM(order_value) OVER () AS total_revenue
    FROM ranked_orders
)
SELECT order_number, order_value,
       ROUND(cum_revenue * 100.0 / total_revenue, 2) AS cum_revenue_pct
FROM cumulative
WHERE cum_revenue <= 0.8 * total_revenue;

--31) Payment Method Preference Shift Over Time
SELECT DATE_TRUNC('month', date) AS month, payment,
       COUNT(*) AS transactions,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY DATE_TRUNC('month', date)), 2) AS pct_of_month
FROM sales
GROUP BY DATE_TRUNC('month', date), payment
ORDER BY month, pct_of_month DESC;

--32) Revenue Growth Decomposition (Quantity vs Price)
SELECT DATE_TRUNC('month', date) AS month,
       SUM(quantity) AS total_units,
       ROUND(AVG(unit_price), 2) AS avg_price,
       SUM(total) AS revenue
FROM sales
GROUP BY DATE_TRUNC('month', date)
ORDER BY month;

--33) Warehouse-Payment Dependency Matrix
SELECT warehouse, payment,
       COUNT(*) AS transactions,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY warehouse), 2) AS pct_usage
FROM sales
GROUP BY warehouse, payment
ORDER BY warehouse, pct_usage DESC;


--Queries done by (Md Tanvir Hasan, Business Analyst, Honda Bangladesh)










