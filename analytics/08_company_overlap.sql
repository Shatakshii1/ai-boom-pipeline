/* 
  Identifies companies that appear in both the funding and layoff dataset
  Answers: "Did companies that received AI funding also lay off works and how close together were those events?"
  Important finding: AlphaSense laid off works 9 months before their last funding round, suggesting layoffs and funding aren't always casually linked
*/
CREATE TABLE analytics.company_overlap AS 
  WITH company_layoff_summary AS (
    SELECT 
      company_name_clean, 
      year_month, 
      laid_Off
    FROM transform_layoffs.clean_layoffs
  ),
  company_funding_summary AS (
    SELECT 
      startup_name_clean, 
      MAX(year_month) AS latest_funding_date,
      SUM(amount_million_usd) AS total_funding
    FROM transform_funding.clean_funding_rounds
    GROUP BY startup_name_clean
  ),

  company_overlap AS (
    SELECT 
      startup_name_clean, 
      latest_funding_date, 
      total_funding, 
      company_name_clean, 
      year_month, 
      laid_Off, 
      CAST(latest_funding_date AS DATE) AS funding_dateCast, 
      CAST(year_month AS DATE) AS layoff_dateCast, 
      months_between(CAST(latest_funding_date AS DATE), 
      CAST(year_month AS DATE)) AS months_gap
    FROM company_funding_summary AS F
    INNER JOIN company_layoff_summary AS L
    ON F.startup_name_clean = L.company_name_clean
  )
-- Categorizes the gap between last funding and layoff event
  SELECT startup_name_clean, latest_funding_date, total_funding, company_name_clean, year_month, laid_Off, funding_dateCast, layoff_dateCast, months_gap,
  CASE 
    WHEN months_gap = 0 THEN "Same Month"
    WHEN months_gap IN (1,2,3,4,5,6) THEN "Within 6 Months"
    WHEN months_gap IN (7,8,9,10,11,12) THEN "Within 1 Year"
  ELSE "Over 1 Year"
  END AS funding_gap
  FROM company_overlap;
