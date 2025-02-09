CREATE TABLE retail_sales(
transactions_id INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(15),
age INT,
category VARCHAR(15),
quantiy INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
)
SELECT * FROM retail_sales;
SELECT COUNT(*) FROM retail_sales;

-- Data Cleaning

SELECT * FROM retail_sales
WHERE sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL

DELETE FROM retail_sales
WHERE sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL

-- Data exploration
-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales
--How many unique customers
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

--How many unique category
SELECT COUNT(DISTINCT category) as total_sale FROM retail_sales
SELECT DISTINCT category FROM retail_sales

 -- Data analysis & business key problems and answers
 -- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-08'?
 SELECT *
 FROM retail_sales
 where sale_date = '2022-11-08'
 
 --Q2. wrtie a SQL query to retrieve all transactions where the category is 'clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
 SELECT *
 FROM retail_sales
 WHERE category = 'Clothing'
 AND STRFTIME('%Y-%m', sale_date) = '2022-11'
 AND quantiy>= 4

 -- Q3. Write a SQL query to calculate the total sales for each category
SELECT category,
SUM(total_sale) AS net_sale,
COUNT(*) as total_orders
FROM retail_sales
GROUP BY category 
 
-- Q4. Write a SQL query to find the average age of customers who purchased 'beauty' items category

SELECT 
ROUND(AVG(age),2) AS avg_age_of_customers
FROM retail_sales
WHERE category = 'Beauty'

--Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale > 1000

-- Q6. Write a SQL query to find the total number of transactions made by each gender in each category
SELECT
  category,
  gender,
  COUNT(*) AS num_of_transactions 
FROM
  retail_sales 
GROUP BY
  category,
  gender

--Q7. Write a SQL query to calculate the average sale for each month, find out the best selling month each year
SELECT
  year,
  month,
  MAX(avg_sale) AS avg_best_sale 
FROM
  (
    SELECT
      STRFTIME('%Y', sale_date) AS year,
      STRFTIME('%m', sale_date) AS month,
      ROUND(AVG(total_sale), 2) AS avg_sale 
    FROM
      retail_sales 
    GROUP BY
      1,
      2 
    ORDER BY
      1,
  3 DESC) 
GROUP BY
  year 
ORDER BY
  year

--Q8. Write a SQL query to find the top 5 customers based on the highest total sales
SELECT
  customer_id,
  SUM(total_sale) AS sale 
FROM
  retail_sales 
GROUP BY
  1 
ORDER BY
  sale DESC 
  LIMIT 5
  
--Q9. Write a SQL query to find the number of unique cusotmers from each category.
SELECT
  category,
  COUNT(DISTINCT customer_id) AS unique_customer 
FROM
  retail_sales 
GROUP BY
  category

--Q10. Write a SQL query to create each shift and number of orders (e.g., Morning<= 12 o clock, afternoon between 12 & 17, evening >17) 
SELECT
  shift,
  COUNT(*) AS number_of_orders 
FROM
  (
    SELECT
      *,
    CASE
        
        WHEN STRFTIME('%H', sale_time) < '12' THEN
        'Morning' 
        WHEN STRFTIME('%H', sale_time) BETWEEN '12' 
        AND '17' THEN
          'Afternoon' ELSE 'Evening' 
          END AS shift 
        FROM
      retail_sales) 
    GROUP BY
      shift
 
 --Q11. Write a SQL query to check the Gross profit and Gross margin made by the company.
SELECT
  category,
  SUM(total_sale) AS total_revenue,
  SUM(cogs) AS total_cogs,
  SUM(total_sale) - SUM(cogs) AS Gross_profit,
  ROUND(((SUM(total_sale) - SUM(cogs)) / SUM(total_sale)) * 100, 2) AS Gross_margin 
FROM
  retail_sales 
GROUP BY
  category 
ORDER BY
  Gross_profit DESC
 
 --Q12. Write a SQL query to check changes in profit of each category over the months. 
SELECT
  category,
  STRFTIME('%Y', sale_date) AS year,
  STRFTIME('%m', sale_date) AS month,
  SUM(total_sale) AS total_revenue,
  SUM(cogs) AS total_cogs,
  SUM(total_sale) - SUM(cogs) AS Gross_profit 
FROM
  retail_sales 
GROUP BY
  year,
  month,
  category 
ORDER BY
  year,
  month DESC
 
 --Q13. Write a SQL query to find the maximum profits made in each category and in which time of the year.
SELECT
  category,
  year,
  month,
  MAX(Gross_profit) AS Maximum_profit_in_a_month 
FROM
  (
    SELECT
      category,
      STRFTIME('%Y', sale_date) AS year,
      STRFTIME('%m', sale_date) AS month,
      SUM(total_sale) AS total_revenue,
      SUM(cogs) AS total_cogs,
      SUM(total_sale) - SUM(cogs) AS Gross_profit 
    FROM
      retail_sales 
    GROUP BY
      year,
      month,
      category 
    ORDER BY
      year,
  month DESC) 
GROUP BY
  year,
  category
 
 --Q14. Write a SQL query to determine which products are expensive to sell (high cogs).
SELECT
  category,
  SUM(cogs) AS Total_cogs 
FROM
  retail_sales 
GROUP BY
  category 
ORDER BY
  Total_cogs DESC
 
 --Q15. Write a SQL query to find out average age of customers who spend more than 500 in each purchase.
SELECT
  gender,
  ROUND(AVG(age), 2) AS avg_age_of_customer 
FROM
  retail_sales 
WHERE
  total_sale > 500 
GROUP BY
  gender
 --END OF PROJECT--
