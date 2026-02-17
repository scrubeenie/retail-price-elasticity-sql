--Row Counts
SELECT COUNT(*) AS dim_product_rows FROM dim_product; -- 30 records
SELECT COUNT(*) AS fact_rows FROM fact_weekly_sales;

--Date Range
SELECT MIN(week), MAX(week)
FROM fact_weekly_sales;

--Category Distribution
SELECT category,
       COUNT(*) AS rows,
       AVG(units) AS avg_units,
       AVG(price) AS avg_price
FROM fact_weekly_sales
GROUP BY category;

--Invalid Values Check
SELECT *
FROM fact_weekly_sales
WHERE price <= 0
   OR units < 0
   OR promo_flag NOT IN (0,1);
