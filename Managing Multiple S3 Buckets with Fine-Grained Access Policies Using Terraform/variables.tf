variable "KKE_ENV_TAGS" {
  type = map(object({
    bucket_name = string
    owner       = string
    backup      = bool
  }))
  default = {
    "Dev" = {
      bucket_name = "nautilus-dev-bucket-27566"
      owner       = "Alice"
      backup      = false
    }
    "Staging" = {
      bucket_name = "nautilus-staging-bucket-27566"
      owner       = "Bob"
      backup      = true
    }
    "Prod" = {
      bucket_name = "nautilus-prod-bucket-27566"
      owner       = "Carol"
      backup      = true
    }
  }
}
