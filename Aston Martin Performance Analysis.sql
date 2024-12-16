/*
NOTE: 
THE DATA IS 100% ARTIFICIAL, INSPIRED BY THE LATEST ASTON MARTIN INVESTOR RELATIONSHIP REPORT, AND CREATED FOR THE PURPOSE OF PERSONAL PROJECT ONLY
THE DATA HAS RECEIVED SEVERAL MODIFICATIONS TO RESEMBLE THE ACTUAL DATA, WITH DURATION RANGES FROM JANUARY 1, 2023 TO NOVEMBER 16, 2024.
*/

#SUMMARY
/*
SALES PERFORMANCE, REVENUE, AND MODEL PERFORMANCE ANALYSIS
1. 2024 H1 Wholesale dropped by 38%, affecting revenue down to 25%
2. 2024 Q3 Wholesale dropped by 24%, affecting revenue down to 15%
3. YTD 2024 Total Wholesale: 3964
4. DB12 to be the top performance sales model and store the most revenue (1379 total wholesale, $380,780,527 in revenue)
5. Sport/GT contributes 64% of our sales YTD 2024, making it the leading model type in the line-up

REGIONAL PERFORMANCE ANALYSIS 
1. The UK and EMEA to be the leading sales region in 2024, collectively representing 52% of total wholesale
2. Sales in Americas dropped by 41%, dropping it from the leading continent in 2023 to the third continent in 2024
3. EMEA and Americas ordered the most 'Specials' models, covering Valkyrie, Valour, and Valiant
*/

SELECT * FROM aston_martin.sales;

DESCRIBE sales;

# SALES PERFORMANCE ANALYSIS
-- H1 YOY WHOLESALE COMPARISON
SELECT YEAR(delivery_date), COUNT(delivery_date)
FROM sales
WHERE MONTH(Delivery_Date) <= 06
GROUP BY 1;

-- H1 YOY WHOLESALE COMPARISON (PER CATEGORY)
SELECT CONCAT(category, " ", YEAR(delivery_date)) AS cat_year, COUNT(category) AS amount
FROM sales 
WHERE 
	MONTH(delivery_date) BETWEEN 01 AND 06
GROUP BY 1
ORDER BY 1;

-- Q3 YOY SALES COMPARISON
SELECT YEAR(Delivery_Date), COUNT(model) AS amount
FROM sales
WHERE MONTH(delivery_date) BETWEEN 07 AND 09
GROUP BY YEAR(Delivery_Date);

-- 2024 YTD TOTAL WHOLESALE
SELECT COUNT(Delivery_Date)
FROM sales
WHERE YEAR(Delivery_Date) = 2024;

#REVENUE ANALYSIS
-- H1 YOY REVENUE COMPARISON
SELECT YEAR(Delivery_Date) AS y_year, SUM(price) AS y_revenue
FROM sales
WHERE MONTH(delivery_date) BETWEEN 01 AND 06
GROUP BY 1;

SELECT
	((SELECT SUM(price) AS y_revenue
	FROM sales
	WHERE 
		YEAR(delivery_date) = 2024 AND 
        MONTH(delivery_date) BETWEEN 01 AND 06) - SUM(price)) / SUM(price) * 100
FROM sales
WHERE 
	YEAR(delivery_date) = 2023 AND 
	MONTH(delivery_date) BETWEEN 01 AND 06;

-- Q3 YOY REVENUE COMPARISON
SELECT YEAR(Delivery_Date) AS y_year, SUM(price) AS y_revenue
FROM sales
WHERE MONTH(delivery_date) BETWEEN 07 AND 09
GROUP BY YEAR(Delivery_Date);

#MODEL CATEGORY ANALYSIS
-- GENERAL
SELECT category, COUNT(*)
FROM sales
GROUP BY 1
ORDER BY COUNT(*) DESC;

-- YTD 2024 WHOLESALE
SELECT category, COUNT(category)
FROM sales
WHERE YEAR(delivery_date) = 2024
GROUP BY 1;

-- 'MODEL-REVENUE' PERFORMANCE ANALYSIS 2024
SELECT model, COUNT(model)
FROM sales
WHERE YEAR(delivery_date) = 2024
GROUP BY 1
ORDER BY COUNT(model) DESC;

SELECT model, SUM(price) AS revenue
FROM sales
WHERE YEAR(Delivery_Date) = 2024
GROUP BY 1
ORDER BY revenue DESC;

-- CATEGORY PERFORMANCE YOY (Q1-Q3)
SELECT CONCAT(category, " ", YEAR(delivery_date)), COUNT(category)
FROM sales
WHERE MONTH(delivery_date) BETWEEN 01 AND 09
GROUP BY 1
ORDER BY 1;

#REGIONAL PERFORMANCE ANALYSIS
-- REGION SALES 2024
SELECT region, COUNT(delivery_date) AS amount
FROM sales
WHERE YEAR(delivery_date) = 2024
GROUP BY 1
ORDER BY COUNT(delivery_date) DESC;

-- REGION SALES YOY COMPARISON
SELECT CONCAT(region, " ", YEAR(delivery_date)) AS year_region, COUNT(delivery_date) AS amount
FROM sales
GROUP BY 1
ORDER BY COUNT(delivery_date) DESC;

-- 'SPECIALS' MODELS SHARES FROM EACH REGION 2024
SELECT region, COUNT(*)
FROM sales
WHERE YEAR(delivery_date) = 2024 AND category = 'Specials'
GROUP BY region
ORDER BY COUNT(*) DESC;