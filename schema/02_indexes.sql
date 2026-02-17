CREATE INDEX IF NOT EXISTS ix_fact_category_week
	ON fact_weekly_sales (category, week);

CREATE INDEX IF NOT EXISTS ix_fact_product_week
	ON fact_weekly_sales (product_id, week);

CREATE INDEX IF NOT EXISTS ix_fact_promo
	ON fact_weekly_sales (promo_flag);