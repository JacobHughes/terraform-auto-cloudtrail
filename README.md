# CloudTrail setup with Terraform

This project is a few simple terraform scripts to set up CloudTrail in an AWS account to monitor all activity, and some helper deployments to parse the logs that CloudTrail generates.

## Prerequisites

0. Clone this repo
1. Install Terraform locally - see https://learn.hashicorp.com/terraform/getting-started/install.html
2. Make sure your credentials for the account used by TerraForm is configured correctly in `~/.aws/credentials` - see https://www.terraform.io/docs/providers/aws/
    * Change the profile used by Terraform to be the name of your profile in `~/.aws/credentials`, on line 3 of `config.tf` 
3. In the file `config.tf`, configure Terraform to use remote state & state locking using AWS components - see https://www.terraform.io/docs/backends/types/s3.html
    * You'll need to manually set up your Terraform S3 remote state bucket and DynamoDB lock table, but the details are in the above linked documentation 
5. Change the S3 bucket names to something unique, lines 3 & 8 of storage.tf

## Getting Started

From the root folder, simply run `./scripts/deploy.sh` to plan and deploy the AWS components. This will add 2x S3 buckets for log storage, an AWS Glue crawler, and a saved AWS Athena query. Additionally it will create an IAM role for the crawler.

After executing the deploy script, the resources will be visible in the AWS Console. Browse to the Glue Console to run the crawler, which will generate the schema used by Athena in the example query, to investigate your logs. 

## Teardown

From the root folder, simply run `./.cicd/teardown.sh` to remove all the components created by this project.

## To do
* Make sure that the IAM policies are configured with the best practices for tight access control
* Configure the S3 bucket containing CloudTrail logs to be encrypted
* Allow the Glue crawler to decrypt the CloudTrail logs as it traverses the S3 bucket
* Include Terratest:
    * Come up with useful tests, using go and/or AWS sdk (in go)
    * Add tests to `test/cloudform_test.go`
