create table zepto(
sku_id SERIAL primary key,
category varchar(120),
name varchar(150) not null,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice  NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

-- Data exploration 

-- Sample Data
SELECT * FROM zepto
Order by 1;


-- Null values 
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
availablequantity IS NULL
OR
discountedsellingprice IS NULL
OR
weightInGms IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

-- Different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- product in-stock vs out of stock
SELECT outOfStock,COUNT(sku_id)
FROM zepto
GROUP BY outOfStock

-- product name present multiple times
SELECT name,COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

-- DATA CLEANING

-- product with price =0 
SELECT * FROM zepto 
WHERE mrp = 0;

DELETE FROM zepto
WHERE mrp = 0;

-- convert paisa to rupees
UPDATE zepto
SET mrp = mrp/100.0
discountedsellingprice = discountedsellingprice/100.0

-- Q1.Find the top 10 best value products based on the discount percentage.
SELECT DISTINCT name,mrp,discountpercent
FROM zepto
ORDER BY discountpercent DESC
LIMIT 10;

-- Q2. what are the product with High mrp but Out of stock.
SELECT DISTINCT name,mrp 
FROM zepto 
WHERE outofstock = TRUE AND mrp > 300
ORDER BY mrp DESC;

-- Q3.Calculate Estimated Revenue for each category
SELECT DISTINCT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto 
GROUP BY category 
ORDER BY total_revenue;

-- Q4 Find all product where MRP is greater than 500 and discount is less than 10%.
SELECT DISTINCT name,mrp,discountPercent
FROM zepto 
WHERE mrp >500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest avergae discount percentage.
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6.Find the price per gram for products above 100g and sort by best value.
 SELECT DISTINCT name,weightInGms,discountedSellingPrice,
 ROUND(discountedSellingPrice/weightInGms,2) As price_per_gram
 FROM zepto
 WHERE weightInGms >= 100
 ORDER BY price_per_gram ASC;
 
-- Q7.Group the products into categories like low,Medium,bulk.
SELECT DISTINCT name,weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
     WHEN weightInGms < 5000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS Weight_category
FROM zepto;

-- Q8.What is the Total Inventory Weight Per Category
  SELECT category,
  SUM(weightInGms * availableQuantity) AS total_Weight
  FROM Zepto
  GROUP BY category
  ORDER BY total_Weight;

