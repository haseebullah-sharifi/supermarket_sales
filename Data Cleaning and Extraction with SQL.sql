-- Data cleaning and extraction of useful data with SQL
-- Dataset: Supermarket Sales
-- Data Source: https://www.kaggle.com/datasets/aungpyaeap/supermarket-sales


-- Overview of the dataset

SELECT *
FROM supermarket.supermarket_sales;


-- Creating a new table (supermarket_sales1) for data cleaning and extracting useful data that we will be working with in next steps

CREATE TABLE supermarket.supermarket_sales1
LIKE supermarket.supermarket_sales;


INSERT supermarket.supermarket_sales1
SELECT *
FROM supermarket.supermarket_sales;


SELECT *
FROM supermarket.supermarket_sales1;


/* Data Cleaning */

-- In 3 steps I will check the dataset that whether it is clean or not, if not then I will clean it based on each step

-- Step 1. Finding Duplicates

-- There are 2 ways to find duplicates:

# I - When there is no primary key we need to use ROW_NUMBER and PARTITION BY clauses which is the advanced way of finding duplicates

SELECT *,
	ROW_NUMBER () OVER(
		PARTITION BY `Invoice ID`, Branch, City, `Customer type`, Gender, `Product line`, `Unit price`, Quantity, `Tax 5%`, Total, `Date`,
						`Time`, Payment, cogs, `gross margin percentage`, `gross income`, Rating) AS row_num
FROM supermarket.supermarket_sales1;


WITH `Duplicates` AS
	(
    SELECT *,
		ROW_NUMBER () OVER(
			PARTITION BY `Invoice ID`, Branch, City, `Customer type`, Gender, `Product line`, `Unit price`, Quantity, `Tax 5%`, Total, `Date`,
							`Time`, Payment, cogs, `gross margin percentage`, `gross income`, Rating) AS row_num
	FROM supermarket.supermarket_sales1
    )
SELECT *
FROM `Duplicates`
WHERE row_num > 1;


# II - When primary key is available then we can find duplicates with COUNT and COUNT DISTINCT clauses

SELECT
	COUNT(DISTINCT `Invoice ID`) AS `Total Distinct Invoice IDs`,
	COUNT(`Invoice ID`) AS `Total Invoice IDs`
FROM supermarket.supermarket_sales1;


-- Based on the results of the queries there is no duplicate in the dataset


-- Step 2. Standardizing the Data

# Trimming

UPDATE supermarket.supermarket_sales1
SET
	`Invoice ID` = TRIM(`Invoice ID`),
    Branch = TRIM(Branch),
    City = TRIM(City),
    `Customer type` = TRIM(`Customer type`),
    Gender = TRIM(Gender),
    `Product line` = TRIM(`Product line`),
    `Date` = TRIM(`Date`),
    `Time` = TRIM(`Time`),
    Payment = TRIM(Payment);
    
    
SELECT *
FROM supermarket.supermarket_sales1;


# Checking columns for errors and typos

SELECT
	DISTINCT Branch
FROM supermarket.supermarket_sales1;


SELECT
	DISTINCT City
FROM supermarket.supermarket_sales1;


SELECT
	DISTINCT `Customer type`
FROM supermarket.supermarket_sales1;


SELECT
	DISTINCT Gender
FROM supermarket.supermarket_sales1;


SELECT
	DISTINCT `Product line`
FROM supermarket.supermarket_sales1;


SELECT
	DISTINCT Payment
FROM supermarket.supermarket_sales1;


-- Based on the results of the queries there is no error or typo in the dataset


# Updating date column from text to standard date format

SELECT
	`date`
FROM supermarket.supermarket_sales1;


SELECT
	`date`,
    str_to_date(`date`, '%m/%d/%Y') AS standard_date
FROM supermarket.supermarket_sales1;


UPDATE supermarket.supermarket_sales1
SET `date` = str_to_date(`date`, '%m/%d/%Y');


/* The date column is updated but it still shows the date column in text format in the Schemas. In order to change it we need to ALTER the
table and MODIFY COLUMN */

ALTER TABLE supermarket.supermarket_sales1
MODIFY COLUMN `date` DATE;


# Updating time column from text to standard time format

SELECT
	`time`
FROM supermarket.supermarket_sales1;


SELECT
	`time`,
    time_format(`time`, '%H:%i:%s') AS standard_time
FROM supermarket.supermarket_sales1;


UPDATE supermarket.supermarket_sales1
SET `time` = time_format(`time`, '%H:%i:%s');


/* The time column is updated but it still shows the time column in text format in the Schemas. In order to change it we need to ALTER the
table and MODIFY COLUMN */

ALTER TABLE supermarket.supermarket_sales1
MODIFY COLUMN `time` TIME;


-- Step 3. Searching data for NULL values

SELECT *
FROM supermarket.supermarket_sales1;


SELECT *
FROM supermarket.supermarket_sales1
WHERE `Invoice ID` IS NULL
	OR `Invoice ID` = '';


SELECT *
FROM supermarket.supermarket_sales1
WHERE Branch IS NULL
	OR Branch = '';
    

SELECT *
FROM supermarket.supermarket_sales1
WHERE City IS NULL
	OR City = '';
    

-- I checked all columns one by one, there is no blank or NULL value in the dataset


/* Useful data extraction */

-- I will choose the columns which are useful for analyzing the data and creating charts and dashboard

SELECT *
FROM supermarket.supermarket_sales1;


SELECT
	Branch,
    City,
    `Customer type`,
    Gender,
    `Product line`,
    `Unit price`,
    Quantity,
    Total,
    `date`,
    `time`,
    payment,
    cogs,
    `gross income`,
    Rating
FROM supermarket.supermarket_sales1;