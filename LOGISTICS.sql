                                                -- LOGISTIC-- 
									--  SQL Questions for Logistics Dataset-- 
CREATE DATABASE LOGISTIC_PROJECT;

-- 1.Count the customer base based on customer type to identify current customer preferences and sort them in descending order.-- 

SELECT C_TYPE, COUNT(*) AS CUSTOMER_COUNT FROM CUSTOMER
GROUP BY C_TYPE
ORDER BY CUSTOMER_COUNT DESC;

-- 2. Count the customer base based on their status of payment in descending order.-- 

SELECT Payment_Status , COUNT(*) AS PAYMENT_COUNT FROM payment_details 
GROUP BY Payment_Status 
ORDER BY PAYMENT_COUNT DESC;

-- 3. Count the customer base based on their payment mode in descending order of count.--

SELECT Payment_Mode , COUNT(*)  AS PAYMENT_COUNT FROM payment_details 
GROUP BY Payment_Mode 
ORDER BY PAYMENT_COUNT DESC;

-- 4. Count the customers as per shipment domain in descending order.--

SELECT SH_DOMAIN , COUNT(*) AS DOMAIN_COUNT FROM shipment_details
GROUP BY SH_DOMAIN 
ORDER BY DOMAIN_COUNT DESC;

-- 5. Count the customer according to service type in descending order of count.--

SELECT SER_TYPE , COUNT(*) AS SERVICE_COUNT FROM shipment_details
GROUP BY  SER_TYPE
ORDER BY SERVICE_COUNT DESC; 

-- 6. Explore employee count based on the designation-wise count of employees' IDs in descending order.--

SELECT E_DESIGNATION , COUNT(E_ID) E_COUNT FROM employee_details
GROUP BY E_DESIGNATION 
ORDER BY E_COUNT DESC;

-- 7. Branch-wise count of employees for efficiency of deliveries in descending order.--

SELECT E_BRANCH , COUNT(E_ID) E_COUNT FROM employee_details
GROUP BY E_BRANCH 
ORDER BY E_COUNT DESC;
 
-- 8. Finding C_ID, M_ID, and tenure for those customers whose membership is over 10 years.--
SELECT 
  C.C_ID,M.M_ID,
  TIMESTAMPDIFF(YEAR, M.START_DATE, M.END_DATE) AS Tenure
FROM 
  Customer C
  INNER JOIN membership M ON C.M_ID = M.M_ID
WHERE 
  TIMESTAMPDIFF(YEAR, M.START_DATE, M.END_DATE) > 10
  ORDER BY Tenure DESC ;

  -- 9. Considering average payment amount based on customer type having payment mode as COD in descending order.-- 
  SELECT C.C_TYPE ,ROUND(AVG(P.AMOUNT),2) AS AVERAGE_AMOUNT FROM CUSTOMER C
  JOIN payment_details P ON C.C_ID = P.C_ID WHERE 
  P.Payment_Mode = 'COD'
  GROUP BY C.C_TYPE 
  ORDER BY AVERAGE_AMOUNT DESC;
  
-- 10. Calculate the average payment amount based on payment mode where the payment date is not null.--

SELECT PAYMENT_MODE , ROUND(AVG(AMOUNT),2) AS AVG_PAYMENT 
FROM payment_details
WHERE Payment_Date IS NOT NULL
GROUP BY PAYMENT_MODE;

-- 11. Calculate the average shipment weight based on payment_status where shipment content does not start with "H."-- 

SELECT P.Payment_Status , AVG(S.SH_WEIGHT) AS AVERAGE_WEIGHT FROM payment_details P 
JOIN shipment_details S ON P.SH_ID = S.SH_ID
WHERE SH_CONTENT NOT LIKE 'H%'
GROUP BY P.Payment_Status;

-- 12. Retrieve the names and designations of all employees in the 'NY' E_Branch.--

SELECT E_NAME, E_DESIGNATION FROM employee_details	 
WHERE E_BRANCH ='NY';
 
-- 13. Calculate the total number of customers in each C_TYPE (Wholesale, Retail, Internal Goods).-- 

SELECT C_TYPE , COUNT(C_ID) AS NUMBER_OF_CUSTOMERS FROM customer
WHERE C_TYPE IN ('Wholesale', 'Retail', 'Internal Goods')
GROUP BY C_TYPE;

-- 14. Find the membership start and end dates for customers with 'Paid' payment status.-- 

 SELECT C.C_ID ,M.Start_date , M.End_date , P.PAYMENT_STATUS FROM CUSTOMER C 
 JOIN membership M ON C.M_ID = M.M_ID 
 JOIN payment_details P ON P.C_ID = C.C_ID 
 WHERE P.PAYMENT_STATUS ='Paid';

-- -15. List the clients who have made 'Card Payment' and have a 'Regular' service type.-- 
 SELECT  C.C_NAME ,P.Payment_Mode , S.SER_TYPE FROM CUSTOMER C 
 JOIN payment_details P ON C.C_ID = P.C_ID
 JOIN shipment_details S ON P.C_ID = S.C_ID 
 WHERE P.Payment_Mode ='CARD PAYMENT' AND S.SER_TYPE = 'Regular';

-- 16. Calculate the average shipment weight for each shipment domain (International and Domestic).--

SELECT SH_DOMAIN , AVG(SH_WEIGHT) AS AVERAGE_WEIGHT FROM shipment_details
WHERE SH_DOMAIN IN ('International' , 'Domestic')
GROUP BY SH_DOMAIN ;
 
-- 17. Identify the shipment with the highest charges and the corresponding client's name.-- 
SELECT S.SH_ID, C.C_NAME , S.SH_CHARGES FROM customer c 
JOIN shipment_details S  ON C.C_ID = S.C_ID   
ORDER BY S.SH_CHARGES DESC 
LIMIT 1;

                                 -- OR --
SELECT S.SH_ID,C.C_NAME,S.SH_CHARGES
FROM 
  customer C
  JOIN shipment_details S ON C.C_ID = S.C_ID
WHERE 
  S.SH_CHARGES = (SELECT MAX(SH_CHARGES) FROM shipment_details);

-- 18. Count the number of shipments with the 'Express' service type that are yet to be delivered.-- 
SELECT S.SER_TYPE , COUNT(C.Current_Status) AS YET_TO_BE_DELIVERED FROM shipment_details S
JOIN status C  ON S.SH_ID = C.SH_ID
WHERE C.Current_Status = 'NOT DELIVERED' AND S.SER_TYPE ='Express';

-- 19. List the clients who have 'Not Paid' payment status and are based in 'CA'.
SELECT E.Employee_E_ID , D.E_NAME, P.Payment_Status FROM employee_manages_shipment E 
JOIN employee_details D ON E.Employee_E_ID = D.E_ID 
JOIN payment_details P ON E.Shipment_Sh_ID = P.SH_ID
WHERE P.Payment_Status = 'NOT PAID' AND D.E_BRANCH ='CA';



-- 20. Retrieve the current status and delivery date of shipments managed by employees with the designation 'Delivery Boy'.

SELECT S.Current_Status , S.Delivery_date, E.E_DESIGNATION FROM status S 
JOIN employee_manages_shipment ON S.SH_ID = employee_manages_shipment.Shipment_Sh_ID
JOIN employee_details E ON employee_manages_shipment.Employee_E_ID = E.E_ID
WHERE E.E_DESIGNATION ='Delivery Boy';

-- 21. Find the membership start and end dates for customers whose 'Current Status' is 'Not Delivered'.

SELECT C.M_ID, M.Start_date,M.End_date,S.Current_Status FROM STATUS S 
JOIN shipment_details on shipment_details.SH_ID =  S.SH_ID
JOIN customer C ON shipment_details.C_ID = C.C_ID 
JOIN membership M ON C.M_ID = M.M_ID
WHERE S.Current_Status = 'NOT DELIVERED';





 