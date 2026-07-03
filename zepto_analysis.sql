CREATE TABLE zepto (
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INT,
discountedSellingPrice NUMERIC(8,2),
weightInGms INT,
outOfStock BOOLEAN,
quantity INT
);

--data exploration

--count of rows
select count(*) from zepto;

--sample data
select * from zepto
Limit 10;

--null values
SELECT * from zepto
where name is null
or
category  is null
or
mrp is null
or
discountPercent is null
or
discountedSellingPrice is null
or
weightInGms is null
or
availableQuantity is null
or
outOfStock is null
or
Quantity is null;

--different product categories
Select DISTINCT category
From zepto
ORDER BY category;

--prodcuts in stock vs out of stock
Select outOfStock, COUNT(sku_id)
From zepto
GROUP BY outOfStock;

--product names present multiple times
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

--data cleaning

--products with price = 0
select * from zepto
where mrp = 0 OR discountedSellingPrice = 0;

Delete from zepto
where mrp = 0;

--convert paise to rupees
update zepto
Set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

select mrp, discountedSellingPrice from zepto

--Q1. Find the top 10 best-value products based on the discount percentage.
select distinct name,  mrp, discountPercent
from zepto
order BY discountPercent DESC
LIMIT 10;

--Q2. What are the Products with High MRP but Out of Stock.
Select DISTINCT name,mrp
From zepto
where outOfStock =  True and mrp > 300
ORDER BY mrp DESC;

--Q3. Calculate Estimated Revenue for each category 
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS Total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--Q4. Find all products where MRP is greater than 500 and discount is less than 10%
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
where mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

--Q5. Identify the top 5 categories offering the highest average discount percentage. 
SELECT category,
Round(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
Order BY avg_discount DESC
Limit 5;

--Q6. Find the price per gram for products above 100g and sort by best value. 
SELECT DISTINCT name, weightInGms, DiscountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

--08. What is the Total Inventory Weight Per Category
select category,
sum(weightInGms * availableQuantity) AS total_weight
FROM zepto
Group by category
order by total_weight;
