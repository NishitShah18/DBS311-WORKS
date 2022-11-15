-- ***********************
-- Name: Nishit Shah
-- ID: 130 176 217
-- Date: 25 October 2022
-- Purpose: Lab 06 DBS311
-- ***********************

SET SERVEROUTPUT ON;

-- Q1.	Write a store procedure that gets an integer number n and calculates and displays its factorial.

CREATE OR REPLACE PROCEDURE FACTORIAL(N IN INT) 
IS 
FACTORIALVALUE INT := 1; 
I INT := 0; 
BEGIN 
LOOP 
FACTORIALVALUE := ( FACTORIALVALUE * ( N - I ) ); 
I := I + 1; 
EXIT WHEN I = N; 
END LOOP; 
DBMS_OUTPUT.PUT_LINE(FACTORIALVALUE); 
EXCEPTION 
WHEN OTHERS THEN 
DBMS_OUTPUT.PUT_LINE('error!'); 
END; 

--Test
BEGIN 
FACTORIAL(5); 
END; 
BEGIN 
FACTORIAL(6); 
END; 

-- Q2. The company wants to calculate the employees’ annual salary: 
--     The first year of employment, the amount of salary is the base salary which is $10,000.
--     Every year after that, the salary increases by 5%. Write a stored procedure named calculate_salary 
--     which gets an employee ID and for that employee calculates the salary based on the number of years 
--     the employee has been working in the company.  (Use a loop construct to calculate the salary). The 
--     procedure calculates and prints the salary. 
/*
Sample output: 
First Name: first_name  
Last Name: last_name 
Salary: $9999,99 
*/
--     If the employee does not exists, the procedure displays a proper message. 

CREATE OR REPLACE PROCEDURE SALARY_CALCULATOR(EMPLOYEE_ID IN NUMBER) 
IS 
  SALARY    NUMBER := 10000; 
  YEARCOUNT NUMBER; 
  FIRSTNAME VARCHAR(20); 
  LASTNAME  VARCHAR(20); 
  I         INT := 0; 
BEGIN 
    SELECT TRUNC(TO_CHAR(SYSDATE - EMPLOYEES.HIRE_DATE) / 365) 
    INTO   YEARCOUNT 
    FROM   EMPLOYEES 
    WHERE  EMPLOYEES.EMPLOYEE_ID = SALARY_CALCULATOR.EMPLOYEE_ID; 

    SELECT EMPLOYEES.FIRST_NAME 
    INTO   FIRSTNAME 
    FROM   EMPLOYEES 
    WHERE  EMPLOYEES.EMPLOYEE_ID = SALARY_CALCULATOR.EMPLOYEE_ID; 

    SELECT EMPLOYEES.LAST_NAME 
    INTO   LASTNAME 
    FROM   EMPLOYEES 
    WHERE  EMPLOYEES.EMPLOYEE_ID = SALARY_CALCULATOR.EMPLOYEE_ID; 

LOOP 
SALARY := SALARY * 1.05; 
I := I + 1; 
EXIT WHEN I = YEARCOUNT; 
END LOOP; 
 DBMS_OUTPUT.PUT_LINE('First Name: '  ||FIRSTNAME); 
 DBMS_OUTPUT.PUT_LINE('Last Name: '   ||LASTNAME); 
 DBMS_OUTPUT.PUT_LINE('Salary: '      ||SALARY); 
EXCEPTION 
  WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No Data Found'); 
END;

--Test
BEGIN 
SALARY_CALCULATOR(2); 
END; 
BEGIN 
SALARY_CALCULATOR(3); 
END; 

-- Q3. Write a stored procedure named warehouses_report to print the warehouse ID, warehouse name, and the city 
/*
Warehouse ID: 
Warehouse name: 
City: 
State: 
*/
--     If the value of state does not exist (null), display “no state”. The value of warehouse ID ranges from 1 to 9. 
--     You can use a loop to find and display the information of each warehouse inside the loop. (Use a loop construct 
--     to answer this question. Do not use cursors.) 

CREATE PROCEDURE WAREHOUSE_REPORT IS L_WID WAREHOUSES.WAREHOUSE_ID % TYPE;
L_WN WAREHOUSES.WAREHOUSE_NAME % TYPE;
L_CITY LOCATIONS.CITY % TYPE;
L_STATE LOCATIONS.STATE % TYPE;
BEGIN
FOR I IN 1..9 LOOP 
SELECT
      W.WAREHOUSE_ID,
      W.WAREHOUSE_NAME,
      L.CITY,
      NVL(L.STATE, 'no state') INTO L_WID,
      L_WN,
      L_CITY,
      L_STATE 
FROM WAREHOUSES W 
INNER JOIN LOCATIONS L 
ON (W.LOCATION_ID = L.LOCATION_ID) 
WHERE W.WAREHOUSE_ID = I;
DBMS_OUTPUT.PUT_LINE('Warehouse ID: ' || L_WID);
DBMS_OUTPUT.PUT_LINE('Warehouse name: ' || L_WN);
DBMS_OUTPUT.PUT_LINE('City: ' || L_CITY);
DBMS_OUTPUT.PUT_LINE('State: ' || L_STATE);
DBMS_OUTPUT.PUT_LINE('');
END
LOOP;
EXCEPTION 
WHEN OTHERS 
THEN DBMS_OUTPUT.PUT_LINE('Error Occured');
END;

-- Test
BEGIN 
WAREHOUSE_REPORT();
END;