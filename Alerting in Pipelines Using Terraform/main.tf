# 1. الـ S3 Staging Bucket
resource "aws_s3_bucket" "staging" {
  bucket = var.KKE_STAGING_BUCKET_NAME
}

# 2. الـ IAM Role للـ Firehose
resource "aws_iam_role" "firehose_role" {
  name = var.KKE_FIREHOSE_ROLE_NAME
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "firehose.amazonaws.com" }
    }]
  })
}

# 3. الـ IAM Policy للسماح بالكتابة في S3
resource "aws_iam_role_policy" "firehose_policy" {
  name = var.KKE_FIREHOSE_POLICY_NAME
  role = aws_iam_role.firehose_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["s3:AbortMultipartUpload", "s3:GetBucketLocation", "s3:GetObject", "s3:ListBucket", "s3:ListBucketMultipartUploads", "s3:PutObject"]
        Effect = "Allow"
        Resource = [aws_s3_bucket.staging.arn, "${aws_s3_bucket.staging.arn}/*"]
      }
    ]
  })
}

# 4. الـ Kinesis Firehose Delivery Stream
resource "aws_kinesis_firehose_delivery_stream" "xfusion_firehose" {
  name        = var.KKE_FIREHOSE_NAME
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.staging.arn
  }
}

# 5. الـ SNS Topic
resource "aws_sns_topic" "alert_topic" {
  name = var.KKE_SNS_TOPIC_NAME
}

# 6. الـ SES Email Identity
resource "aws_ses_email_identity" "alert_email" {
  email = var.KKE_ALERT_EMAIL
}

# 7. الـ SNS Subscription (ربط الإيميل بالـ SNS)
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.alert_topic.arn
  protocol  = "email"
  endpoint  = var.KKE_ALERT_EMAIL
}

# 8. الـ CloudWatch Alarm للفشل في التوصيل
resource "aws_cloudwatch_metric_alarm" "firehose_failures" {
  alarm_name          = var.KKE_CLOUDWATCH_ALARM_NAME
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DeliveryToS3.Failures"
  namespace           = "AWS/Firehose"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"
  alarm_actions       = [aws_sns_topic.alert_topic.arn]

  dimensions = {
    DeliveryStreamName = aws_kinesis_firehose_delivery_stream.xfusion_firehose.name
  }
}
