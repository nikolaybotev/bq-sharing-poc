-- Create a sample users table in the shared BigQuery dataset
-- This query creates a table with id and name columns and inserts 5 sample rows

CREATE TABLE IF NOT EXISTS `${project_id}.${dataset_id}.users` (
  id INT64,
  name STRING
) AS
SELECT * FROM UNNEST([
  STRUCT(1 AS id, 'Alice Johnson' AS name),
  STRUCT(2 AS id, 'Bob Smith' AS name),
  STRUCT(3 AS id, 'Charlie Brown' AS name),
  STRUCT(4 AS id, 'Diana Prince' AS name),
  STRUCT(5 AS id, 'Eve Williams' AS name)
]);
