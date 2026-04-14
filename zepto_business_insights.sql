
CREATE TABLE zepto (
  sku_id SERIAL PRIMARY KEY,
  category VARCHAR(120),
  name VARCHAR(150) NOT NULL,
  mrp NUMERIC(8,2),
  discountPercent NUMERIC(5,2),
  availableQuantity INTEGER,
  discountedSellingPrice NUMERIC(8,2),
  weightInGms INTEGER,
  outOfStock BOOLEAN,
  quantity INTEGER
);

-- Data Exploration 
select count(*) from zepto;

-- sample data
select * from zepto 
LIMIT 10;

--null values
select * from zepto
where name is null
or
category is null
or
mrp is null
or
discountpercent is null
or
discountedsellingprice is null
or
weightingms is null
or
availablequantity  is null
or
outofstock is null
or
quantity is null;

-- different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- products in stock vs out of stock
SELECT outofstock, COUNT(sku_id)
FROM zepto
GROUP BY outofstock;

-- product names present multiple times
SELECT name, COUNT(sku_id) AS "No of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

-- data cleaning 

--product with price 0
SELECT *
FROM zepto
WHERE mrp = 0 OR discountedsellingprice = 0;

DELETE FROM zepto
WHERE mrp = 0;


-- convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;

SELECT mrp, discountedsellingprice 
FROM zepto;


-- Business Insights

-- Q1. Find the top 10 best value products based on the discount percentage.

SELECT DISTINCT name, mrp, discountpercent
FROM zepto
ORDER BY discountpercent desc
LIMIT 10;


-- Q2. What are the products with high MRP but out of stock?

SELECT DISTINCT name, mrp
FROM zepto
WHERE outofstock = TRUE and mrp > 300
ORDER BY mrp desc;


-- Q3. Calculate estimated revenue for each category.

SELECT category, 
SUM(discountedsellingprice*availablequantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;


-- Q4. Find all products where mrp greater than ₹500 and Less than 10%.

SELECT DISTINCT name, mrp, discountpercent
FROM zepto
WHERE mrp > 500 AND discountpercent < 10
ORDER BY mrp DESC, discountpercent DESC;


-- Q5. Identify the top five categories offering the highest average discount percentage.

SELECT category, 
ROUND(AVG(discountpercent), 2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;


-- Q6. Find the price per gram for products above 100g and sort by best value.

SELECT DISTINCT name, weightingms, discountedsellingprice,
ROUND(discountedsellingprice/weightingms, 2) AS price_per_gram
FROM zepto
WHERE weightingms >= 100 
ORDER BY price_per_gram;


-- Q7. Group the products into categories like low, medium, bulk.

SELECT DISTINCT name, weightingms,
CASE WHEN weightingms < 1000 THEN 'Low'
	WHEN weightingms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;


-- Q8. What is the total inventory weight per category?

SELECT category, 
SUM(weightingms * availablequantity) AS total_inventory_weight
FROM zepto
GROUP BY category
ORDER BY total_inventory_weight;

