-- ***********************
-- Name: Nishit Shah
-- ID: 130 176 217
-- Date: 7th October 2022
-- Purpose: Lab 4 DBS311
-- ***********************

-- Question 1 – Display cities that no warehouse is located in them. (use set operators to answer this 
--              question)
-- Q1 SOLUTION --
SELECT LOCATIONS.city 
FROM locations LOCATIONS
WHERE LOCATIONS.location_id IN (SELECT LOCATIONS.location_id 
                      FROM locations LOCATIONS
                      MINUS SELECT WAREHOUSES.location_id 
                            FROM warehouses WAREHOUSES) 
ORDER BY 1;

-- Question 2 – Display the category ID, category name, and the number of products in category 1, 2,
--              and 5. In your result, display first the number of products in category 5, then category 1
--              and then 2.
-- Q2 SOLUTION --
SELECT PRODUCTS.category_id, 
CAST(CATEGORIES.category_name AS char(13)) AS "CATEGORY_NAME", 
COUNT(PRODUCTS.product_id) AS "COUNT(*)" 
FROM products PRODUCTS, product_categories CATEGORIES 
WHERE PRODUCTS.category_id = CATEGORIES.category_id and CATEGORIES.category_id = 5 
GROUP BY PRODUCTS.category_id, CATEGORIES.category_name 
UNION ALL SELECT PRODUCTS.category_id, 
                 CAST(CATEGORIES.category_name AS char(13)), 
                 COUNT(PRODUCTS.product_id) 
                 FROM products PRODUCTS, product_categories CATEGORIES 
                 WHERE PRODUCTS.category_id = CATEGORIES.category_id and CATEGORIES.category_id = 1 
                 GROUP BY PRODUCTS.category_id, CATEGORIES.category_name 
                 UNION ALL SELECT PRODUCTS.category_id, 
                                  CAST(CATEGORIES.category_name AS char(13)), 
                                  COUNT(PRODUCTS.product_id) 
                                  FROM products PRODUCTS, product_categories CATEGORIES 
                                  WHERE PRODUCTS.category_id = CATEGORIES.category_id and CATEGORIES.category_id = 2 
                                  GROUP BY PRODUCTS.category_id, CATEGORIES.category_name;

-- Question 3 – Display product ID for products whose quantity in the inventory is less than to 5. (You
--              are not allowed to use JOIN for this question.)
-- Q3 SOLUTION --
SELECT INVENTORIES.product_id 
FROM inventories INVENTORIES 
WHERE INVENTORIES.quantity < 5;

-- Question 4 – We need a single report to display all warehouses and the state that they are located in
--             and all states regardless of whether they have warehouses in them or not. (Use set
--             operators in you answer.)
-- Q4 SOLUTION --
SELECT CAST(WAREHOUSES.warehouse_name AS char(19)) "WAREHOUSE_NAME", 
CAST(LOCATIONS.STATE AS char(18)) "STATE" 
FROM warehouses WAREHOUSES, locations LOCATIONS 
WHERE WAREHOUSES.location_id = LOCATIONS.location_id 
UNION (SELECT NULL, 
       STATE FROM locations LOCATIONS
       WHERE LOCATIONS.location_id IN (SELECT LOCATIONS.location_id 
                             FROM locations LOCATIONS
                             MINUS SELECT WAREHOUSES.location_id 
                                   FROM warehouses WAREHOUSES)) 
ORDER BY 1, 2;
