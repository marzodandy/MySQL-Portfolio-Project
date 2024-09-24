#AIM
/*
This research aims to understand the condition of the three branches of supermarkets located in Yangon, Mandalay, and Naypitaw based on the sales report for the past 3 months.
*/

#SUMMARY
/*
1. Yangon has the highest traffic, with 340 customers in total. 
2. Naypyitaw has the lowest customer traffic, with only 328 customers shop there for the past 3 months.
3. Naypitaw has the highest income out of all 3 branches, which is $5265.18.
4. Customer numbers decreased at each branch in February.
5. Yangon has traffic improvement for () % after February.
6. The most bought product in each branch:
   - Yangon: Home and lifestyle
   - Mandalay: Sports and travel
   - Naypyitaw: Food and beverages
7. All three branches have an average rating of only around 7.0. 
8. Sales growth percentage decreased to -5.88%.
9. Most customers tend to use Ewallet as their payment method. However, in Naypitaw, customers still prefer to use cash.
10. Credit cards are the least option customers use for payment methods.
*/

#SUGGESTIONS
/*
- All branches need improvements in service, product quality, or others to elevate ratings. 
- Adding 'customer feedback' would help track customer satisfaction after transactions in the cashier.
- Optimize e-wallet service for branches outside Naypitaw. Offer promotions or discounts to engage more customers to use e-wallet.
*/

SELECT * FROM supermarket_sales.supermarket_sales
ORDER BY Date, Time;

DESCRIBE supermarket_sales;

SELECT COUNT(*) FROM supermarket_sales;

SELECT DISTINCT Branch, City
FROM supermarket_sales
ORDER BY Branch;

#CHECKING DISTINCT DATE (PROBLEM ALERT - UNORDERED DATE(DATE 2-9 PLACED AFTER 30)) --> DOESN'T AFFECT AGGREGATION PROCESS
SELECT DISTINCT(Date)
FROM supermarket_sales
ORDER BY Date;

#CHECKING SALES REPORT FROM EACH BRANCH
SELECT * FROM supermarket_sales
WHERE Branch = 'A'
ORDER BY Date, Time;

SELECT * FROM supermarket_sales
WHERE Branch = 'B'
ORDER BY Date, Time;

SELECT * FROM supermarket_sales
WHERE Branch = 'C'
ORDER BY Date, Time;

#LOOKING FOR THE MOST BOUGHT PRODUCT IN EACH BRANCH
-- YANGON
SELECT `Product line`, SUM(Quantity) AS Total_Product
FROM supermarket_sales
WHERE Branch = 'A'
GROUP BY `Product line`
ORDER BY Total_Product DESC;

-- MANDALAY
SELECT `Product line`, SUM(Quantity) AS Total_Product
FROM supermarket_sales
WHERE Branch = 'B'
GROUP BY `Product line`
ORDER BY Total_Product DESC;

-- NAYPITAW
SELECT `Product line`, SUM(Quantity) AS Total_Product
FROM supermarket_sales
WHERE Branch = 'C'
GROUP BY `Product line`
ORDER BY Total_Product DESC;

#CHECKING PAYMENT METHOD IN EACH BRANCH
SELECT DISTINCT(Payment)
FROM supermarket_sales;

SELECT Branch, City, Payment AS Payment_Method, COUNT(Gender) AS Total_Customer
FROM supermarket_sales
WHERE Payment = 'Ewallet'
GROUP BY Branch, City

UNION ALL

SELECT Branch, City, Payment AS Payment_Method, COUNT(Gender)
FROM supermarket_sales
WHERE Payment = 'Cash'
GROUP BY Branch, City

UNION ALL

SELECT Branch, City, Payment AS Payment_Method, COUNT(Gender)
FROM supermarket_sales
WHERE Payment = 'Credit card'
GROUP BY Branch, City
ORDER BY Branch, Total_Customer DESC;

#TOTAL REVENUE FROM EACH BRANCHES
-- IN THE FIRST MONTH 
SELECT Branch, City, CONCAT('$', ROUND(SUM(`gross income`),2)) AS Revenue
FROM supermarket_sales.supermarket_sales
WHERE Date LIKE '1/%'
GROUP BY Branch, City
ORDER BY Revenue DESC;

-- IN THE LAST 3 MONTHS (MOST RECENT DATA)
SELECT Branch, City, CONCAT('$', ROUND(SUM(`gross income`),2)) AS Revenue
FROM supermarket_sales.supermarket_sales
GROUP BY Branch, City
ORDER BY Revenue DESC;

# SUPERMARKET SALES GROWTH PERCENTAGE
-- USING CTE TO COUNT GROWTH PERCENTAGE
WITH march AS (
    SELECT SUM(`gross income`) AS march_income
    FROM supermarket_sales
    WHERE Date LIKE '3%'), 

january AS (
	SELECT SUM(`gross income`) AS jan_income
    FROM supermarket_sales
    WHERE Date LIKE '1%')

SELECT CONCAT(ROUND((a.march_income - b.jan_income) / b.jan_income * 100, 2), '%') AS Sales_Growth_Percentage
FROM march a
CROSS JOIN january b;

#AVERAGE RATING FROM EACH BRANCH
SELECT Branch, AVG (Rating) AS Rating
FROM supermarket_sales
GROUP BY Branch
ORDER BY Branch;

#BRANCHES TRAFFIC
-- TOTAL
SELECT City, COUNT(`Invoice ID`) AS Traffic
FROM supermarket_sales
GROUP BY City
ORDER BY Traffic DESC;

-- EACH MONTH
WITH january AS(
SELECT City, COUNT(`Invoice ID`) january
FROM supermarket_sales
WHERE `Date` LIKE '1%'
GROUP BY City),

february AS(
SELECT City, COUNT(`Invoice ID`) february
FROM supermarket_sales
WHERE `Date` LIKE '2%'
GROUP BY City),

march AS(
SELECT City, COUNT(`Invoice ID`) march
FROM supermarket_sales
WHERE `Date` LIKE '3%'
GROUP BY City)

SELECT jan.City, jan.january, feb.february, mar.march 
FROM january jan
LEFT JOIN february feb ON jan.City = feb.City
LEFT JOIN march mar ON jan.City = mar.City;
