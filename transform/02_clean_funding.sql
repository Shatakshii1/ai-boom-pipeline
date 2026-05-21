 
CREATE TABLE transform_funding.clean_funding_rounds AS
SELECT
  round_id,
  startup_id,
  TRIM(LOWER(startup_name)) AS startup_name_clean ,
  DATE_FORMAT(funding_date, 'yyyy-MM') AS year_month,
  funding_date,
  year,
  quarter,
  funding_stage,
  amount_million_usd,
  pre_money_valuation_million_usd,
  post_money_valuation_million_usd,
  equity_dilution_pct,
  lead_investor,
  investor_type,
  num_investors,
  sector,
  country,
  region,
  city
FROM ingestion_funding.raw_funding_rounds
WHERE 
  amount_million_usd IS NOT NULL;