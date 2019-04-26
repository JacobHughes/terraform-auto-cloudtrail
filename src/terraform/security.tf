/**
 * AWS IAM Role which wil allow the glue crawler access to the CloudTrail
 * S3 bucket and permissions associated with AWS Glue
 */
resource "aws_iam_role" "glue-crawler-read-logs-role" {
  name = "glue-crawler-read-logs-role"

  assume_role_policy = <<POLICY
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "glue.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": "GlueCrawlerReadLogsRole"
   }
 ]
}
POLICY
}

/*
 * Remote data: IAM policy allowing for Glue service roll
 */
data "aws_iam_policy" "AWSGlueServiceRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

/*
 * IAM policy allowing object retreival on the CloudTrail logs
 */
resource "aws_iam_policy" "read-s3-bucket-policy" {
  name        = "read-s3-bucket-policy"
  description = "AWS IAM policy allowing the reading of s3 bucket"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.master-cloudtrail-bucket.bucket}*"
            ]
        }
    ]
}
POLICY
}

/**
 * Attaching the "read-s3-bucket-policy" to the glue crawler role
 */
resource "aws_iam_policy_attachment" "attach-read-s3-policy" {
  name       = "attach-read-s3-policy"
  roles      = ["${aws_iam_role.glue-crawler-read-logs-role.name}"]
  policy_arn = "${aws_iam_policy.read-s3-bucket-policy.arn}"
}

/**
 * Attaching the "AWSGlueServiceRole" to the glue crawler role
 */
resource "aws_iam_policy_attachment" "attach-glue-service-role" {
  name       = "attach-glue-service-role"
  roles      = ["${aws_iam_role.glue-crawler-read-logs-role.name}"]
  policy_arn = "${data.aws_iam_policy.AWSGlueServiceRole.arn}"
}
