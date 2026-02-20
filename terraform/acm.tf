###############################################################################
# acm.tf
#
# AWS Certificate Manager (ACM) - SSL/TLS certificate for HTTPS.
#
# IMPORTANT: Certificate MUST be in us-east-1 for CloudFront.
# That's why we use the aws.us_east_1 provider here.
#
# VALIDATION:
# - Uses DNS validation (adds a CNAME record to Route 53)
# - Fully automated - no manual steps needed
# - Certificate auto-renews before expiration
###############################################################################

# Request the SSL certificate
resource "aws_acm_certificate" "website" {
  provider = aws.us_east_1 # MUST be us-east-1 for CloudFront

  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"

  tags = {
    Name = "Fret Detective SSL Certificate"
  }

  # Create new cert before destroying old one (zero downtime)
  lifecycle {
    create_before_destroy = true
  }
}

# Create DNS records for certificate validation
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.website.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.main.zone_id
}

# Wait for certificate to be validated
resource "aws_acm_certificate_validation" "website" {
  provider = aws.us_east_1

  certificate_arn         = aws_acm_certificate.website.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
