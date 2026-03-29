output "kke_staging_bucket_name" { value = aws_s3_bucket.staging.bucket }
output "kke_firehose_name" { value = aws_kinesis_firehose_delivery_stream.xfusion_firehose.name }
output "kke_sns_topic_name" { value = aws_sns_topic.alert_topic.name }
output "kke_cloudwatch_alarm_name" { value = aws_cloudwatch_metric_alarm.firehose_failures.alarm_name }
output "kke_ses_identity" { value = aws_ses_email_identity.alert_email.email }
