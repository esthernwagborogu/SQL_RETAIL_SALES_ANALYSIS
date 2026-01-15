DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
              transactions_id INT PRIMARY KEY,
			  sale_date DATE,
			  sale_time TIME,
			  customer_id INT,
			  gender VARCHAR (15),
			  age INT,
			  category VARCHAR(15),
			  quantiy INT,
			  price_per_unit FLOAT,
			  cogs FLOAT,
			  total_sale FLOAT	 
	         );
SELECT * FROM retail_sales
LIMIT 10;

SELECT 
COUNT(*) 
FROM retail_sales;

-- Data cleaning--
SELECT * FROM retail_sales
WHERE 
   transactions_id is NULL
   OR
   sale_date is NULL
   OR
   sale_time is NULL
   OR  
   category is NULL
   OR
   quantiy is NULL
   OR
   price_per_unit is NULL
   OR
   cogs is NULL
   OR
   total_sale is NULL;
   
DELETE FROM retail_sales
WHERE 
   transactions_id is NULL
   OR
   sale_date is NULL
   OR
   sale_time is NULL
   OR  
   category is NULL
   OR
   quantiy is NULL
   OR
   price_per_unit is NULL
   OR
   age is NULL
   OR
   cogs is NULL
   OR
   total_sale is NULL;

 --data exploration--
-- how many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales
-- 1987 total sales--
-- how many unique customer we have ?--
SELECT COUNT(Distinct customer_id) as total_sale FROM retail_sales
-- 155 distinct customer--
-- how many unique category we have
SELECT COUNT(Distinct category) as total_sale FROM retail_sales
--ans 3 categories
SELECT DISTINCT(category) FROM retail_sales
--Electronics, Clothing and Beauty --

-- Data Analysis and Business key problem
--Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
Select *
FROM retail_sales
WHERE category = 'Clothing'
      AND
	  TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	  AND 
	  quantiy >= 4;
--Write a SQL query to calculate the total sales (total_sale) for each category
SELECT 
     category,
	 SUM(total_sale) as net_sale,
	 COUNT(*) AS total_sales
FROM retail_sales
GROUP BY 1

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT 
ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
--Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
     category,
	 gender,
	 count(*) as total_transactions
FROM retail_sales
GROUP BY
       category,
	   gender
ORDER BY 1
--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT * FROM
(
SELECT 
     EXTRACT (YEAR FROM sale_date) as year,
	 EXTRACT (MONTH FROM sale_date) as month,
     AVG(total_sale) as avg_total_sale,
	 RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
group by 1,2
) as t1
WHERE rank = 1
or
SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') AS month,
    AVG(total_sale) AS avg_monthly_sale
FROM retail_sales
GROUP BY month
ORDER BY avg_monthly_sale DESC
LIMIT 2;

--**Write a SQL query to find the top 5 customers based on the highest total sales **
SELECT 
      customer_id,
	  SUM(total_sale)
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Write a SQL query to find the number of unique customers who purchased items from each category
SELECT 
      COUNT(DISTINCT customer_id),
	  category
FROM retail_sales
GROUP BY category

--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale
AS
(
SELECT *,
     CASE
	     WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'MORNING'
		 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		 ELSE 'EVENING'
	 END AS Shift       
FROM retail_sales
)
SELECT 
      Shift,
	  COUNT(*) as total_orders	     
FROM hourly_sale
GROUP BY Shift


--END OF ANALYSIS--