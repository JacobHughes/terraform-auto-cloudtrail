/**
 * CloudTrail resource for monitoring all services
 */
resource "aws_cloudtrail" "master_cloudtrail" {
  name                          = "master-cloudtrail-${var.env}"
  s3_bucket_name                = "${aws_s3_bucket.master-cloudtrail-bucket.id}"
  s3_key_prefix                 = "cloudtrail"
  include_global_service_events = true
  enable_log_file_validation    = true
  enable_logging                = true
  is_multi_region_trail         = true

  tags {
    name = "Master Cloudtrail"
  }
}

/*
 * Glue crawler for detecting the schema from the CloudTrail logs
 */
resource "aws_glue_crawler" "example" {
  database_name = "${aws_glue_catalog_database.cloudtrail_glue_crawler_db.name}"
  name          = "cloudtrail-log-crawler-${var.env}"
  role          = "${aws_iam_role.glue-crawler-read-logs-role.arn}"

  s3_target {
    path = "s3://${aws_s3_bucket.master-cloudtrail-bucket.bucket}"
  }
}

/*
 * Example query for investigating CloudTrail logs
 */
resource "aws_athena_named_query" "example-query" {
  name        = "athena-example-query-${var.env}"
  database    = "${aws_glue_catalog_database.cloudtrail_glue_crawler_db.name}"
  query       = "SELECT COUNT(DISTINCT awsaccountid) FROM cloudtrail_digest;"
  description = "A simple query example to count the number of distinct AWS accounts in the CloudTrail logs"
}
