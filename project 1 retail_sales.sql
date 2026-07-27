
#-----------------------------------------------------------------------------------
create database github_project1;
#------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------
use github_project1;
#------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------
CREATE TABLE `gihub_retail_sales1` (
  `Transaction_ID` text,
  `Order_Date` text,
  `Customer_ID` text,
  `Customer_Name` text,
  `Email` text,
  `City` text,
  `Region` text,
  `Segment` text,
  `Product_ID` text,
  `Product_Name` text,
  `Category` text,
  `Channel` text,
  `Payment_Method` text,
  `Quantity` int DEFAULT NULL,
  `Unit_Price` double DEFAULT NULL,
  `Discount_Pct` double DEFAULT NULL,
  `Gross_Sales` double DEFAULT NULL,
  `Discount_Amount` double DEFAULT NULL,
  `Net_Sales` double DEFAULT NULL,
  `Cost` double DEFAULT NULL,
  `Profit` double DEFAULT NULL,
  `Profit_Margin_Pct` double DEFAULT NULL,
  `Order_Status` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
#-------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------
select * from gihub_retail_sales1;
#-------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------
#1. Display all retail transactions

select * from gihub_retail_sales1;
#--------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------
rename table gihub_retail_sales1 to retail_sales;
select * from retail_sales;
#--------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------
#2. Display the first 20 transactions

select * from retail_sales limit 20;
#--------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------
#3. Show transaction ID, order date, customer and sales
select Transaction_ID,
		Order_Date,
		Customer_Name,
        (quantity*unit_price) as sales 
        from retail_sales;
        
#--------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------
#4. Find all completed orders  
select * from retail_sales where Order_Status = 'Completed';      

#---------------------------------------------------------------------------------------
#5. Find transactions with sales above £500
#---------------------------------------------------------------------------------------
select Transaction_ID,
		Customer_ID,
		Product_ID,
		Product_Name,
		Category,
        Net_Sales
        from retail_sales where Net_Sales > 500
        order by Net_Sales asc;
        
#--------------------------------------------------------------------------
 #6. Find all Electronics transactions
#---------------------------------------------------------------------------
select * from retail_Sales where category ='Electronics';

#--------------------------------------------------------------------------
#7. Find orders placed between two dates
#--------------------------------------------------------------------------
SELECT *
FROM retail_sales
WHERE order_date BETWEEN '2025-01-01' AND '2025-02-31'
ORDER BY order_date;

#-------------------------------------------------------------------------------------------
#8. Find customers from London or Manchester
#---------------------------------------------------------------------------
select Customer_ID,Customer_Name,City from retail_sales where city in('London','Manchester'); 



#----------------------------------------------------------------------------
#9. List unique product categories
#----------------------------------------------------------------------------
select Distinct Category  from retail_sales order by category;


#--------------------------------------------------------------------------------------------
#10. Find transactions with no discount
#--------------------------------------------------------------------------------------------
select * from retail_sales where Discount_pct = 0;

#############################################################################################
#aggregate functions
#############################################################################################
#11. Calculate total sales
#-------------------------------------------------------------------------------------------
select round(sum(Net_sales),2) as total_sales from retail_sales ;

#-------------------------------------------------------------------------------------------
#12. Calculate total profit
#-------------------------------------------------------------------------------------------
select round(sum(profit),2) as total_profit from retail_sales;


#-------------------------------------------------------------------------------------------
#13. Calculate total transactions and average order value
#-------------------------------------------------------------------------------------------
SELECT
    COUNT(*) AS total_transactions,
    ROUND(AVG(net_sales), 2) AS average_order_value
FROM retail_sales;

#-------------------------------------------------------------------------------------------
# 14. Calculate overall profit margin
#--------------------------------------------------------------------------------------------
select * from retail_sales;

select round(
	sum(profit)/ nullif(sum(net_sales),0) * 100 
			,2)  as profit_margin from retail_Sales;

#--------------------------------------------------------------------------------------------------
# 15. Show sales by category
#--------------------------------------------------------------------------------------------------
SELECT
    category,
    ROUND(SUM(net_sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;

#-----------------------------------------------------------------------------
# 16. Find the top 10 customers by sales
#-----------------------------------------------------------------------------
select * from retail_sales;
SELECT
    Customer_ID,	
    Customer_name,
    ROUND(SUM(net_sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY customer_id,customer_name
ORDER BY total_sales DESC
limit 10;

#-----------------------------------------------------------------------------
# 17. Find the top 10 products by revenue
#-----------------------------------------------------------------------------
select product_id,
	product_name, 
	ROUND(SUM(net_sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    category
	from retail_sales 
    group by category,product_id,product_name
    order by total_sales desc
    limit 10;
    
 #----------------------------------------------------------------------------------
 # 18. Find the best-selling products by units
 #----------------------------------------------------------------------------------
 select * from retail_sales;
 
 select product_id,	
		product_name,
        category,
        round(sum(unit_price),2) as unit 
        from retail_sales 
        where order_status = 'completed'
        group by category,product_id,product_name
		order by unit desc
        limit 10;
    
    #----------------------------------------------------------------------------------
    # 19. Show sales by region
    #----------------------------------------------------------------------------------
    select * from retail_sales;
    
    SELECT
    region,
    COUNT(*) AS transactions,
    ROUND(SUM(net_sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY region
ORDER BY total_sales DESC;

#----------------------------------------------------------------------------------
# 20. Show sales by channel
#------------------------------------------------------------------------------------
   
    SELECT
    channel,
    COUNT(*) AS transactions,
    ROUND(SUM(net_sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY channel
ORDER BY total_sales DESC;

############################################################################################################
# Intermediate SQL Questions
############################################################################################################
# 21. Calculate monthly sales and profit
select date_format(Order_Date,'%y-%m') as sale_month,
		count(*) as transactions,
        round(sum(Net_sales),2) as Monthly_sales,
        round(sum(Profit),2) as monthly_profit
        from retail_sales
        group by date_format(Order_Date,'%y-%m')
        order by Monthly_sales desc;

#--------------------------------------------------------------------------------------------
# 22. Find categories with sales above £10,000
#--------------------------------------------------------------------------------------------
select * from retail_sales;

SELECT
    category,
    ROUND(SUM(net_sales), 2) AS total_sales
FROM retail_sales
GROUP BY category
HAVING SUM(net_sales) > 10000
ORDER BY total_sales DESC;

#---------------------------------------------------------------------------------------
# 23. Calculate the return rate by category
#----------------------------------------------------------------------------------------
select category,
	sum(
		case 
		when order_status ='returned' then 1
		else 0
        end
       ) as retruned_status_count,
     round (100 *
			sum( case when order_status ='returned' then 1
            else 0
            end)/ count(*),2) as return_rate_pct
            FROM retail_sales
GROUP BY category
ORDER BY return_rate_pct DESC;

#--------------------------------------------------------------------------------------
# 24. Find customers who purchased from at least five categories
#---------------------------------------------------------------------------------------
SELECT
    customer_id,
    customer_name,
    category,
    SUM(net_sales) AS total_sales,
    COUNT(*) AS order_count
FROM retail_sales
GROUP BY
    customer_id,
    customer_name,
    category
HAVING COUNT(*) > 5
ORDER BY total_sales DESC
limit 50000;

#-------------------------------------------------------------------------------------------
# 25. Find customers with more than five transactions
#-------------------------------------------------------------------------------------------
select * from retail_sales;

select Customer_ID,customer_name,count(*) as total_transaction,sum(net_sales) as total_sales
from retail_sales 
group by customer_name,customer_id
having count(*) > 5
order by total_transaction desc;

##############################################################################################
# Advanced SQL Questions
##############################################################################################
#26. Rank customers by sales

select * from retail_sales;

with customer_sales as (
	select customer_ID,
			customer_name,
            round(sum(Net_Sales),2) as total_sales 
            from retail_sales
            group by customer_id,customer_name
            )
	select customer_ID,
		   customer_name,
            total_sales,
           dense_rank() over(order by total_sales desc) as rank_sales
           from customer_sales;
           
#---------------------------------------------------------------------------------------------
# 27. Rank customers within each region
#---------------------------------------------------------------------------------------------           
  select * from retail_sales;   
  
  with customer_region as(
     select customer_ID,
			customer_name,
			region,
            round(sum(Net_sales),2) as total_sales
			from  retail_sales
			group by region,customer_ID,customer_Name
            )
		select customer_ID,
			customer_name,
			region,
            total_sales,
            dense_rank() over(partition by region order by total_sales desc) as regional_rank
            from customer_region;
    
  
#-----------------------------------------------------------------------------------------------------------------
# 28. Calculate a running monthly sales total
#------------------------------------------------------------------------------------------------------------------
with monthly_sales as (
select date_format(order_date,'%y-%m') as sales_month,
        sum(Net_sales) as total_sales
        from retail_sales
        group by date_format(order_date,'%y-%m')
        )
      select 
		sales_month,
		total_sales,
        round(sum(total_sales)over(order by sales_month asc),2) as running_sales
        from monthly_sales;
        
 #---------------------------------------------------------------------------------------------
 # 29. Calculate month-over-month sales growth
 #---------------------------------------------------------------------------------------------
select * from retail_sales;	

with sales_month as(
		select date_format(order_date,'%y-%m') as sales_month,
        round(sum(Net_Sales),2) as total_sales
        from retail_sales
        group by date_format(order_date,'%y-%m')),
monthly_sales as (
		select sales_month,
        total_sales,
        lag(total_sales)over(order by sales_month) as previous_month 
        from sales_month )
select sales_month,
		total_sales,
        previous_month,
        round(100*(total_Sales - previous_month)/nullif(total_sales,0),2) as growth_pct
        from monthly_sales;
#---------------------------------------------------------------------------------------
# 30.Find each category’s percentage contribution to sales
#---------------------------------------------------------------------------------------------
SELECT
    category,
    ROUND(SUM(net_sales), 2) AS category_sales,
    ROUND(
        100 * SUM(net_sales)
        / SUM(SUM(net_sales)) OVER (),
        2
    ) AS sales_contribution_pct
FROM retail_sales
GROUP BY category
ORDER BY category_sales DESC;


#------------------------------------------------------------------------------------------------
# 31. Find the highest-selling product in each category
#------------------------------------------------------------------------------------------------
 WITH product_sales AS (
    SELECT
        category,
        product_id,
        product_name,
        SUM(net_sales) AS total_sales
    FROM retail_sales
    GROUP BY category, product_id, product_name
),
ranked_products AS (
    SELECT
        category,
        product_id,
        product_name,
        total_sales,
        DENSE_RANK() OVER (
            PARTITION BY category
            ORDER BY total_sales DESC
        ) AS product_rank
    FROM product_sales
)
SELECT
    category,
    product_id,
    product_name,
    ROUND(total_sales, 2) AS total_sales
FROM ranked_products
WHERE product_rank = 1;  

#----------------------------------------------------------------------------------
# 32. Find customers inactive for at least 90 days
# -----------------------------------------------------------------------------------   
  select * from retail_sales;      

  SELECT
    customer_id,
    customer_name,
    MAX(order_date) AS last_purchase_date,
    DATEDIFF(
        '2026-07-01',
        MAX(order_date)
    ) AS inactive_days
FROM retail_sales
GROUP BY customer_id, customer_name
HAVING inactive_days >= 90
ORDER BY inactive_days DESC;

#--------------------------------------------------------------------------
#   33. Create an RFM customer analysis
#---------------------------------------------------------------------------
  select * from retail_sales; 
  
  SELECT
    customer_id,
    customer_name,
    DATEDIFF(
        '2026-07-01',
        MAX(order_date)
    ) AS recency_days,
    COUNT(DISTINCT transaction_id) AS frequency,
    ROUND(SUM(net_sales), 2) AS monetary_value
FROM retail_sales
WHERE order_status = 'Completed'
GROUP BY customer_id, customer_name
ORDER BY monetary_value DESC;

#-----------------------------------------------------------------------------------------------
# 34. Find products responsible for the first 80% of revenue
#------------------------------------------------------------------------------------------------
select * from retail_sales;

WITH product_sales AS (
    SELECT
        product_name,
        SUM(net_sales) AS total_sales
    FROM retail_sales
    GROUP BY product_name
),
cumulative_sales AS (
    SELECT
        product_name,
        total_sales,
        SUM(total_sales) OVER (
            ORDER BY total_sales DESC
        ) AS running_sales,
        SUM(total_sales) OVER () AS overall_sales
    FROM product_sales
)
SELECT
    product_name,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(
        running_sales / overall_sales * 100,
        2
    ) AS cumulative_sales_pct
FROM cumulative_sales
WHERE running_sales / overall_sales <= 0.80
ORDER BY total_sales DESC;

#------------------------------------------------------------------------------------------
#35. Compare each product’s sales with its category average
#-----------------------------------------------------------------------------------------
WITH product_sales AS (
    SELECT
        category,
        product_name,
        SUM(net_sales) AS total_sales
    FROM retail_sales
    GROUP BY category, product_name
)
SELECT
    category,
    product_name,
    ROUND(total_sales, 2) AS product_sales,
    ROUND(
        AVG(total_sales) OVER (
            PARTITION BY category
        ),
        2
    ) AS category_average,
    ROUND(
        total_sales - AVG(total_sales) OVER (
            PARTITION BY category
        ),
        2
    ) AS difference_from_average
FROM product_sales
ORDER BY category, product_sales DESC;
#-----------------------------------------------------------------------------------
  #Data Quality Practice
#-----------------------------------------------------------------------------------
#36. Check for duplicate transaction IDs  
select * from retail_sales;

select count(*) as duplicate_count,
	   transaction_id 
       from retail_sales
       group by transaction_id
       having count(*) > 1;
       
#------------------------------------------------------------------------------------------------
# 37. Check for missing values
#-------------------------------------------------------------------------------------------------       
SELECT
    SUM(transaction_id IS NULL) AS missing_transaction_ids,
    SUM(order_date IS NULL) AS missing_order_dates,
    SUM(customer_id IS NULL) AS missing_customer_ids,
    SUM(product_id IS NULL) AS missing_product_ids,
    SUM(net_sales IS NULL) AS missing_sales
FROM retail_sales;
#---------------------------------------------------------------------------------------
# 38. Find invalid quantities or discounts
#---------------------------------------------------------------------------------------
select * from retail_sales
where Quantity <= 0 or Discount_Pct < 0 or discount_pct >1;

#---------------------------------------------------------------------------------------
#39. Verify the calculated net sales
#---------------------------------------------------------------------------------------
SELECT
    transaction_id,
    gross_sales,
    discount_amount,
    net_sales,
    ROUND(gross_sales - discount_amount, 2) AS calculated_net_sales
FROM retail_sales
WHERE ABS(
    net_sales - (gross_sales - discount_amount)
) > 0.01;

#-----------------------------------------------------------------------------------
# 40. Find completed transactions with negative profit
#-----------------------------------------------------------------------------------
SELECT
    transaction_id,
    customer_name,
    product_name,
    net_sales,
    cost,
    profit,
    discount_pct
FROM retail_sales
WHERE order_status = 'Completed'
  AND profit < 0
ORDER BY profit;

