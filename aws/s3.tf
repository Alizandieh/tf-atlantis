# Create an S3 bucket for storing Terraform state files
resource "aws_s3_bucket" "terraform_state" {
  bucket = "ali-free-tier-test-bucket" 

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "Test Bucket"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}