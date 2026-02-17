-- queries/04_price_increase_simulation.sql
SET search_path TO price_elasticity;

-- STEP 11: Scenario Modeling (5/10/15%)
WITH weekly_changes AS (
    SELECT
        week,
        product_id,
        category,
        promo_flag,
        price,
        units,
        (log_price - LAG(log_price) OVER (PARTITION BY product_id ORDER BY week)) AS dln_price,
        (log_units - LAG(log_units) OVER (PARTITION BY product_id ORDER BY week)) AS dln_units
    FROM fact_weekly_sales
),
weekly_elasticity AS (
    SELECT
        category,
        (dln_units / NULLIF(dln_price, 0)) AS elasticity_week
    FROM weekly_changes
    WHERE promo_flag = 0
      AND dln_price IS NOT NULL
      AND dln_price <> 0
      AND dln_units IS NOT NULL
),
category_elasticity AS (
    SELECT
        category,
        AVG(elasticity_week) AS elasticity
    FROM weekly_elasticity
    GROUP BY category
),
baseline AS (
    SELECT
        category,
        SUM(units) AS base_units,
        SUM(price * units) AS base_revenue
    FROM fact_weekly_sales
    WHERE promo_flag = 0
    GROUP BY category
),
scenarios AS (
    SELECT 0.05::numeric AS pct_increase
    UNION ALL SELECT 0.10
    UNION ALL SELECT 0.15
)
SELECT
    b.category,
    s.pct_increase,
    ROUND(e.elasticity::numeric, 4) AS elasticity,
    ROUND(b.base_revenue::numeric, 2) AS base_revenue,
    ROUND((b.base_units * (1 + e.elasticity * s.pct_increase))::numeric, 0) AS projected_units,
    ROUND((b.base_revenue * (1 + s.pct_increase) * (1 + e.elasticity * s.pct_increase))::numeric, 2) AS projected_revenue,
    ROUND(((b.base_revenue * (1 + s.pct_increase) * (1 + e.elasticity * s.pct_increase)) - b.base_revenue)::numeric, 2) AS revenue_change
FROM baseline b
JOIN category_elasticity e USING (category)
CROSS JOIN scenarios s
ORDER BY b.category, s.pct_increase;
