-- queries/02_feature_engineering.sql
SET search_path TO price_elasticity;

-- STEP 7: Weekly price changes (feature engineering)
WITH weekly_changes AS (
    SELECT
        week,
        product_id,
        category,
        promo_flag,
        log_price,
        log_units,
        log_price - LAG(log_price) OVER (PARTITION BY product_id ORDER BY week) AS dln_price,
        log_units - LAG(log_units) OVER (PARTITION BY product_id ORDER BY week) AS dln_units
    FROM fact_weekly_sales
)
SELECT
    week,
    product_id,
    category,
    promo_flag,
    log_price,
    log_units,
    dln_price,
    dln_units
FROM weekly_changes
ORDER BY category, product_id, week;
