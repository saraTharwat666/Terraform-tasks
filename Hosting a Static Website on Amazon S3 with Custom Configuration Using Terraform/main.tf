
resource "aws_s3_bucket" "static_site" {
  bucket = var.bucket_name

  tags = {
    Project = "StaticWeb"
  }
}


resource "aws_s3_bucket_website_configuration" "config" {
  bucket = aws_s3_bucket.static_site.id

  index_document {
    suffix = var.index_document
  }
}


resource "aws_s3_bucket_public_access_block" "access" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.static_site.id
  depends_on = [aws_s3_bucket_public_access_block.access]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_site.arn}/*"
      }
    ]
  })
}
