variable "cloudtrail-s3-bucket" {
  description = "Bucket name to store cloudtrail logs"
  default     = "ac-master-cloudtrail-bucket"
}

variable "cloudtrail-access-log-bucket" {
  description = "Bucket name to store access logs of cloudtrail log bucket"
  default     = "ac-cloudtrail-access-log-bucket"
}

variable "cloudtrail-glue-catalog-db" {
  description = "Glue Catalogue to store the results of CloudTrail log crawlers"
  default     = "ac-cloudtrail-glue-catalog-db"
}

variable "env" {
  description = "Development environment e.g. 'dev' or 'prod'"
  default     = "dev"
}
