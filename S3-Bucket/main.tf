# CREATING S3 BUCKET-------------------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "my_bucket" {
  bucket = "three-tier-s3-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}