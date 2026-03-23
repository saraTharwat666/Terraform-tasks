resource "aws_s3_bucket" "stream_bucket" {
  bucket = var.KKE_S3_BUCKET_NAME
}


resource "aws_iam_role" "firehose_role" {
  name = var.KKE_FIREHOSE_ROLE_NAME

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "firehose.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "firehose_s3_policy" {
  name = "firehose-s3-access-policy"
  role = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["s3:PutObject", "s3:ListBucket", "s3:GetBucketLocation"]
      Effect   = "Allow"
      Resource = [
        aws_s3_bucket.stream_bucket.arn,
        "${aws_s3_bucket.stream_bucket.arn}/*"
      ]
    }]
  })
}

# 4. إنشاء الـ Firehose Delivery Stream
resource "aws_kinesis_firehose_delivery_stream" "nautilus_stream" {
  name        = var.KKE_FIREHOSE_STREAM_NAME
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.stream_bucket.arn
    

    buffering_configuration {
      size     = 5
      interval = 300
    }


    processing_configuration {
      enabled = true
      processors {
        type = "AppendDelimiterToRecord"
        parameters {
          parameter_name  = "Delimiter"
          parameter_value = "\\n" 
        }
      }
    }
  }

  depends_on = [aws_iam_role_policy.firehose_s3_policy]
}
