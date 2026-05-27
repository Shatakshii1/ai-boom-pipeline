/* 
  Compares survival rates of companies that recieved funding vs those that didn't.
  Answers: "Do funded startups survive at higher rates than unfunded ones?"
  Important finding: Minimal difference in survival rates between funded and unfunded companies (about 1%) which shows that funding alone doesn't guarantee survival.Funded companies do get more (12% vs 8%)
*/
CREATE TABLE analytics.startup_surival AS
  SELECT 
    status, 
    COUNT(company_name_clean) AS company_count, 
    AVG(funding_total_usd_clean) AS avg_funding,
    CASE 
      WHEN startup_name_clean IS NULL THEN "No Funding"
      ELSE "Funded"
    END AS Is_AI_Funded,
    ROUND(COUNT(company_name_clean) * 100 / SUM(COUNT(company_name_clean)) OVER (PARTITION BY CASE 
      WHEN startup_name_clean IS NULL THEN "No Funding"
      ELSE "Funded"
      END), 2) AS pct_group
  FROM transform_startups.clean_crunchbase AS C
  LEFT JOIN transform_funding.clean_funding_rounds AS F 
  ON C.company_name_clean = F.startup_name_clean
  GROUP BY 
    status, 
    CASE 
      WHEN startup_name_clean IS NULL THEN "No Funding" 
      ELSE "Funded" 
      END; 
