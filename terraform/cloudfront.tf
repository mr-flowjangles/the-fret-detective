###############################################################################
# cloudfront.tf
#
# CloudFront CDN distribution.
#
# WHAT IT DOES:
# - Serves your site from edge locations worldwide (fast!)
# - Provides HTTPS with your custom domain
# - Caches content to reduce S3 requests (cheaper + faster)
# - Handles www → non-www redirect (or vice versa)
#
# ORIGIN ACCESS CONTROL (OAC):
# - Modern replacement for Origin Access Identity (OAI)
# - Allows CloudFront to access private S3 bucket
# - More secure than public S3 buckets
###############################################################################

# Origin Access Control - allows CloudFront to access private S3
resource "aws_cloudfront_origin_access_control" "website" {
  name                              = "${var.bucket_name}-oac"
  description                       = "OAC for ${var.domain_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# The CloudFront distribution
resource "aws_cloudfront_distribution" "website" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = var.price_class
  comment             = "Fret Detective Website"

  # Domain names this distribution responds to
  aliases = concat([var.domain_name], var.subject_alternative_names)

  # Where the files come from (S3 bucket)
  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id                = "S3-${var.bucket_name}"
    origin_access_control_id = aws_cloudfront_origin_access_control.website.id
  }

  # Default caching behavior
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.bucket_name}"
    viewer_protocol_policy = "redirect-to-https" # Force HTTPS
    compress               = true                 # Gzip/Brotli compression

    # Cache settings
    min_ttl     = var.min_ttl
    default_ttl = var.default_ttl
    max_ttl     = var.max_ttl

    # Forward only what's needed (better caching)
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # Custom error responses - serve index.html for 404s (good for SPAs)
  # Remove this block if you want real 404 pages
  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  # SSL certificate
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.website.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # No geographic restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Wait for certificate validation before creating distribution
  depends_on = [aws_acm_certificate_validation.website]

  tags = {
    Name = "Fret Detective CDN"
  }
}
