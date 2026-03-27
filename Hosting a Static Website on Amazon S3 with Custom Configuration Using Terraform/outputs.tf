output "website_url" {
  value = "http://aws:4566/${aws_s3_bucket.static_site.bucket}/${var.index_document}"
}
