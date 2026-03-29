variable "KKE_AWS_REGION" {
  type    = string
  default = "us-east-1"
  validation {
    condition     = var.KKE_AWS_REGION == "us-east-1"
    error_message = "The allowed AWS region is only us-east-1."
  }
}

variable "KKE_QUEUE_DEPTH_THRESHOLD" {
  type    = number
  default = 50
  validation {
    condition     = var.KKE_QUEUE_DEPTH_THRESHOLD >= 1 && var.KKE_QUEUE_DEPTH_THRESHOLD <= 1000
    error_message = "The SNS queue depth threshold must be between 1 and 1000."
  }
}

variable "KKE_IAM_ACTIONS" {
  type    = list(string)
  default = ["sqs:ReceiveMessage", "dynamodb:PutItem", "sns:Publish"]
}
