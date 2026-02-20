###############################################################################
# route53.tf
#
# DNS configuration for thefretdetective.com
#
# IMPORTANT: After running terraform apply, you'll need to update your
# domain registrar's nameservers to point to the Route 53 nameservers.
# The nameservers will be shown in the terraform output.
#
# If you already have Route 53 managing this domain, you can import
# the existing zone instead of creating a new one:
#   terraform import aws_route53_zone.main <zone-id>
###############################################################################

# Hosted zone for your domain
resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = {
    Name = "Fret Detective DNS Zone"
  }
}

# A record - points thefretdetective.com to CloudFront
resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

# A record - points www.thefretdetective.com to CloudFront
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

# AAAA record (IPv6) - points thefretdetective.com to CloudFront
resource "aws_route53_record" "root_ipv6" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

# AAAA record (IPv6) - points www.thefretdetective.com to CloudFront
resource "aws_route53_record" "www_ipv6" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.${var.domain_name}"
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}
