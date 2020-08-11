variable "project_id" {
  type = string
  description = "project id for create all resources"
}

variable "account_key" {
  type = string
  description = "Service account key with all required permissions"
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "schedule_chrone_on" {
  type = string
}

variable "schedule_chrone_off" {
  type = string
}

variable "service_account_email" {
  type = string
}

variable "deploy_name_prefix" {
  type = string
}

variable "time_zone" {
  type = string
}

variable "function_entry" {
  type = string
}

variable "message_instances" {
  type = string
}

variable "function_zip" {
  type = string
}

variable "function_runtime" {
  type = string
}

variable "function_timeout" {
  type = string
}