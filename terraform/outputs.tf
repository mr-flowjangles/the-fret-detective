###############################################################################
# outputs.tf
#
# Information displayed after terraform apply.
# Also accessible via: terraform output <name>
###############################################################################

output "website_url" {
  description = "Primary website URL"
  value       = "https://${var.domain_name}"
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID (needed for cache invalidation)"
  value       = aws_cloudfront_distribution.website.id
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name (use this to test before DNS switch)"
  value       = aws_cloudfront_distribution.website.domain_name
}

output "s3_bucket_name" {
  description = "S3 bucket name for uploading files"
  value       = aws_s3_bucket.website.id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.website.arn
}

output "nameservers" {
  description = "Update your domain registrar to use these nameservers"
  value       = aws_route53_zone.main.name_servers
}

output "certificate_arn" {
  description = "ACM certificate ARN"
  value       = aws_acm_certificate.website.arn
}

# Helpful next steps
output "next_steps" {
  description = "What to do after terraform apply"
  value       = <<-EOT

    ============================================================
    DEPLOYMENT COMPLETE! Next steps:
    ============================================================

    1. UPDATE NAMESERVERS
       Go to your domain registrar (where you bought thefretdetective.com)
       and update the nameservers to:
       ${join("\n       ", aws_route53_zone.main.name_servers)}

    2. UPLOAD YOUR SITE
       aws s3 sync ./app s3://${aws_s3_bucket.website.id} --delete

    3. INVALIDATE CLOUDFRONT CACHE (after updates)
       aws cloudfront create-invalidation \
         --distribution-id ${aws_cloudfront_distribution.website.id} \
         --paths "/*"

    4. TEST YOUR SITE
       CloudFront URL (works immediately):
       https://${aws_cloudfront_distribution.website.domain_name}

       Custom domain (after DNS propagates, ~48hrs max):
       https://${var.domain_name}

    ============================================================
  EOT
}
