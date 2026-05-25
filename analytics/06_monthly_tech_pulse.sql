/*
  Master joined table comibing funding, layoffs and Reddit activity by month. 
  Used as the foundation for all other analytics tables.
*/
CREATE TABLE analytics.monthly_tech_pulse AS
WITH funding_monthly AS (
  -- Total funding raised and number of deals per month
  SELECT year_month, sum(amount_million_usd) as total_funding, COUNT(year_month) AS funding_deals
  FROM transform_funding.clean_funding_rounds
  GROUP BY year_month
),

 layoffs_monthly AS (
  -- Total people laid off and average layoff percentage per month
  SELECT year_month, sum(Laid_Off) AS total_layoff, AVG(Percentage) AS percent_layoff
  FROM transform_layoffs.clean_layoffs
  GROUP BY year_month
),

 reddit_monthly AS (
  -- Combined post volume and engagement from both Reddit datasets per month
  SELECT year_month, COUNT(post) AS num_posts, AVG(engagement_score) AS avg_engagement
  FROM transform_reddit.clean_reddit_ds
  GROUP BY year_month

  UNION ALL
  
  SELECT year_month, COUNT(id) AS num_posts, AVG(engagement_score) AS avg_engagement 
  FROM transform_reddit.clean_reddit_tech
  GROUP BY year_month
)
-- Full joined all tables
  SELECT COALESCE(F.year_month, L.year_month, R.year_month) AS year_month, 
    F.total_funding, 
    F.funding_deals, 
    L.total_layoff, 
    L.percent_layoff, 
    R.num_posts, 
    R.avg_engagement
  FROM funding_monthly AS F
  FULL JOIN layoffs_monthly AS L
  ON F.year_month = L.year_month
  FULL JOIN reddit_monthly AS R
  ON F.year_month = R.year_month
  WHERE COALESCE(F.year_month, L.year_month, R.year_month) IS NOT NULL;
