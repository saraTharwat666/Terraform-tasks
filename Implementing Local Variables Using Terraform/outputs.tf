output "kke_cloudwatch_alarm_name" { value = aws_cloudwatch_metric_alarm.alarm.alarm_name }
output "kke_dynamodb_table_name"  { value = aws_dynamodb_table.events.name }
output "kke_iam_role_arn"         { value = aws_iam_role.role.arn }
output "kke_sns_topic_arn"        { value = aws_sns_topic.topic.arn }
output "kke_sqs_queue_url"        { value = aws_sqs_queue.queue.url }
