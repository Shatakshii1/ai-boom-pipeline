%sql
CREATE TABLE transform_layoffs.clean_layoffs AS
SELECT 
  Nr,
  TRIM(LOWER(Company)) AS company_name_clean,
  Company,
  Location_HQ,
  Region,
  USState,
  Country,
  Continent,
  Laid_Off,
  DATE_FORMAT(Date_layoffs, 'yyyy-MM') AS year_month,
  Percentage,
  Company_Size_before_Layoffs,
  Company_Size_after_layoffs,
  Industry,
  Stage,
  Money_Raised_in__mil,
  Year,
  latitude,
  longitude
FROM ingestion_layoffs.raw_layoffs
WHERE 
  Company IS NOT NULL; 
