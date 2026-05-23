CREATE TABLE transform_reddit.clean_reddit_ds AS
SELECT 
  DATE_FORMAT(created_date, 'yyyy-MM') AS year_month,
  created_timestamp,
  subreddit,
  title,
  id,
  author,
  author_created_utc,
  full_link,
  score,
  num_comments,
  (score * 1 + num_comments * 5) AS engagement_score,
  num_crossposts,
  subreddit_subscribers,
  post
FROM ingestion_reddit.raw_reddit_ds
--Give me any posts that belong to any of these 8 subreddits
WHERE
  subreddit IN ("MachineLearning", "datascience", "dataengineering", "artificial", "learnmachinelearning", "DataScienceJobs", "MLQuestions", "deeplearning") AND
  YEAR(created_date) >= 2020 AND
  title IS NOT NULL AND
  id IS NOT NULL;