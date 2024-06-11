#AIM
/*
To be able to categorize property for rent in San Fransisco based on the property type, minimum nights to book, and the price range
*/

#SUMMARY
/*
1. Apartments are the most offered property type for rent, with 912 units available, followed by 621 houses and 246 condominiums.
2. Average apartments come with 1 bathroom and 1 bedroom. Houses typically have 2 bathrooms and 2 bedrooms, while condominiums and townhouses usually feature 1 bathroom and 2 bedrooms.
3. Houses are the most widely available property for a week rent under $100, with 120 units averaging $80.95 a week.
4. Hostels are the cheapest option for a week rent under $100, with 15 units available at an average price of $47.87 a week.
5. For a week rent over $100, bed and breakfasts are the most affordable, averaging $120 a week.
6. Houses remain the most offered property type, with 354 units available for the price range above $100.
7. There are 846 properties available for monthly or longer-term rentals.
8. Hostels are the cheapest long-term rental option, with a minimum stay of 30 days and an average price of $44.50 per night.
9. A unit of bungalow is available for only $40.00 with minimum nights of 30 days.
10. In general, bed and breakfast are the most affordable property type, with an average price of $64.1 from 20 units.
*/

SELECT * FROM property_rentals.property_rentals; 

DESCRIBE property_rentals;

-- AMOUNT OF PROPERTY BASED ON PROPERTY TYPE
SELECT property_type, COUNT(*) Amount
FROM property_rentals
GROUP BY property_type;

-- AVG AMOUNT OF BATHROOMS AND BEDROOMS IN THE PROPERTY
SELECT property_type, ROUND(AVG(bathrooms), 0) AS avg_bathrooms, ROUND(AVG(bedrooms), 0) AS avg_bedrooms
FROM property_rentals
GROUP BY property_type;
    
SELECT *
FROM property_rentals
WHERE bathrooms > 2 OR bedrooms > 2;

#PRICE RANGE
/*
START TRANSACTION;
UPDATE property_rentals
SET price = CAST(REPLACE(price, '$', '') AS FLOAT);
COMMIT;

ALTER TABLE property_rentals
MODIFY COLUMN price INT;
*/

-- CHEAP
SELECT *
FROM property_rentals
WHERE price <= 100 AND minimum_nights <= 7;

SELECT property_type, COUNT(property_type)
FROM property_rentals
WHERE price <= 100 AND minimum_nights <= 7
GROUP BY property_type; -- HOUSE: MOST WIDELY OFFERED PROPERTY TYPE FOR "CHEAP" CATEGORY

SELECT *
FROM property_rentals
WHERE property_type = 'House' AND price <= 100 AND minimum_nights <= 7;

SELECT property_type, COUNT(property_type), ROUND(AVG(price), 2) AVG_Price 
FROM property_rentals
WHERE price <= 100 AND minimum_nights <= 7
GROUP BY property_type; -- HOSTEL: CHEAPEST FOR A WEEK RENT

-- GENERAL
SELECT property_type, COUNT(property_type)
FROM property_rentals
WHERE price > 100 AND minimum_nights <= 7
GROUP BY property_type; -- HOUSE: MOST COMMON PROPERTY TYPE OFFERING  LESS THAN OR A WEEK OF RENT

SELECT property_type, AVG(price)
FROM property_rentals
WHERE price > 100 AND minimum_nights <= 7
GROUP BY property_type; -- BED AND BREAKFEST = CHEAPEST FOR A WEEK RENT ABOVE $100

# LONG BOOKING PERIOD (GREATER THAN OR EQUAL TO 30 DAYS OF BOOKING PERIOD)
SELECT DISTINCT minimum_nights
FROM property_rentals;

-- CHEAP
SELECT property_type, COUNT(property_type), ROUND(AVG(price), 2) AVG_Price 
FROM property_rentals
WHERE price <= 100
GROUP BY property_type; -- BUNGALOW: CHEAPEST FOR 30 DAYS RENT

SELECT *
FROM property_rentals
WHERE price <= 100 AND property_type = "Bungalow";

SELECT *
FROM property_rentals
WHERE minimum_nights >=360;

/* CONTAIN IRRELEVANT VALUE
SELECT *
FROM property_rentals
WHERE price LIKE '"$%';

START TRANSACTION;
DELETE FROM property_rentals
WHERE price LIKE '"$%';
COMMIT;
*/

SELECT *
FROM property_rentals
WHERE minimum_nights >= 30;

SELECT COUNT(*)
FROM property_rentals
WHERE minimum_nights >= 30; -- 846 PROPERTIES AVAILABLE TO BOOK FOR LONGER PERIOD

SELECT property_type, AVG(price)
FROM property_rentals
WHERE minimum_nights >= 30
GROUP BY property_type; -- HOSTEL: CHEAPEST PROPERT TYPE TO RENT FOR 30 DAYS OR MORE

SELECT property_type, MAX(minimum_nights)
FROM property_rentals
WHERE property_type = 'Hostel';

#CREATE VIEW
CREATE VIEW `San Fransisco Property Rentals` AS
SELECT *
FROM property_rentals;