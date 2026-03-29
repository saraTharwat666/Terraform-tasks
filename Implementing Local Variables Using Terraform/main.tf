locals {
  project_name = "xfusion"
  environment  = "dev"
  prefix       = "${local.project_name}-${local.environment}"
  
  common_tags = {
    Project     = local.project_name
    Environment = local.environment
    Owner       = "DevOpsTeam"
    Team        = "PlatformEngineering"
  }
}

# 1. SNS Topic
resource "aws_sns_topic" "topic" {
  name = "${local.prefix}-topic"
  tags = local.common_tags
}

# 2. SQS Queue
resource "aws_sqs_queue" "queue" {
  name = "${local.prefix}-queue"
  tags = local.common_tags
}

# 3. SNS Subscription (مع Depends_on)
resource "aws_sns_topic_subscription" "sub" {
  topic_arn  = aws_sns_topic.topic.arn
  protocol   = "sqs"
  endpoint   = aws_sqs_queue.queue.arn
  depends_on = [aws_sns_topic.topic]
}

# 4. DynamoDB Table
resource "aws_dynamodb_table" "events" {
  name           = "${local.prefix}-events"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "event_id"

  attribute {
    name = "event_id"
    type = "S"
  }
  tags = local.common_tags
}

# 5. IAM Role مع Dynamic Inline Policy
resource "aws_iam_role" "role" {
  name = "${local.prefix}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  dynamic "inline_policy" {
    for_each = [1] 
    content {
      name = "event_driven_policy"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Action   = var.KKE_IAM_ACTIONS
          Effect   = "Allow"
          Resource = "*"
        }]
      })
    }
  }
  tags = local.common_tags
}

# 6. CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_name          = "${local.prefix}-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.KKE_QUEUE_DEPTH_THRESHOLD
  
  dimensions = {
    QueueName = aws_sqs_queue.queue.name
  }
  tags = local.common_tags
}
