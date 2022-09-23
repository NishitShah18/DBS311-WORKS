/*
Nishit Shah
Student number: 130 176 217
Email Id: ngshah3@myseneca.ca
Section: DBS311 Ngg
*/
-------------------------------

/*
Answer - 1
*/
SELECT 
TO_CHAR (SYSDATE+1,'fmMonth') ||
' '                           ||
TO_CHAR (SYSDATE+1, 'fmddTH') ||
' of year '                   ||
TO_CHAR (SYSDATE+1, 'YYYY') 
"Tomorrow" 
FROM dual;

/*
Answer - 2
*/

DEFINE tomorrow = sysdate + 1;
SELECT SYSDATE AS "Today", SYSDATE+1 AS "Tomorrow" FROM dual;
UNDEFINE tomorrow;
/* I also tried : SELECT SYSDATE AS "Today", @tomorrow AS "Tomorrow" FROM dual; but it did not work*/

/*
Answer - 3
*/

select product_id, product_name, list_price, 
cast(round((list_price/100)*2 + list_price) as integer) as "New Price", 
cast(((round(list_price/100)*2 + list_price) - list_price) as decimal(10,2)) as "Price Difference" 
from products 
where category_id in (2,3,5) 
order by category_id, product_id;

/*
Answer - 4
*/

select 
last_name        || 
', '             || 
first_name       ||
' is '           ||
job_title 
as "Employee Info" 
from employees 
where manager_id = 2 
order by employee_id;

/*
Answer - 5
*/

select last_name, hire_date, 
cast(datediff(day,hire_date,sysdate,) / 365.2425)\ as integer) 
as "Years Worked" 
from employees 
where hire_date < '10/01/2016' 
order by 2;

/*
Answer - 6
*/

/*
Answer - 7
*/

select warehouse_id, warehouse_name, city, nvl(state, 'unknown') 
from warehouses, locations 
where warehouses.location_id = locations.location_id 
order by warehouse_id;