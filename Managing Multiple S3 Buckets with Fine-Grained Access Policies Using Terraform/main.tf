resource "aws_s3_bucket" "nautilus_buckets" {
  for_each = var.KKE_ENV_TAGS
  bucket   = each.value.bucket_name

  tags = {
    Name        = each.value.bucket_name
    Environment = each.key
    Owner       = each.value.owner
    Backup      = each.value.backup ? "true" : null
  }

  lifecycle {
    ignore_changes = [tags]
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "glacier_transition" {
  for_each = { for k, v in var.KKE_ENV_TAGS : k => v if v.backup }
  bucket   = aws_s3_bucket.nautilus_buckets[each.key].id

  rule {
    id     = "MoveToGlacier"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "GLACIER"
    }
  }
}


resource "aws_s3_bucket_policy" "public_read" {
  for_each = aws_s3_bucket.nautilus_buckets
  bucket   = each.value.id
  

  depends_on = [aws_s3_bucket.nautilus_buckets]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${each.value.arn}/*"
      },
    ]
  })
}
