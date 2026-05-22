CREATE TABLE transform_startups.clean_crunchbase AS
SELECT
  CASE 
    WHEN funding_total_usd = '-' THEN NULL
    ELSE CAST(funding_total_usd AS DOUBLE)
  END AS funding_total_usd_clean,
  permalink,
  TRIM(LOWER(name)) AS company_name_clean,
  name,
  homepage_url,
  category_list,
  funding_total_usd,
  status,
  country_code,
  state_code,
  region,
  city,
  funding_rounds,
  DATE_FORMAT(founded_at, 'yyyy-MM') AS year_month,
  first_funding_at,
  last_funding_at
FROM ingestion_startups.raw_crunchbase
WHERE name IS NOT NULL; 
