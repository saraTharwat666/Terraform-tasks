The Nautilus DevOps team has been tasked to build a real-time data pipeline on AWS. The pipeline must collect streaming data, stage it in S3, monitor delivery failures, and alert via email. Your task is to implement this end-to-end using Terraform.

Pipeline Requirements:

1.) Kinesis Firehose:

Create a delivery stream named xfusion-firehose.
It should deliver data to an S3 bucket as a staging area.
2.) S3 Bucket:

Create a bucket named xfusion-staging-13276 (value to come from variables).
Set private ACL and allow Firehose to write objects into it.
3.) IAM Role and Policy:

Create a role xfusion-firehose-role and a policy xfusion-firehose-policy with least privilege to allow Firehose to write to the staging bucket.
4.) CloudWatch Alarm:

Create a cloudwatch Alarm named xfusion-firehose-failures.
Monitor the Firehose delivery failures metric (DeliveryToS3.Failures) and trigger when failures occur.
5.) SNS Topic:

Create a topic xfusion-alert-topic and link the CloudWatch alarm to it.
6.) SES Email Identity:

Create an SES email identity named xfusion@example.comand verify an SES email identity using an email address provided in the variables.
7.) SNS Subscription:

Subscribe the verified SES email identity to the SNS topic to receive notifications.
8.) Use main.tf file to define all AWS resources and to ensure a clean and modular setup.

9.) Use variables.tf file with the following variables:

KKE_STAGING_BUCKET_NAME: Name of the S3 bucket for staging data.
KKE_FIREHOSE_ROLE_NAME: Name of the IAM role for the Firehose delivery stream.
KKE_FIREHOSE_POLICY_NAME: Name of the IAM policy for the Firehose delivery stream.
KKE_FIREHOSE_NAME: Name of the Kinesis Firehose delivery stream.
KKE_SNS_TOPIC_NAME: Name of the SNS topic for alerts.
KKE_CLOUDWATCH_ALARM_NAME: Name of the CloudWatch alarm to monitor Firehose delivery failures.
KKE_ALERT_EMAIL: Email address to receive SNS alerts through SES.
10.) Use terraform.tfvarsto input the value of the variables used in the variables.tf.

11.) Use outputs.tf file to output the following:

kke_staging_bucket_name:name of the bucket used.
kke_firehose_name:name of the firehose delivery stream used.
kke_sns_topic_name:name of the sns topic used.
kke_cloudwatch_alarm_name:name of the cloudwatch used.
kke_ses_identity:name of the ses identity used.

Notes:

The Terraform working directory is /home/bob/terraform.

Right-click under the EXPLORER section in VS Code and select Open in Integrated Terminal to launch the terminal.

Before submitting the task, ensure that terraform plan returns `No changes. Your infrastructure matches the configuration
