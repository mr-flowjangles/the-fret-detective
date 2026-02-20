###############################################################################
# s3.tf
#
# S3 bucket for hosting static website files.
#
# ARCHITECTURE:
# - Bucket is PRIVATE (not public website hosting)
# - CloudFront accesses it via Origin Access Control (OAC)
# - This is more secure than public bucket website hosting
###############################################################################

# The S3 bucket that holds your website files
resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name

  tags = {
    Name = "Fret Detective Website"
  }
}

# Block ALL public access - CloudFront will be the only way in
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning - allows rollback if you upload bad files
resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Server-side encryption - data encrypted at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bucket policy - allows CloudFront to read objects
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.website.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.website.arn
          }
        }
      }
    ]
  })

  # Must wait for public access block to be applied first
  depends_on = [aws_s3_bucket_public_access_block.website]
}
