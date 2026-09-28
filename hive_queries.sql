-- Create Database
CREATE DATABASE IF NOT EXISTS instacart_db;
USE instacart_db;

-- 1. Create External Table for Orders
CREATE EXTERNAL TABLE IF NOT EXISTS orders (
    order_id INT, 
    user_id INT, 
    eval_set STRING,
    order_number INT, 
    order_dow INT,
    order_hour_of_day INT, 
    days_since_prior STRING
) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION '/user/cloudera/instacart/orders/'
TBLPROPERTIES ("skip.header.line.count"="1");

-- 2. Create External Table for Order Products
CREATE EXTERNAL TABLE IF NOT EXISTS order_products (
    order_id INT, 
    product_id INT,
    add_to_cart_order INT, 
    reordered INT
) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION '/user/cloudera/instacart/order_products_prior/'
TBLPROPERTIES ("skip.header.line.count"="1");

-- 3. Create External Table for Products
CREATE EXTERNAL TABLE IF NOT EXISTS products (
    product_id INT, 
    product_name STRING,
    aisle_id INT, 
    department_id INT
) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION '/user/cloudera/instacart/products/'
TBLPROPERTIES ("skip.header.line.count"="1");

-- 4. Create External Table for Departments
CREATE EXTERNAL TABLE IF NOT EXISTS departments (
    department_id INT, 
    department STRING
) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION '/user/cloudera/instacart/departments/'
TBLPROPERTIES ("skip.header.line.count"="1");

-- 5. Create External Table for Aisles
CREATE EXTERNAL TABLE IF NOT EXISTS aisles (
    aisle_id INT, 
    aisle STRING
) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION '/user/cloudera/instacart/aisles/'
TBLPROPERTIES ("skip.header.line.count"="1");

-- Distributed Three-Way Join Aggregation Query (Top 10 Departments by Order Volume)
SELECT d.department, COUNT(*) AS total_orders
FROM order_products p
JOIN products pr ON p.product_id = pr.product_id
JOIN departments d ON pr.department_id = d.department_id
GROUP BY d.department
ORDER BY total_orders DESC 
LIMIT 10;
