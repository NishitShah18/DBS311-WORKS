-- ***********************
-- Student Name: Nishit Shah
-- Student1 ID: 130 176 217
-- Date: 14 October 2022
-- Purpose: Assignment 1 - DBS311
-- ***********************

-- Question 1 – Display the employee number, full employee name, job title, 
--and hire date of all employees hired in September with the most 
--recently hired employees displayed first. 

-- Q1 SOLUTION --
SELECT EMPLOYEE_ID AS "EMPLOYEE NUMBER", 
CONCAT(CONCAT(LAST_NAME, ', '), FIRST_NAME) AS "FULL NAME",
JOB_TITLE AS "JOB TITLE", 
TO_CHAR( HIRE_DATE, 'FMMonth ddth "of" YYYY' ) AS "START DATE" 
FROM EMPLOYEES
WHERE EXTRACT(MONTH FROM HIRE_DATE) = 9
ORDER BY HIRE_DATE DESC;

-- Question 2 – The company wants to see the total sale amount per sales person (salesman) for all orders.  
--Assume that online orders do not have any sales representative. For online orders (orders with no salesman ID), consider the salesman ID as 0. 
--Display the salesman ID and the total sale amount for each employee. 
--Sort the result according to employee number.

-- Q2 SOLUTION --
SELECT NVL(SALESMAN_ID, 0)"EMPLOYEE NUMBER", 
       TO_CHAR(SUM(ORDER_ITEMS.UNIT_PRICE * 
       ORDER_ITEMS.QUANTITY), '$999,999,999.99') "TOTAL SALE"
FROM   ORDERS 
       INNER JOIN ORDER_ITEMS 
               ON ORDER_ITEMS.ORDER_ID = ORDERS.ORDER_ID 
GROUP  BY ORDERS.SALESMAN_ID 
ORDER  BY NVL(ORDERS.SALESMAN_ID, 0); 

-- Question 3 - Display customer Id, customer name and total number of orders for customers 
--that the value of their customer ID is in values from 35 to 45. 
--Include the customers with no orders in your report if their customer ID falls in the range 35 and 45.  
--Sort the result by the value of total orders. 

-- Q3 SOLUTION --
SELECT CUSTOMERS.CUSTOMER_ID AS "CUSTOMER ID", 
CUSTOMERS.NAME AS "NAME", 
COUNT(ORDERS.ORDER_ID) AS "TOTAL ORDERS"
FROM CUSTOMERS
LEFT JOIN ORDERS ON CUSTOMERS.CUSTOMER_ID = ORDERS.CUSTOMER_ID
WHERE CUSTOMERS.CUSTOMER_ID BETWEEN 35 AND 45
GROUP BY CUSTOMERS.CUSTOMER_ID, CUSTOMERS.NAME
ORDER BY "TOTAL ORDERS";

-- Question 4 - Display customer ID, customer name, and the order ID and the order date of all orders 
--for customer whose ID is 44.
--a.Show also the total quantity and the total amount of each customer’s order.
--b.Sort the result from the highest to lowest total order amount.

-- Q4 SOLUTION --
SELECT 
CUSTOMERS.CUSTOMER_ID"CUSTOMER ID", 
CUSTOMERS.NAME"NAME", 
ORDERS.ORDER_ID"ORDER ID", 
ORDERS.ORDER_DATE"ORDER DATE", 
SUM(ORDER_ITEMS.QUANTITY)"TOTAL ITEMS", 
TO_CHAR(SUM(ORDER_ITEMS.QUANTITY * UNIT_PRICE), '$999,999,999.99')"TOTAL AMOUNT" 
FROM   CUSTOMERS 
       INNER JOIN ORDERS 
               ON CUSTOMERS.CUSTOMER_ID = ORDERS.CUSTOMER_ID 
       INNER JOIN ORDER_ITEMS 
               ON ORDER_ITEMS.ORDER_ID = ORDERS.ORDER_ID 
GROUP  BY CUSTOMERS.CUSTOMER_ID, 
          CUSTOMERS.NAME, 
          ORDERS.ORDER_ID, 
          ORDERS.ORDER_DATE 
HAVING CUSTOMERS.CUSTOMER_ID = 44 
ORDER  BY SUM(ORDER_ITEMS.QUANTITY * UNIT_PRICE)DESC; 

-- Question 5 - Display customer Id, name, total number of orders, the total number of items ordered, 
--and the total order amount for customers who have more than 30 orders. 
--Sort the result based on the total number of orders.

-- Q5 SOLUTION --
SELECT CUSTOMERS.CUSTOMER_ID AS "CUSTOMER ID",
CUSTOMERS.NAME AS "NAME",
TMP.TOTAL_ORDERS AS "TOTAL NUMBER OF ORDERS",
TMP.TOTAL_ITEMS AS"TOTAL ITEMS",
TMP.TOTAL_AMOUNT AS "TOTAL AMOUNT"
FROM CUSTOMERS,
(SELECT ORDERS.CUSTOMER_ID, 
COUNT(ORDER_ITEMS.ITEM_ID) AS TOTAL_ORDERS,
SUM(ORDER_ITEMS.QUANTITY) AS TOTAL_ITEMS, 
TO_CHAR(SUM(ORDER_ITEMS.QUANTITY * UNIT_PRICE), '$999,999,999.00') AS TOTAL_AMOUNT
FROM ORDERS, ORDER_ITEMS
WHERE ORDERS.ORDER_ID = ORDER_ITEMS.ORDER_ID
GROUP BY ORDERS.CUSTOMER_ID
HAVING COUNT(ORDER_ITEMS.ITEM_ID) >30) TMP
WHERE CUSTOMERS.CUSTOMER_ID = TMP.CUSTOMER_ID
ORDER BY "TOTAL NUMBER OF ORDERS";

-- Question 6 - Display Warehouse Id, warehouse name, product category Id, product category name,
--and the lowest product standard cost for this combination.
--•In your result, include the rows that the lowest standard cost is less than $200.
--•Also, include the rows that the lowest cost is more than $500.
--•Sort the output according to Warehouse Id, warehouse name and then product category Id, 
--and product category name.

-- Q6 SOLUTION -- 
SELECT WAREHOUSES.WAREHOUSE_ID"WAREHOUSE ID", 
       WAREHOUSES.WAREHOUSE_NAME"WAREHOUSE NAME", 
       PRODUCT_CATEGORIES.CATEGORY_ID"CATEGORY ID", 
       PRODUCT_CATEGORIES.CATEGORY_NAME"CATEGORY NAME", 
       TO_CHAR(MIN(PRODUCTS.STANDARD_COST), '$999,999.99')"LOWEST COST" 
FROM   WAREHOUSES 
       INNER JOIN INVENTORIES 
               ON INVENTORIES.WAREHOUSE_ID = WAREHOUSES.WAREHOUSE_ID 
       INNER JOIN PRODUCTS 
               ON PRODUCTS.PRODUCT_ID = INVENTORIES.PRODUCT_ID 
       INNER JOIN PRODUCT_CATEGORIES 
               ON PRODUCT_CATEGORIES.CATEGORY_ID = PRODUCTS.CATEGORY_ID 
GROUP  BY WAREHOUSES.WAREHOUSE_ID, 
          WAREHOUSES.WAREHOUSE_NAME, 
          PRODUCT_CATEGORIES.CATEGORY_ID, 
          PRODUCT_CATEGORIES.CATEGORY_NAME 
HAVING MIN(PRODUCTS.STANDARD_COST) > 500 
        OR MIN(PRODUCTS.STANDARD_COST) < 200 
ORDER  BY WAREHOUSES.WAREHOUSE_ID, 
          WAREHOUSES.WAREHOUSE_NAME, 
          PRODUCT_CATEGORIES.CATEGORY_ID, 
          PRODUCT_CATEGORIES.CATEGORY_NAME; 

-- Question 7 - Display the total number of orders per month. Sort the result from January to December.

-- Q7 SOLUTION -- 
SELECT TO_CHAR(TO_DATE(THE_MONTH, 'MM'), 'Month') AS "MONTH", COUNTS AS "NUMBER OF ORDERS" 
FROM (SELECT EXTRACT(MONTH 
FROM ORDER_DATE) 
AS THE_MONTH, COUNT(*) AS COUNTS 
FROM ORDERS 
GROUP BY
EXTRACT(MONTH 
FROM ORDER_DATE) )
SALES 
ORDER BY THE_MONTH;

-- Question 8 - Display product Id, product name for products that their list price is more than any highest product standard cost per warehouse outside Americas regions.
--(You need to find the highest standard cost for each warehouse that is located outside the Americas regions. Then you need to return all products that their list price is higher than any highest standard cost of those warehouses.)
--Sort the result according to list price from highest value to the lowest.

-- Q8 SOLUTION -- 
SELECT PRODUCTS.PRODUCT_ID"PRODUCT ID", 
       PRODUCTS.PRODUCT_NAME"PRODUCT NAME", 
       TO_CHAR(PRODUCTS.LIST_PRICE, '$999,999.99')"PRICE" 
FROM   PRODUCTS 
       FULL OUTER JOIN INVENTORIES 
                    ON PRODUCTS.PRODUCT_ID = INVENTORIES.PRODUCT_ID 
       FULL OUTER JOIN WAREHOUSES 
                    ON INVENTORIES.WAREHOUSE_ID = WAREHOUSES.WAREHOUSE_ID 
       FULL OUTER JOIN LOCATIONS 
                    ON LOCATIONS.LOCATION_ID = WAREHOUSES.LOCATION_ID 
       FULL OUTER JOIN COUNTRIES 
                    ON COUNTRIES.COUNTRY_ID = LOCATIONS.COUNTRY_ID 
       FULL OUTER JOIN REGIONS 
                    ON COUNTRIES.REGION_ID = REGIONS.REGION_ID 
GROUP  BY PRODUCTS.PRODUCT_ID, 
          PRODUCTS.PRODUCT_NAME, 
          PRODUCTS.LIST_PRICE 
HAVING LIST_PRICE > ANY (SELECT MAX(PRODUCTS.STANDARD_COST) 
                         FROM   PRODUCTS 
                                FULL OUTER JOIN INVENTORIES 
                                             ON PRODUCTS.PRODUCT_ID = 
                                                INVENTORIES.PRODUCT_ID 
                                FULL OUTER JOIN WAREHOUSES 
                                             ON INVENTORIES.WAREHOUSE_ID = 
                                                WAREHOUSES.WAREHOUSE_ID 
                                FULL OUTER JOIN LOCATIONS 
                                             ON LOCATIONS.LOCATION_ID = 
                                                WAREHOUSES.LOCATION_ID 
                                FULL OUTER JOIN COUNTRIES 
                                             ON COUNTRIES.COUNTRY_ID = 
                                                LOCATIONS.COUNTRY_ID 
                                FULL OUTER JOIN REGIONS 
                                             ON COUNTRIES.REGION_ID = 
                                                REGIONS.REGION_ID 
                         GROUP  BY INVENTORIES.WAREHOUSE_ID, 
                                   REGIONS.REGION_ID, 
                                   REGIONS.REGION_NAME 
                         HAVING REGIONS.REGION_NAME <> 'Americas') 
ORDER  BY PRODUCTS.PRODUCT_ID, 
          PRODUCTS.PRODUCT_NAME, 
          PRODUCTS.LIST_PRICE; 
          
-- Question 9 - Write a SQL statement to display the most expensive and the cheapest product (list price). Display product ID, product name, and the list price.

-- Q9 SOLUTION -- 
SELECT PRODUCT_ID,PRODUCT_NAME,LIST_PRICE 
FROM PRODUCTS 
WHERE LIST_PRICE = 
        ( SELECT
         MAX(LIST_PRICE) 
         FROM
         PRODUCTS )
UNION
SELECT PRODUCT_ID,PRODUCT_NAME,LIST_PRICE 
FROM PRODUCTS 
WHERE LIST_PRICE = 
        ( SELECT
         MIN(LIST_PRICE) 
         FROM
         PRODUCTS );
          
-- Question 10 - Write a SQL query to display the number of customers with total order amount over 
--the average amount of all orders, the number of customers with total order amount 
--under the average amount of all orders, number of customers with no orders, and 
--the total number of customers. 
--See the format of the following result.

-- Q10 SOLUTION -- 
SELECT TO_CHAR('Number of customers with total purchase amount over average: ')||COUNT(COUNT(CUSTOMERS.CUSTOMER_ID))"CUSTOMER REPORT" 
FROM   CUSTOMERS 
       INNER JOIN ORDERS 
               ON ORDERS.CUSTOMER_ID = CUSTOMERS.CUSTOMER_ID 
       INNER JOIN ORDER_ITEMS 
               ON ORDERS.ORDER_ID = ORDER_ITEMS.ORDER_ID 
GROUP  BY ( CUSTOMERS.CUSTOMER_ID ) 
HAVING SUM(QUANTITY * UNIT_PRICE) > (SELECT AVG(QUANTITY * UNIT_PRICE) 
                                     FROM   ORDER_ITEMS) 
UNION ALL
SELECT TO_CHAR('Number of customers with total purchase amount below average: ')||COUNT(COUNT(CUSTOMERS.CUSTOMER_ID)) 
FROM   CUSTOMERS 
       INNER JOIN ORDERS 
               ON ORDERS.CUSTOMER_ID = CUSTOMERS.CUSTOMER_ID 
       INNER JOIN ORDER_ITEMS 
               ON ORDERS.ORDER_ID = ORDER_ITEMS.ORDER_ID 
GROUP  BY CUSTOMERS.CUSTOMER_ID 
HAVING SUM(QUANTITY * UNIT_PRICE) < (SELECT AVG(QUANTITY * UNIT_PRICE) 
                                     FROM   ORDER_ITEMS) 
UNION ALL
SELECT TO_CHAR('Number of customers with no orders: ')||COUNT(CUSTOMERS.CUSTOMER_ID) 
FROM   CUSTOMERS 
       FULL OUTER JOIN ORDERS 
                    ON ORDERS.CUSTOMER_ID = CUSTOMERS.CUSTOMER_ID 
WHERE  ORDERS.ORDER_ID IS NULL 
UNION ALL
SELECT TO_CHAR('Total number of customers: ')||COUNT(CUSTOMERS.CUSTOMER_ID) 
FROM   CUSTOMERS; 