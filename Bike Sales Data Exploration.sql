#AIM
/*
This research aims to understand the business market, goods sales report, customer demographic, and financial condition.
*/

#SUMMARY
/*
1. Most customers are from the United States with 32 customers, followed by Australia with 27 customers.
2. "Mountain-200 Black, 46" is the highest-demand product.
3. Adults dominate the customer type by 53%.
4. Most customers are female, with the most bought product type being the Mountain-200 Black, 46. 
5. 66 bikes have been sold in the US, and 63 bikes have been sold in Australia.
6. Sales are weak in Europe and Canada. The UK has only 9 customers, followed by France with 8 customers, and Germany with only 6 customers.
7. Canada has only 6 customers. It also has the lowest sales quantity, with only 11 products sold, even though its location is the closest one to the US.
*/

SELECT * FROM bike_sales_report.`cleaned bike sales data`;

DESCRIBE bike_sales_report.`cleaned bike sales data`;

# TOTAL CUSTOMER BASED ON REGION
SELECT Country, COUNT(DISTINCT `Sales_Order #`) AS Amount_of_Customer
FROM bike_sales_report.`cleaned bike sales data`
GROUP BY  Country
ORDER BY Amount_of_Customer DESC;

# AMOUNT OF PRODUCT SOLD BASED ON REGION
SELECT Country, SUM(Order_Quantity) AS Qty
FROM bike_sales_report.`cleaned bike sales data`
GROUP BY Country
ORDER BY Qty DESC;

# THE MOST BOUGHT PRODUCT TYPE
SELECT `Product_Description`, SUM(Order_Quantity) AS `Amount of Sold`
FROM bike_sales_report.`cleaned bike sales data`
GROUP BY `Product_Description`
ORDER BY `Amount of Sold` DESC;

# REVENUE CHECKING
-- FIRST WEEK
SELECT SUM(CAST(REPLACE(REPLACE(revenue, '$', ''), ',', '') AS SIGNED INTEGER)) AS `First Week Revenue`
FROM bike_sales_report.`cleaned bike sales data`
WHERE DATE < '12/8/2021';

-- WHOLE MONTH
SELECT SUM(CAST(REPLACE(REPLACE(revenue, '$', ''), ',', '') AS SIGNED INTEGER)) AS `Whole Month Revenue`
FROM bike_sales_report.`cleaned bike sales data`;

-- HEALTHY CASHFLOW?
WITH revenue AS (
SELECT SUM(CAST(REPLACE(REPLACE(revenue, '$', ''), ',', '') AS SIGNED INTEGER)) AS dec_revenue
FROM bike_sales_report.`cleaned bike sales data`
),

cost AS (
SELECT SUM(CAST(REPLACE(REPLACE(cost, '$', ''), ',', '') AS SIGNED INTEGER)) AS dec_cost
FROM bike_sales_report.`cleaned bike sales data`
)

SELECT 
CASE 
	WHEN r.dec_revenue > c.dec_cost THEN '✔'
    ELSE '❌'
END AS Revenue_Health_Check
FROM revenue r
CROSS JOIN cost c;

# VARIOUS CUSTOMER TYPE
-- THE MOST BUYER BASED ON AGE GROUP
SELECT Age_Group, COUNT(`Sales_Order #`) AS Amount_of_Buyer
FROM bike_sales_report.`cleaned bike sales data`
GROUP BY Age_Group;

-- BUYER AGE GROUP PERCENTAGE
SELECT Age_Group, CONCAT(ROUND((COUNT(`Product_Description`)/88)*100, 2), '%') AS Percentage
FROM bike_sales_report.`cleaned bike sales data`
GROUP BY Age_Group;

-- THE MOST BUYER BASED ON GENDER
SELECT Customer_Gender, COUNT(Customer_Gender) AS Total_Customer
FROM bike_sales_report.`cleaned bike sales data`
GROUP BY Customer_Gender; 

# THE MOST BOUGHT PRODUCT TYPE BASED ON GENDER
SELECT Customer_Gender, `Product_Description`, SUM(Order_Quantity) AS `Amount of Bought`
FROM bike_sales_report.`cleaned bike sales data`
GROUP BY `Customer_Gender`, Product_Description
ORDER BY `Amount of Bought` DESC;
