CREATE DATABASE IF NOT EXISTS ecommerce_analytics;
USE ecommerce_analytics;
DROP TABLE IF EXISTS sales_orders;
CREATE TABLE sales_orders (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id VARCHAR(20) NOT NULL,
    vendor VARCHAR(50) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    total_sales DECIMAL(12,2) NOT NULL,
    region VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    refund_status VARCHAR(20) NOT NULL
);

-- KPI Summary
SELECT COUNT(DISTINCT order_id) AS total_orders, SUM(quantity) AS units_sold, ROUND(SUM(total_sales), 2) AS revenue FROM sales_orders WHERE refund_status = 'Completed';

-- Monthly Revenue Trend
SELECT DATE_FORMAT(order_date, '%Y-%m') AS sales_month, COUNT(order_id) AS orders, ROUND(SUM(total_sales), 2) AS monthly_revenue FROM sales_orders GROUP BY sales_month ORDER BY sales_month;

-- Top Products
SELECT product_name, vendor, SUM(quantity) AS units, ROUND(SUM(total_sales), 2) AS revenue FROM sales_orders GROUP BY product_name, vendor ORDER BY revenue DESC LIMIT 5;

-- Month over Month Growth with LAG()
WITH MonthlySales AS (
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS sales_month, ROUND(SUM(total_sales), 2) AS current_sales FROM sales_orders GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT sales_month, current_sales, LAG(current_sales) OVER (ORDER BY sales_month) AS prev_sales FROM MonthlySales;
