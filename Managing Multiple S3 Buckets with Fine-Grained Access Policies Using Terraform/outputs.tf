output "kke_bucket_names" {
  value = [for b in aws_s3_bucket.nautilus_buckets : b.bucket]
}
