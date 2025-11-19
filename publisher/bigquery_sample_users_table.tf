# BigQuery Job to create sample users table in the shared dataset
resource "google_bigquery_job" "create_users_table" {
  project  = google_project.bq_publisher.project_id
  job_id   = "create_users_table_${substr(md5("${google_project.bq_publisher.project_id}-${google_bigquery_dataset.shared_dataset.dataset_id}-users-ddl"), 0, 12)}"
  location = var.region

  query {
    query = templatefile("${path.module}/../create_sample_users_table.sql", {
      project_id = google_project.bq_publisher.project_id
      dataset_id = google_bigquery_dataset.shared_dataset.dataset_id
    })

    allow_large_results = true
    use_legacy_sql      = false
    create_disposition  = ""
    write_disposition   = ""
  }

  depends_on = [
    google_bigquery_dataset.shared_dataset
  ]
}
