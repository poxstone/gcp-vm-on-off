# Module Projec API activation
module "project-services" {
  source        = "terraform-google-modules/project-factory/google//modules/project_services"
  version       = "4.0.0"

  project_id                  = var.project_id
  disable_services_on_destroy = false

  activate_apis               = [
                                "pubsub.googleapis.com",
                                "cloudscheduler.googleapis.com",
                                "cloudfunctions.googleapis.com",
                                "storage.googleapis.com",
                                "cloudbuild.googleapis.com",
                                "appengine.googleapis.com"
                              ]
}

# pub/sub
resource "google_pubsub_topic" "topic_schedule" {
  name = "${var.deploy_name_prefix}-schedule"
}

# cloud functions
resource "google_storage_bucket" "bucket_function" {
  name = "${var.project_id}-${var.deploy_name_prefix}"
}

resource "google_storage_bucket_object" "bucket_object_function" {
  name   = "${var.deploy_name_prefix}-function.zip"
  bucket = google_storage_bucket.bucket_function.name
  source = var.function_zip
}

resource "google_cloudfunctions_function" "mv_function" {
  name                  = "${var.deploy_name_prefix}-schedule"
  runtime               = var.function_runtime
  entry_point           = var.function_entry
  timeout               = var.function_timeout
  
  event_trigger {
    event_type          = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource            = google_pubsub_topic.topic_schedule.id
    failure_policy {
      retry = true
    }
  }
  
  source_archive_bucket = google_storage_bucket.bucket_function.name
  source_archive_object = google_storage_bucket_object.bucket_object_function.name
  service_account_email = var.service_account_email
  available_memory_mb   = 128
}

# schedule on
resource "google_cloud_scheduler_job" "mv_schedule_on" {
  name        = "${var.deploy_name_prefix}-on"
  time_zone   = var.time_zone
  schedule    = var.schedule_chrone_on

  pubsub_target {
    topic_name = google_pubsub_topic.topic_schedule.id
    data       = base64encode("{ 'on_off': 'on', ${var.message_instances} }")
  }
}

# schedule off
resource "google_cloud_scheduler_job" "mv_schedule_off" {
  name        = "${var.deploy_name_prefix}-off"
  time_zone   = var.time_zone
  schedule    = var.schedule_chrone_off

  pubsub_target {
    topic_name = google_pubsub_topic.topic_schedule.id
    data       = base64encode("{ 'on_off': 'off', ${var.message_instances} }")
  }
}
