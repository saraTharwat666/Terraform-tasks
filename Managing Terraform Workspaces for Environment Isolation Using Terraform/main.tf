# 1. إنشاء الـ API Gateway
resource "aws_api_gateway_rest_api" "kke_api" {
  count = length(var.KKE_API_NAMES)
  name  = "${terraform.workspace}-${var.KKE_API_NAMES[count.index]}"

  provisioner "local-exec" {
    command = "echo 'Created API Gateway ${self.name} in workspace ${terraform.workspace}' >> /home/bob/terraform/apigateway.log"
  }
}

# 2. إنشاء الـ CloudWatch Log Group
resource "aws_cloudwatch_log_group" "kke_log_group" {
  count = length(var.KKE_API_NAMES)
  name  = "/aws/apigateway/${terraform.workspace}-${var.KKE_API_NAMES[count.index]}"

  provisioner "local-exec" {
    command = "echo 'Created Log Group ${self.name} in workspace ${terraform.workspace}' >> /home/bob/terraform/loggroups.log"
  }
}
