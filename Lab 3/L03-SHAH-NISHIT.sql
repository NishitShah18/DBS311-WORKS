-- ***********************
-- Name: Nishit Shah
-- ID: 130 176 217
-- Date: 30/09/2022
-- Purpose: Lab 3 DBS311
-- ***********************

/*
Q-1 Write a SQL query to display the last name and hire date of all employees who were hired before the
employee with ID 107 got hired but after March 2016. Sort the result by the hire date and then
employee ID.
*/
-- Answer 1:

SELECT cast (last_name as char(10)) "LAST_NAME", hire_date 
FROM employees 
WHERE hire_date > TO_DATE('16-03-31','RR-MM-DD') AND hire_date < (SELECT hire_date FROM employees WHERE employee_id = 107)
ORDER BY hire_date;

/*
Q-2 Write a SQL query to display customer name and credit limit for customers with lowest credit limit. Sort
the result by customer ID.
*/
-- Answer 2:

SELECT cast (name as char(27)) "NAME", credit_limit
FROM customers 
WHERE credit_limit = (SELECT MIN(credit_limit) FROM customers) 
ORDER BY customer_id;

/*
Q-3 Write a SQL query to display the product ID, product name, and list price of the highest paid product(s)
in each category. Sort by category ID and the product ID.
*/
-- Answer 3:

SELECT category_id, product_id, cast (product_name as char(40)) "PRODUCT_NAME", list_price 
FROM products 
WHERE (category_id, list_price) IN (SELECT category_id, MAX(list_price) FROM products 
GROUP BY category_id);

/*
Q-4 Write a SQL query to display the category ID and the category name of the most expensive (highest list
price) product(s).
*/
-- Answer 4:

SELECT distinct(cat.category_id), cast (cat.category_name as char(13)) "CATEGORY_NAME" 
FROM product_categories cat, products 
WHERE cat.category_id = (SELECT category_id 
                         FROM products 
                         WHERE list_price = (SELECT MAX(list_price) 
                                             FROM products));

/*
Q-5 Write a SQL query to display product name and list price for products in category 1 which have the list
price less than the lowest list price in ANY category. Sort the output by top list prices first and then by
the product ID.
*/
-- Answer 5:

SELECT cast (product_name as char(32)) "PRODUCT_NAME", list_price 
FROM products 
WHERE category_id = 1 AND list_price < ANY (SELECT MIN(list_price) 
                                            FROM products 
                                            GROUP BY category_id) 
ORDER BY 2 DESC, product_id;

/*
Q-6 Display the maximum price (list price) of the category(s) that has the lowest price product..
*/
-- Answer 6:

SELECT MAX(list_price) as "MAX(LIST_PRICE)" 
FROM products 
WHERE category_id = (SELECT category_id 
                     FROM (SELECT category_id, MIN(list_price) as "MINPRICE" 
                           FROM products 
                           GROUP BY category_id) 
                     WHERE "MINPRICE" = (SELECT MIN(list_price) 
                                         FROM products));
                                         