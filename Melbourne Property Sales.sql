#DATA CLEANING AND DATA EXPLORATION WITH MYSQL 
#ATTENTION: THE DATA IS INCOMPLETE. DATA CLEANING PROCESS ONLY INVOLVED CLEANING PROCESS WITHOUT CHANGING ANY BLANK VALUES INTO ANY OTHER VALUES TO PREVENT MISLEADING RESULTS.

#AIM
/*
- To perform complex data cleaning process, such as transaction, convert column's values, and more
- To be able to absorb informations from the given sales report, such as various property types, property that sold the most, prices range, etc.
*/

#SUMMARY
/*
DATA CLEANING
1. Re-sorting the `No.` column and set it to primary key and auto increment for auto update numbers.
2. Converting column values
3. Reformating "TYPE" column values to be more readable

DATA EXPLORATION
1. Southbank is the closest area to Melbourne Central Business District, with distances of 0.7 km and 1.2 km.
2. Houses are the highest-demand property, with 10,723 sold, followed by Units/Apartments (3,777) and Townhouses (1,707).
3. Property sales in Melbourne increased from 6,978 sold properties in 2016 to 9,229 in 2017, a rise of 2,251 properties.
4. Reservoir is the most desirable area, with 471 properties sold, and it has the lowest average price among the top 5 areas with the most sales.
5. The cheapest property was sold in Hawthorn, a unit apartment for $160,000.
6. Nelson is the most trusted seller, having sold 1,824 properties, including 1,290 houses, 201 townhouses, and 333 apartments.
7. Hockingstuart/Advantage and Rosin have the lowest average price at $330,000, involving only 1 unit. Overall, PRD Nationwide has the lowest average price, at $355,200, involving 5 sold properties.
*/

SELECT * FROM melbourne_prop_sales.melbourne_prop_sales;

DESCRIBE melbourne_prop_sales;

#REFORMATTING NO. COLUMN
UPDATE melbourne_prop_sales
SET `No.` = NULL;

ALTER TABLE melbourne_prop_sales
MODIFY COLUMN `No.` INT AUTO_INCREMENT PRIMARY KEY;

#AREA EXPLORATION
SELECT DISTINCT CouncilArea, Regionname
FROM melbourne_prop_sales
WHERE Regionname = 'Western Metropolitan';

-- LOOKING FOR DISTINCT COUNCIL AREA & SUBURB IN THE SAME REGION
SELECT DISTINCT Suburb, CouncilArea, Regionname
FROM melbourne_prop_sales
ORDER BY Regionname;

SELECT `No.`, Address, Suburb, CouncilArea
FROM melbourne_prop_sales
WHERE CouncilArea = "";

SELECT *
FROM melbourne_prop_sales
WHERE Suburb = 'Fawkner';

-- CLOSEST REGION TO MELBOURNE CBD
SELECT DISTINCT Distance, Suburb, Regionname
FROM melbourne_prop_sales
ORDER BY Distance;

SELECT *
FROM melbourne_prop_sales
WHERE Distance = '' AND Regionname = '';

#PROPERTY EXPLORATION
SELECT DISTINCT(`Type`)
FROM melbourne_prop_sales;

/*REFORMATTING PROPERTY `TYPE` VALUES
SELECT DISTINCT(`Type`), CASE
	WHEN `Type` = 'h' THEN 'House'
    WHEN `Type` = 't' THEN 'Townhouse'
    WHEN `Type` ='u' THEN 'Unit/Apartment'
    ELSE `Type`
END `Type`
FROM melbourne_prop_sales;

UPDATE melbourne_prop_sales
SET `Type` = CASE
	WHEN `Type` = 'h' THEN 'House'
    WHEN `Type` = 't' THEN 'Townhouse'
    WHEN `Type` ='u' THEN 'Unit/Apartment'
    ELSE `Type`
END;
*/

-- MOST BOUGHT PROPERTY TYPE 
SELECT `Type`, COUNT(`Type`) Amount_of_Sold
FROM melbourne_prop_sales
WHERE Method != 'PI' AND Method != 'PN' AND Method != 'SN' AND Method != 'W'
GROUP BY `Type`
ORDER BY Amount_of_Sold DESC;

-- PROPERTY SOLD BASED ON YEAR
/*REFORMATTING DATE COLUMN
SELECT `No.`, LPAD(`Date`, 10, '0')
FROM melbourne_prop_sales;

START TRANSACTION;
UPDATE melbourne_prop_sales
SET `Date` = LPAD(`Date`, 10, '0')
WHERE `Date` IS NOT NULL;
COMMIT;
*/

WITH `year` AS (
    SELECT SUBSTR(`Date`, 7, 4) AS year_cvt
    FROM melbourne_prop_sales
    WHERE Method != 'PI' AND Method != 'PN' AND Method != 'SN' AND Method != 'W'
)

SELECT `year`.year_cvt 'Year', COUNT(*) Amount
FROM `year`
GROUP BY year_cvt;

-- MOST SOLD AREA
SELECT Suburb, COUNT(Suburb) Amount_of_Sold
FROM melbourne_prop_sales
WHERE Method != 'PI' AND Method != 'PN' AND Method != 'SN' AND Method != 'W'
GROUP BY Suburb
ORDER BY Amount_of_Sold DESC
LIMIT 5;

#PRICES EXPLORATION
-- AVG PROPERTY PRICE BASED ON PROPERTY TYPE
SELECT `Type`, CONCAT('$',ROUND(AVG(Price),2)) AVG_Price
FROM melbourne_prop_sales
GROUP BY `Type`;

-- CHEAPEST PROPERTY SOLD IN THE AREA (SUBURB)
SELECT Suburb, MIN(Price)
FROM melbourne_prop_sales
WHERE Method != 'PI' AND Method != 'PN' AND Method != 'SN' AND Method != 'W'
GROUP BY Suburb
ORDER BY MIN(Price);

-- AVG PRICE FOR THE TOP 5 MOST SOLD PROPERTIES IN THE SUBURB
SELECT Suburb, COUNT(*) Amount_of_Sold, CONCAT('$', ROUND( AVG(Price), 2)) Avg_Price
FROM melbourne_prop_sales
WHERE Method != 'PI' AND Method != 'PN' AND Method != 'SN' AND Method != 'W'
GROUP BY Suburb
ORDER BY Amount_of_Sold DESC
LIMIT 5;

-- MIN, MAX, AVG PRICE BASED ON SUBURB (if Total_Unit is blank then there's more than 1 unit in the area)
SELECT Suburb, MIN(Price) Min_Price, MAX(Price) Max_Price, AVG(Price) Avg_Price, CASE
	WHEN MIN(Price) = MAX(Price) THEN 1
    ELSE ''
END Total_Unit
FROM melbourne_prop_sales
GROUP BY Suburb;

#SELLER EXPLORATION
/*REFORMATTING SELLER COLUMN
UPDATE melbourne_prop_sales
SET SellerG = CONCAT(UPPER(SUBSTRING(SellerG, 1, 1)), LOWER(SUBSTRING(SellerG, 2)))
WHERE SellerG IS NOT NULL;

ALTER TABLE melbourne_prop_sales
RENAME COLUMN SellerG TO Seller;
*/

-- TOP 10 SELLER WHO SELL THE MOST PROPERTIES
SELECT Seller, COUNT(Seller) Unit_Sold,
    SUM(CASE WHEN `Type` = 'House' THEN 1 ELSE 0 END) AS House,
    SUM(CASE WHEN `Type` = 'Townhouse' THEN 1 ELSE 0 END) AS Townhouse,
    SUM(CASE WHEN `Type` LIKE '%Apartment' THEN 1 ELSE 0 END) AS Apartment
FROM melbourne_prop_sales
WHERE Method != 'PI' AND Method != 'PN' AND Method != 'SN' AND Method != 'W'
GROUP BY Seller
ORDER BY unit_sold DESC
LIMIT 10;

-- AVG SELLER PRICE (ALL)
SELECT Seller, ROUND(AVG(Price), 0) AVG_Price, COUNT(*) Unit_Involved
FROM melbourne_prop_sales
GROUP BY Seller
ORDER BY AVG(Price);

-- AVG SELLER PRICE (ONLY SOLD UNITS)
SELECT Seller, ROUND(AVG(Price), 0) AVG_Price, COUNT(*) Unit_Involved
FROM melbourne_prop_sales
WHERE Method != 'PI' AND Method != 'PN' AND Method != 'SN' AND Method != 'W'
GROUP BY Seller
ORDER BY AVG(Price);