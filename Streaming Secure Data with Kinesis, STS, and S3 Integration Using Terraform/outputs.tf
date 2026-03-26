output "kke_caller_identity_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "kke_kinesis_stream_name" {
  value = aws_kinesis_stream.dev_stream.name
}

output "kke_s3_bucket_name" {
  value = aws_s3_bucket.dev_bucket.bucket
}
