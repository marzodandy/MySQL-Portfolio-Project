#AIM
/*
This project aims to answer the questions surrounding the healthcare industry which are contained in the related table, 
such as the most common medical conditions found in the patients, treatment duration, hospital, insurance, and other related aspects.
*/

#SUMMARY
/*
PATIENT AND MEDICAL CONDITION EXPLORATION
1. Arthritis is the most common condition, affecting 9,308 patients, followed by diabetes with 9,304 and hypertension with 9,245.
2. The gender distribution of medical conditions is nearly equal, with males at 50.04% and females at 49.96%.
3. The majority of patients are aged 37 (893 patients) and 38 (patients). Each covers roughly about 1.60% of the total patient data.
4. The average treatment duration is about 15 days per year, though it slightly decreased between 2020 and 2022.
5. The average treatment duration for all conditions is approximately 16 days.
6. Of the test results, 18,627 patients are abnormal, 18,517 are normal, and 18,356 are inconclusive.
7. Lipitor is the most prescribed medication, used by 11,140 patients.
8. Patients with blood type A are more affected by diseases, with 6,969 A- and 6,956 A+ patients impacted.

HOSPITAL EXPLORATION
Top 5 Hospital with the most amount of patients:
	1. LLC Smith:	44 patients
	2. Ltd Smith:	39 patients
	3. Johnson PLC:	38 patients
	4. Smith Ltd:	37 patients
	5. Smith Group:	36 patients
Based on the "Top 5 Hospital" data, the Smith Group corporation has the most patients, with a total amount of 156 patients.

BILLING AND INSURANCE EXPLORATION
1. Cigna is the number 1 insurance provider, with 11,249 patients using their services.
2. The highest bill was $52,764 for a 51-year-old hypertension patient Insurance was covered by Blue Cross.
3. Obesity is the medical condition that costs the most, with an average bill of $25,805.977. Followed by:
	1. Diabetes: $25638.40
	2. Asthma: $25635.25
	3. Arthritis: $25497.32
	4. Hypertension: $25497.10
	5. Cancer: $25161.79
*/

SELECT * FROM healthcare.healthcare_data_cleaned;

#CHECKING DUPLICATES
SELECT Name, Age, COUNT(*) dup
FROM healthcare_data_cleaned
GROUP BY Name, Age
HAVING dup > 1
ORDER BY 1;

#ADD COLUMN NUMBERING
START TRANSACTION;
ALTER TABLE healthcare_data_cleaned
ADD `No` INT AUTO_INCREMENT PRIMARY KEY FIRST;
COMMIT;

#PATIENT AND MEDICAL CONDITION EXPLORATION
-- AMOUNT OF PATIENT BASED ON MEDICAL CONDITION
SELECT `Medical.Condition`, COUNT(*) Amount
FROM healthcare_data_cleaned
GROUP BY `Medical.Condition`
ORDER BY Amount DESC;

-- MOST AFFECTED PATIENT BASED ON GENDER
SELECT `Gender`, COUNT(*) Amount
FROM healthcare_data_cleaned
GROUP BY `Gender`
ORDER BY Amount DESC;

-- MALE AFFECTED PERCENTAGE
WITH male AS (
	SELECT COUNT(*) male
    FROM healthcare_data_cleaned
    WHERE Gender = 'Male'
),

original AS(
	SELECT COUNT(*) original
    FROM healthcare_data_cleaned
)
SELECT ROUND((male/original)*100,2) male_percentage
FROM male, original;

-- MOST AFFECTED PATIENT BASED ON AGE (PERCENTAGE)
WITH age_percentage AS (
	SELECT Age, COUNT(*) AS Amount
    FROM healthcare_data_cleaned
    GROUP BY Age
    ORDER BY Amount DESC
),
`all` AS (
    SELECT COUNT(*) AS ori
    FROM healthcare_data_cleaned
)
SELECT ap.Age, ap.Amount, (ap.Amount / a.ori) * 100 AS Percentage
FROM age_percentage ap, `all` a
ORDER BY Percentage DESC;

-- AVERAGE PATIENT TREATMENT DURATION BASED ON YEAR (ARE THERE ANY IMPROVEMENTS FROM YEAR TO YEAR?)
WITH yty AS(
	SELECT YEAR(`Date.of.Admission`) yr, TIMESTAMPDIFF(DAY, `Date.of.Admission`, `Discharge.Date`) duration
    FROM healthcare_data_cleaned
)
SELECT yr, ROUND(AVG(duration), 2) Average_Day
FROM yty
GROUP BY yr
ORDER BY yr;

-- AVERAGE PATIENT TREATMENT DURATION BASED ON MEDICAL CONDITION
WITH duration AS(
	SELECT `Medical.Condition`, TIMESTAMPDIFF(DAY, `Date.of.Admission`, `Discharge.Date`) duration
    FROM healthcare_data_cleaned
)
SELECT `Medical.Condition`, ROUND(AVG(duration), 2) Average_Day
FROM duration
GROUP BY `Medical.Condition`;

-- AMOUNT OF DURATION THAT LASTED FOR 15 DAYS
WITH cnt AS(
SELECT TIMESTAMPDIFF(DAY, `Date.of.Admission`, `Discharge.Date`) Duration
FROM healthcare_data_cleaned
HAVING duration = 15
)
SELECT COUNT(duration)
FROM cnt;

-- "AMOUNT OF DURATION" FOR EACH DURATION
SELECT TIMESTAMPDIFF(DAY, `Date.of.Admission`, `Discharge.Date`) Duration, COUNT(*) Amount_of_Duration
FROM healthcare_data_cleaned
GROUP BY Duration
ORDER BY Amount_of_Duration;

-- PATIENT TEST RESULT
SELECT `Test.Results`, COUNT(*)
FROM healthcare_data_cleaned
GROUP BY 1
ORDER BY 2 DESC;

-- MOST USED MEDICATION
SELECT Medication, COUNT(*)
FROM healthcare_data_cleaned
GROUP BY 1
ORDER BY 2 DESC;

-- DOES BLOOD TYPE AFFECT PATIENTS' CHANGE TO GET DISEASES?
SELECT `Blood.Type`, COUNT(*)
FROM healthcare_data_cleaned
GROUP BY 1
ORDER BY 2 DESC;

#HOSPITAL EXPLORATION
SELECT DISTINCT Hospital
FROM healthcare_data_cleaned;

-- TOP 5 HOSPITAL THAT SERVED THE MOST PATIENT
SELECT Hospital, COUNT(*) Amount
FROM healthcare_data_cleaned
GROUP BY Hospital
ORDER BY Amount DESC
LIMIT 5;

#BILLING AND INSURANCE EXPLORATION
-- AMOUNT OF INSURANCE PROVIDED BY INSURANCE AGENT
SELECT `Insurance.Provider`, COUNT(*) Amount
FROM healthcare_data_cleaned
GROUP BY `Insurance.Provider`
ORDER BY Amount DESC;

-- UPDATING BILLING AMOUNT COLUMN (ROUNDING VALUES)
START TRANSACTION;
UPDATE healthcare_data_cleaned 
SET `Billing.Amount` = ROUND(`Billing.Amount`, 0);
COMMIT;

-- THE MOST BILLING AMOUNT A PATIENT HAS EVER PAID
SELECT `No`, `Name`, Gender, `Blood.Type`, `Medical.Condition`, `Billing.Amount`
FROM healthcare_data_cleaned
WHERE `Billing.Amount` = (SELECT MAX(`Billing.Amount`) FROM healthcare_data_cleaned);

-- AVERAGE BILL FROM MULTI MEDICAL CONDITION
SELECT `Medical.Condition`, ROUND(AVG(`Billing.Amount`), 2) Average_Bill
FROM healthcare_data_cleaned
GROUP BY 1
ORDER BY 2 DESC;
