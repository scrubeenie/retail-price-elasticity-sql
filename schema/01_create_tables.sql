-- STEP 1: Set Search Path and Create Tables
SET search_path TO price_elasticity;

CREATE TABLE dim_product (
  product_id       TEXT PRIMARY KEY,
  category         TEXT NOT NULL,
  base_price       NUMERIC(10,2) NOT NULL,
  true_elasticity  NUMERIC(10,4)
);

CREATE TABLE fact_weekly_sales (
  week        DATE NOT NULL,
  product_id  TEXT NOT NULL,
  category    TEXT NOT NULL,
  price       NUMERIC(10,2) NOT NULL,
  units       INTEGER NOT NULL,
  promo_flag  SMALLINT NOT NULL,
  log_price   NUMERIC(12,6),
  log_units   NUMERIC(12,6),

  CONSTRAINT pk_fact_weekly_sales PRIMARY KEY (week, product_id),
  CONSTRAINT fk_fact_product FOREIGN KEY (product_id)
      REFERENCES dim_product(product_id),

  CONSTRAINT chk_price_positive CHECK (price > 0),
  CONSTRAINT chk_units_nonneg CHECK (units >= 0),
  CONSTRAINT chk_promo_flag CHECK (promo_flag IN (0,1))
);