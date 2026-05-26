/*
  Researches whether layoffs and funding move together or independenty month by month.
  Important finding: Layoffs and funding spikes often happen in the same months, not sequentially which shows that the AI boom and job cuts are parallel events
*/
CREATE TABLE analytics.layoff_vs_funding_trends AS 
  WITH monthly_trends AS (
    SELECT 
      year_month, 
      total_funding, 
      total_layoff,
      -- Previous month values for month over month comparison
      LAG(total_funding, 1, 0) OVER (ORDER BY year_month ASC) AS prev_month_funding,
      LAG(total_layoff, 1, 0) OVER (ORDER BY year_month ASC) AS prev_month_layoff,
      -- How much funding and layoffs changed vs previous month
      (total_funding - LAG(total_funding, 1, 0) OVER (ORDER BY year_month ASC)) AS funding_change,
      (total_layoff - LAG(total_layoff, 1, 0) OVER (ORDER BY year_month ASC)) AS layoff_change
    FROM analytics.monthly_tech_pulse
  )
  SELECT 
    year_month, 
    total_funding, 
    total_layoff, 
    prev_month_funding, 
    prev_month_layoff, 
    funding_change, 
    layoff_change,
  -- Ranking by funding where 1 = lowest funding and layoff 1 = highest
  RANK() OVER (ORDER BY total_funding ASC) AS funding_rank,
  RANK() OVER (ORDER BY total_layoff DESC) AS layoff_rank
  FROM monthly_trends;