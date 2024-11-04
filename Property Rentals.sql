#AIM
/*
Categorize property for rental in San Fransisco based on the property type, minimum nights to book, and the price range, 
providing suggestions for a wide range of guests.
*/

#SUMMARY
/*
GENERAL
1. Top 3 property types for rent:
    1. Apartment: 912 units
    2. Houses: 621 units
    3. Condominium: 246 units
2. a) Average apartments come with 1 bathroom and 1 bedroom. 
   b) Houses typically offer 2 bathrooms and 2 bedrooms
   c) Condominiums and townhouses usually feature 1 bathroom and 2 bedrooms.
3. Bed and breakfasts are the most affordable property type, with an average price of $64.1 from 20 units.

SHORT TERM RENTAL
1. Houses are the most offered property for a week's rent under $100, with 120 units averaging $80.95.
2. Hostels are the cheapest option for a week's rent under $100, with 15 units available at an average price of $47.87.
3. For a week's rent over $100, bed and breakfasts are the most affordable property type, averaging $120.
4. Houses remain the most offered property type, with 354 units available for a price range above $100.

LONG TERM RENTAL
1. 846 properties are available for longer-term or monthly rentals, dominated by 515 units of apartments.
2. Hostels are the cheapest long-term rental option, with a minimum stay of 30 days and an average price of $44.50 per night.
3. A unit bungalow is available for only $40.00 with minimum nights of 30 days.
*/

#SUGGESTIONS
/* 
1. For a family who only plans a short-term rental on a budget, houses are the best option to choose.
2. For solo and multi-travelers, hostels are the most affordable option to rent for a short period.
3. If a "user" is looking for the most affordable property in general, bed & breakfasts are available with 20 units.
4. Based on the amount of units, apartments are the way to go for solo travelers, while 
   houses, condominiums, and townhouses are for a family or a group of travelers.
5. Apartments are the most offered and are available in both cost-friendly and higher-cost categories.
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

-- AFFORDABLE, SHORT-TERM RENTAL PROPERTY PROPERTY
SELECT *
FROM property_rentals
WHERE price <= 100 AND minimum_nights <= 7;

SELECT property_type, COUNT(property_type)
FROM property_rentals
WHERE price <= 100 AND minimum_nights <= 7
GROUP BY property_type; -- HOUSE: MOST WIDELY OFFERED PROPERTY TYPE FOR THE "AFFORDABLE" CATEGORY

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
GROUP BY property_type; -- HOUSE: MOST COMMON PROPERTY TYPE OFFERING LESS THAN OR A WEEK OF RENT

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
GROUP BY property_type; -- HOSTEL: CHEAPEST PROPERTY TYPE TO RENT FOR 30 DAYS OR MORE

SELECT property_type, MAX(minimum_nights)
FROM property_rentals
WHERE property_type = 'Hostel';

#CREATE VIEW
CREATE VIEW `San Fransisco Property Rentals` AS
SELECT *
FROM property_rentals;
