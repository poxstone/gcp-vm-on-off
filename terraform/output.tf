output "bucket_name" {
  value = google_storage_bucket.bucket_function.name
}

output "bucket_file_name" {
  value = google_storage_bucket_object.bucket_object_function.name
}

output "cloud_functions_name" {
  value = google_cloudfunctions_function.mv_function.name
}

output "google_cloud_scheduler_on" {
  value = google_cloud_scheduler_job.mv_schedule_on.name
}

output "google_cloud_scheduler_off" {
  value = google_cloud_scheduler_job.mv_schedule_off.name
}
