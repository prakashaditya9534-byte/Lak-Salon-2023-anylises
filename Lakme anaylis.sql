SELECT 
SUM(SaleValue) AS Total_Revenue
FROM lk.data;

SELECT 
COUNT(DISTINCT GuestCode) AS Total_Customers
FROM lk.data;

SELECT 
COUNT(DISTINCT `Ticket No`) AS Total_Transactions
FROM lk.data;

SELECT 
SUM(SaleValue) AS Total_Revenue
FROM lk.data;

SELECT 
SUM(SaleValue) / COUNT(DISTINCT `Ticket No`) AS Avg_Bill_Value
FROM lk.data;

SELECT 
Category,
SUM(SaleValue) AS Revenue
FROM lk.data
GROUP BY Category
ORDER BY Revenue DESC;

SELECT 
SubCategory,
SUM(SaleValue) AS Revenue
FROM lk.data
GROUP BY SubCategory
ORDER BY Revenue DESC;

SELECT 
ServiceName,
SUM(SaleValue) AS Revenue
FROM lk.data
GROUP BY ServiceName
ORDER BY Revenue DESC
LIMIT 10;


SELECT 
ServiceName,
COUNT(`Ticket No`) AS Total_Bookings
FROM lk.data
GROUP BY ServiceName
ORDER BY Total_Bookings DESC
LIMIT 10;

SELECT 
ServicedBy,
SUM(SaleValue) AS Revenue
FROM lk.data
GROUP BY ServicedBy
ORDER BY Revenue DESC;

SELECT 
SUM(Discount) AS Total_Discount,
SUM(SaleValue) AS Revenue
FROM lk.data;

SELECT 
PaymentType,
SUM(SaleValue) AS Revenue
FROM lk.data
GROUP BY PaymentType
ORDER BY Revenue DESC;

SELECT 
Member,
COUNT(DISTINCT GuestCode) AS Customers,
SUM(SaleValue) AS Revenue
FROM lk.data
GROUP BY Member;

SELECT 
FirstVisit,
COUNT(DISTINCT GuestCode) AS Customers
FROM lk.data
GROUP BY FirstVisit;


SELECT 
Promotion,
SUM(SaleValue) AS Revenue
FROM lk.data
GROUP BY Promotion
ORDER BY Revenue DESC;

SELECT 
GuestCode,
SUM(SaleValue) AS Total_Spent
FROM lk.data
GROUP BY GuestCode
ORDER BY Total_Spent DESC
LIMIT 10;





SELECT 
SaleDate,
SUM(SaleValue) AS Daily_Revenue
FROM lk.data
GROUP BY SaleDate
ORDER BY SaleDate;

SELECT 
ServiceName,
AVG(SaleValue) AS Avg_Service_Value
FROM lk.data
GROUP BY ServiceName
ORDER BY Avg_Service_Value DESC;


#Customer Churn Analysis

##Last Visit of Each Customer
SELECT 
GuestCode,
MAX(SaleDate) AS Last_Visit
FROM lk.data
GROUP BY GuestCode;

##Identify Churn Customers
SELECT 
GuestCode,
MAX(SaleDate) AS Last_Visit
FROM lk.data
GROUP BY GuestCode
HAVING MAX(SaleDate) < CURDATE() - INTERVAL 90 DAY;

##Calculate Churn Rate
SELECT COUNT(DISTINCT GuestCode) AS Churn_Customers
FROM lk.data
WHERE GuestCode NOT IN (
    SELECT GuestCode
    FROM lk.data
    WHERE SaleDate >= CURDATE() - INTERVAL 90 DAY
);



SELECT
GuestCode,
DATEDIFF(CURDATE(), MAX(SaleDate)) AS Recency,
COUNT(`Ticket No`) AS Frequency,
SUM(SaleValue) AS Monetary,

CASE
WHEN SUM(SaleValue) > 10000 AND COUNT(`Ticket No`) > 5 THEN 'VIP Customer'
WHEN SUM(SaleValue) BETWEEN 5000 AND 10000 THEN 'Loyal Customer'
WHEN COUNT(`Ticket No`) = 1 THEN 'One-Time Customer'
ELSE 'Regular Customer'
END AS Customer_Segment

FROM lk.data
GROUP BY GuestCode;

SELECT
GuestCode,
COUNT(`Ticket No`) AS Total_Visits,
SUM(SaleValue) AS Lifetime_Value
FROM lk.data
GROUP BY GuestCode
ORDER BY Lifetime_Value DESC;


SELECT 
t1.ServiceName AS Service_1,
t2.ServiceName AS Service_2,
COUNT(*) AS Bundle_Count
FROM lk.data t1
JOIN lk.data t2
ON t1.`Ticket No` = t2.`Ticket No`
AND t1.ServiceName < t2.ServiceName
GROUP BY Service_1, Service_2
ORDER BY Bundle_Count DESC;

SELECT 
ServiceName,
COUNT(DISTINCT `Ticket No`) AS Tickets
FROM lk.data
GROUP BY ServiceName
ORDER BY Tickets DESC;


SELECT 
`Ticket No`,
COUNT(DISTINCT Category) AS Category_Count
FROM lk.data
GROUP BY `Ticket No`
HAVING COUNT(DISTINCT Category) >= 2;


SELECT
GuestCode,
Customer_Revenue,
ROUND(
SUM(Customer_Revenue) OVER (ORDER BY Customer_Revenue DESC)
/SUM(Customer_Revenue) OVER () * 100,2
) AS Revenue_Percentage
FROM (
    SELECT 
    GuestCode,
    SUM(SaleValue) AS Customer_Revenue
    FROM lk.data
    GROUP BY GuestCode
) t;



SELECT 
DATE_FORMAT(first_visit,'%Y-%m') AS Cohort_Month,
DATE_FORMAT(d.SaleDate,'%Y-%m') AS Visit_Month,
COUNT(DISTINCT d.GuestCode) AS Customers
FROM lk.data d
JOIN (
    SELECT 
     GuestCode,
    MIN(SaleDate) AS first_visit
    FROM lk.data
    GROUP BY GuestCode
) f
ON d.GuestCode = f.GuestCode
GROUP BY Cohort_Month, Visit_Month
ORDER BY Cohort_Month, Visit_Month;


