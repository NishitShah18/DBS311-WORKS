-- ***********************
-- Name: Nishit Shah
-- ID: 130 176 217
-- Date: 23rd September 2022
-- Purpose: Lab 2 DBS311 NGG
-- ***********************

-- Question - 1  For each job title display the number of employees. Sort the result according to the number of employees --
-- Q1 SOLUTION --
SELECT 
CAST(job_title AS char(40)) AS "JOB_TITLE", 
COUNT(*) AS "EMPLOYEES" 
FROM employees 
GROUP BY job_title 
ORDER BY 2;

-- Question - 2  Display the highest, lowest, and average customer credit limits. Name these results high, low, and average. Add a column that shows the difference between the highest and the lowest credit limits named “High and Low Difference”. Round the average to 2 decimal places. --
-- Q2 SOLUTION --
SELECT MAX(credit_limit) AS "HIGH",
MIN(credit_limit) AS "LOW",
CAST(ROUND(AVG(credit_limit), 2) AS decimal(10,2)) AS "AVERAGE", 
MAX(credit_limit)-MIN(credit_limit) AS "High Low Difference" 
FROM customers;

-- Question - 3  Display the order id, the total number of products, and the total order amount for orders with the total amount over $1,000,000. Sort the result based on total amount from the high to low values.
-- Q3 SOLUTION --
SELECT order_id,
COUNT(*) AS "TOTAL_ITEMS",
SUM(unit_price * quantity) AS "TOAL_AMOUNT" 
FROM order_items 
GROUP BY order_id 
HAVING SUM(unit_price*quantity) > 1000000 
ORDER BY 3 DESC;

-- Question - 4  Display the warehouse id, warehouse name, and the total number of products for each warehouse. Sort the result according to the warehouse ID.
-- Q4 SOLUTION --
SELECT WAR.warehouse_id,
CAST(WAR.warehouse_name AS char(25)) AS "WAREHOUSE_NAME",
SUM(INV.quantity) AS "TOTAL_PRODUCTS" 
FROM warehouses WAR, inventories INV 
WHERE WAR.warehouse_id = INV.warehouse_id 
GROUP BY WAR.warehouse_id, warehouse_name;

/* Question - 5  For each customer display customer number, customer full name, and the total number of orders issued by the customer.
? If the customer does not have any orders, the result shows 0.
? Display only customers whose customer name starts with ‘O’ and contains ‘e’.
? Include also customers whose customer name ends with ‘t’.
? Show the customers with highest number of orders first*/
-- Q5 SOLUTION --
SELECT c.customer_id AS "CUSTOMER_ID", 
CAST(c.name as char(30)) AS "customer name", 
COUNT(o.order_id) "total number of orders" 
FROM customers c 
LEFT OUTER JOIN orders o ON c.customer_id = o.customer_id 
WHERE (c.name LIKE 'O%e' OR c.name LIKE '%t') 
GROUP BY c.customer_id, c.name 
ORDER BY 3 DESC;

-- Question - 6  Write a SQL query to show the total and the average sale amount for each category. Round the average to 2 decimal places --
-- Q6 SOLUTION --
SELECT category_id,
CAST(SUM(quantity * unit_price) AS decimal(15,2)) AS "Total Amount",
CAST(ROUND(AVG(quantity * unit_price),2) AS decimal(10,2)) AS "Average Amount" 
FROM order_items o 
LEFT JOIN products p ON p.product_id = o.product_id 
GROUP BY category_id 
ORDER BY category_id;

























