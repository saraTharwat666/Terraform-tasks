
resource "aws_kms_key" "nautilus_key" {
  description             = "KMS key for encrypting sensitive data"
  deletion_window_in_days = 7
  

  tags = {
    Name = "nautilus-kms-key"
  }
}

resource "aws_kms_alias" "nautilus_key_alias" {
  name          = "alias/nautilus-kms-key"
  target_key_id = aws_kms_key.nautilus_key.key_id
}

resource "null_resource" "encrypt_file" {
  depends_on = [aws_kms_key.nautilus_key]

  provisioner "local-exec" {
    command = <<EOT
      aws kms encrypt \
        --key-id ${aws_kms_key.nautilus_key.key_id} \
        --plaintext fileb:///home/bob/terraform/SensitiveData.txt \
        --output text \
        --query CiphertextBlob > /home/bob/terraform/EncryptedData.bin
    EOT
  }
}


resource "null_resource" "decrypt_file" {
  depends_on = [null_resource.encrypt_file]

  provisioner "local-exec" {
    command = <<EOT
      aws kms decrypt \
        --ciphertext-blob fileb://<(base64 -d /home/bob/terraform/EncryptedData.bin) \
        --output text \
        --query Plaintext | base64 -d > /home/bob/terraform/DecryptedData.txt
    EOT
  }
}
