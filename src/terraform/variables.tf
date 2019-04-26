variable "cloudtrail-s3-bucket" {
  description = "Bucket name to store cloudtrail logs"
  default     = "tac-master-cloudtrail-bucket"
}

variable "cloudtrail-access-log-bucket" {
  description = "Bucket name to store access logs of cloudtrail log bucket"
  default     = "tac-cloudtrail-access-log-bucket"
}

variable "cloudtrail-glue-catalog-db" {
  description = "Glue Catalogue to store the results of CloudTrail log crawlers"
  default     = "tac-cloudtrail-glue-catalog-db"
}

variable "env" {
  description = "Development environment e.g. 'dev' or 'prod'"
  default     = "dev"
}
