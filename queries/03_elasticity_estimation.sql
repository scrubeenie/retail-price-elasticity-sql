-- STEP 8: Compute Product-Level Elasticity (Average)
WITH weekly_changes AS (
    SELECT
        week,
        product_id,
        category,
        promo_flag,
        log_price - LAG(log_price) OVER (PARTITION BY product_id ORDER BY week) AS dln_price,
        log_units - LAG(log_units) OVER (PARTITION BY product_id ORDER BY week) AS dln_units
    FROM fact_weekly_sales
),
weekly_elasticity AS (
    SELECT
        product_id,
        category,
        dln_units / NULLIF(dln_price, 0) AS elasticity_week
    FROM weekly_changes
    WHERE promo_flag = 0
      AND dln_price IS NOT NULL
      AND dln_price <> 0
)
SELECT
    product_id,
    category,
    ROUND(AVG(elasticity_week)::NUMERIC, 4) AS estimated_elasticity,
    COUNT(*) AS observations
FROM weekly_elasticity
GROUP BY 1,2
ORDER BY category, estimated_elasticity;


-- STEP 9: Validate against True Elasticity
WITH weekly_changes AS (
    SELECT
        week,
        product_id,
        category,
        promo_flag,
        log_price - LAG(log_price) OVER (PARTITION BY product_id ORDER BY week) AS dln_price,
        log_units - LAG(log_units) OVER (PARTITION BY product_id ORDER BY week) AS dln_units
    FROM fact_weekly_sales
),
weekly_elasticity AS (
    SELECT
        product_id,
        category,
        dln_units / NULLIF(dln_price, 0) AS elasticity_week
    FROM weekly_changes
    WHERE promo_flag = 0
      AND dln_price IS NOT NULL
      AND dln_price <> 0
),
product_estimates AS (
    SELECT
        product_id,
        category,
        AVG(elasticity_week) AS estimated_elasticity
    FROM weekly_elasticity
    GROUP BY 1,2
)
SELECT
    p.product_id,
    p.category,
    ROUND(d.true_elasticity::NUMERIC, 4) AS true_elasticity,
    ROUND(p.estimated_elasticity::NUMERIC, 4) AS estimated_elasticity,
    ROUND((p.estimated_elasticity - d.true_elasticity)::NUMERIC, 4) AS error
FROM product_estimates p
JOIN dim_product d USING (product_id)
ORDER BY p.category, p.product_id;


-- STEP 10: Category-LEVEL Elasticity Summary (Executive Focused)
WITH weekly_changes AS (
    SELECT
        week,
        product_id,
        category,
        promo_flag,
        log_price - LAG(log_price) OVER (PARTITION BY product_id ORDER BY week) AS dln_price,
        log_units - LAG(log_units) OVER (PARTITION BY product_id ORDER BY week) AS dln_units
    FROM fact_weekly_sales
),
weekly_elasticity AS (
    SELECT
        category,
        dln_units / NULLIF(dln_price, 0) AS elasticity_week
    FROM weekly_changes
    WHERE promo_flag = 0
      AND dln_price IS NOT NULL
      AND dln_price <> 0
)
SELECT
    category,
    ROUND(AVG(elasticity_week)::numeric, 4) AS category_elasticity,
    COUNT(*) AS observations
FROM weekly_elasticity
GROUP BY 1
ORDER BY 1;
