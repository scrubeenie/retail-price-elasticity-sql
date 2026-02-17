# Retail Price Elasticity (SQL)

SQL-first price elasticity estimation using log-differences and window functions, with 5%, 10%, and 15% price increase scenario modeling.

## Business Objective

Estimate product- and category-level price elasticity using simulated retail sales data, then simulate revenue impact under controlled price increase scenarios.

## Methodology

- Log-difference elasticity estimation  
- Window functions (LAG) for weekly price/volume deltas  
- Promo-week filtering  
- Product-level aggregation  
- Category-level executive summary  
- Revenue simulation modeling  

## Key Findings

- **Beverages (-0.60 elasticity)**: Inelastic demand; revenue increases under price increases  
- **Cereal (-1.13 elasticity)**: Highly elastic; price increases reduce revenue  
- **Snacks (-1.01 elasticity)**: Moderately elastic; aggressive increases reduce revenue  

## Run Order

1. `schema/01_create_tables.sql`
2. `schema/02_indexes.sql`
3. `queries/01_data_quality_checks.sql`
4. `queries/02_feature_engineering.sql`
5. `queries/03_elasticity_estimation.sql`
6. `queries/04_price_increase_simulation.sql`

## Scenario Output

![Scenario Modeling Output](assets/scenario_output.png)
