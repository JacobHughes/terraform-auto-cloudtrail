/**
 * S3 Bucket for storing CloudTrail logs access logs
 */
resource "aws_s3_bucket" "cloudtrail-access-log-bucket" {
  bucket        = "${var.cloudtrail-access-log-bucket}-${var.env}"
  acl           = "log-delivery-write"
  force_destroy = true

  tags {
    name = "S3 Cloudtrail Access Logs"
  }
}

/**
 * S3 bucket for storing CloudTrail logs
 * For terraform reasons, the policy needs to be detailed here, not in a separate
 * policy document and later attached.
 */
resource "aws_s3_bucket" "master-cloudtrail-bucket" {
  bucket        = "${var.cloudtrail-s3-bucket}-${var.env}"
  force_destroy = true

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${aws_s3_bucket.cloudtrail-access-log-bucket.id}"
    target_prefix = "log/"
  }

  tags {
    name = "S3 Master Cloudtrail"
  }

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.cloudtrail-s3-bucket}-${var.env}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.cloudtrail-s3-bucket}-${var.env}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Sid": "AWSGlueReadLogs",
            "Effect": "Allow",
            "Principal": {
              "Service": "glue.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.cloudtrail-s3-bucket}-${var.env}/*"
        }
    ]
}
POLICY
}

/*
 * Glue database for storing the db schemas that the crawler detects
 */
resource "aws_glue_catalog_database" "cloudtrail_glue_crawler_db" {
  name = "${var.cloudtrail-glue-catalog-db}-${var.env}"
}
