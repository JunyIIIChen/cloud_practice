resource "aws_s3_bucket" "acknowledgement" {
  bucket        = "${var.project_name}-${var.aws_region}-doctor-acknowledgement-bucket"
  force_destroy = true
  tags = {
    Name = "${var.project_name}-${var.aws_region}-doctor-acknowledgement-bucket"
  }
}

resource "aws_s3_bucket_versioning" "acknowledgement" {
  bucket = aws_s3_bucket.acknowledgement.id
  versioning_configuration {
    status = "Enabled"
  }
}