/* Source: Reddit Data Science Posts 500k+ */
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
WHERE
  subreddit IN ("MachineLearning", "datascience", "dataengineering", "artificial", "learnmachinelearning", "DataScienceJobs", "MLQuestions", "deeplearning") AND
  YEAR(created_date) >= 2020 AND
  title IS NOT NULL AND
  id IS NOT NULL;


/* Source: Reddit r/technology Submissions & Comments */
CREATE TABLE transform_reddit.clean_reddit_tech AS
SELECT 
  title,
  score,
  id,
  url,
  (score * 1 + comms_num * 5) AS engagement_score,
  comms_num,
  created,
  body,
  DATE_FORMAT(timestamp, "yyyy-MM") AS year_month
FROM ingestion_reddit.raw_reddit_tech
WHERE title IS NOT NULL AND id IS NOT NULL;