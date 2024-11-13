#DATA CLEANING AND DATA EXPLORATION WITH MYSQL 
#ATTENTION: THE ORIGINAL DATA IS INCOMPLETE. DATA CLEANING PROCESS ONLY INVOLVED CLEANING PROCESS WITHOUT CHANGING ANY BLANK VALUES INTO ANY OTHER VALUES TO PREVENT MISLEADING RESULTS.

#AIM
/*
- Perform complex data cleaning processes, such as transactions, convert column values, and more
- Absorb information from the given sales report, such as various property types, property that sold the most, price ranges, etc.
*/

#SUMMARY
/*
DATA CLEANING
1. Re-sorted the `No.` column, set it as the primary key, and added auto increment for automation updates.
2. Renamed column names
3. Reformatted the "Type" column values to be more readable
4. Equalize the "Date" column length by adding a leading 0 to the date so the year can be extracted

DATA EXPLORATION
1. Southbank is the closest area to Melbourne Central Business District, with distances of 0.7 km and 1.2 km.
2. House dominates the market by 84% with 10,723 units sold. Followed by Units/Apartments (3,777) and Townhouses (1,707).
3. Average property prices based on their type:
   House: $1,220,387.36
   Unit/Apartment: $625,254.43
   Townhouse: $922,893.95
4. Property sales in Melbourne increased from 6,978 sold properties in 2016 to 9,229 sold properties in 2017, a rise of 32% properties.
5. Reservoir is the leading area in Melbourne, with 471 properties have been sold. Followed by:
   Bentleigh East: 307 units,
   Richmond: 293 units, and
   Brunswick: 245 units
6. The average property price in Reservoir is $692,485.88, making it the cheapest and the most desirable area to buy property in Melbourne.
7. The cheapest property was sold in Hawthorn, a unit apartment for $160,000.
8. Nelson is the most trusted seller and has sold 1,824 properties, including 1,290 houses, 201 townhouses, and 333 apartments.
   The average price offered for each property type is:
	Unit/Apartment: $585,291
	Townhouse: $736,499
	House: $1,149,112
9. PRD Nationwide has the lowest average price, at $355,200, involving only 5 sold properties.
*/

SELECT * FROM melbourne_prop_sales.melbourne_prop_sales;

DESCRIBE melbourne_prop_sales;

#CHECKING DUPLICATES
SELECT DISTINCT(COUNT(*))
FROM melbourne_prop_sales;

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

-- CLOSEST REGION TO MELBOURNE CBD
SELECT DISTINCT Distance, Suburb, Regionname
FROM melbourne_prop_sales
ORDER BY Distance;

-- TOP 5 BEST-SELLING AREA
SELECT DISTINCT Method
FROM melbourne_prop_sales;

SELECT Suburb, COUNT(*) Amount_of_Sold
FROM melbourne_prop_sales
WHERE Method != 'PI'
GROUP BY Suburb
ORDER BY Amount_of_Sold DESC
LIMIT 5;

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

-- AMOUNT OF SOLD PROPERTIES WITH AVERAGE PRICE 
SELECT `Type`, COUNT(`Type`) Amount_of_Sold, CONCAT('$', ROUND(AVG(Price),2)) Avg_Price
FROM melbourne_prop_sales
WHERE Method != 'PI'
GROUP BY `Type`
ORDER BY Amount_of_Sold DESC;

-- SOLD PROPERTIES BASED ON YEAR
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
    WHERE Method != 'PI'
)

SELECT `year`.year_cvt 'Year', COUNT(*) Amount
FROM `year`
GROUP BY year_cvt;

#PRICES EXPLORATION
-- CHEAPEST PROPERTY SOLD IN THE AREA (SUBURB)
SELECT Suburb, MIN(Price)
FROM melbourne_prop_sales
WHERE Method != 'PI'
GROUP BY Suburb
ORDER BY MIN(Price);

-- AVG SOLD PROPERTIES PRICE FOR THE TOP 5 SUBURB
SELECT Suburb, COUNT(*) Amount_of_Sold, CONCAT('$', ROUND( AVG(Price), 2)) Avg_Price
FROM melbourne_prop_sales
WHERE Method != 'PI'
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
    SUM(CASE WHEN `Type` LIKE '%Apartment' THEN 1 ELSE 0 END) AS Apartment,
     CONCAT('$', ROUND(AVG(Price),0)) Avg_Seller_Price
FROM melbourne_prop_sales
WHERE Method != 'PI'
GROUP BY Seller
ORDER BY unit_sold DESC
LIMIT 10;

SELECT Seller, `Type`, ROUND(AVG(Price),0) AS Average_Price
FROM melbourne_prop_sales
WHERE Method != 'PI' AND Seller = 'Nelson'
GROUP BY `Type`
ORDER BY Average_Price;
