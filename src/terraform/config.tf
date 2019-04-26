provider "aws" {
  region  = "ap-southeast-2"
  profile = "AWS_CREDENTIALS_PROFILE"
}

terraform {
  backend "s3" {
    bucket         = "REMOTE_STATE_S3_BUCKET"
    key            = "REMOTE_STATE_S3_KEY"
    region         = "ap-southeast-2"
    encrypt        = true
    profile        = "AWS_CREDENTIALS_PROFILE"
    dynamodb_table = "REMOTE_STATE_LOCK_TABLE"
  }
}
