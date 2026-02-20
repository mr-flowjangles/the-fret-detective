# Terraform - The Fret Detective Infrastructure

This Terraform configuration deploys a static website to AWS.

## Architecture

```
thefretdetective.com
        │
        ▼
   Route 53 (DNS)
        │
        ▼
   CloudFront (CDN + HTTPS)
        │
        ▼
   S3 Bucket (Static Files)
```

## Prerequisites

1. [Terraform](https://www.terraform.io/downloads) >= 1.0.0
2. [AWS CLI](https://aws.amazon.com/cli/) configured with credentials
3. Domain ownership of `thefretdetective.com`

## Quick Start

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Deploy infrastructure
terraform apply

# Upload website files
aws s3 sync ../app s3://thefretdetective-website --delete

# Invalidate CloudFront cache
aws cloudfront create-invalidation \
  --distribution-id $(terraform output -raw cloudfront_distribution_id) \
  --paths "/*"
```

## Post-Deployment

After running `terraform apply`, you must update your domain registrar's nameservers to the ones shown in the output. DNS propagation can take up to 48 hours.

## Files

| File | Purpose |
|------|---------|
| `providers.tf` | AWS provider configuration |
| `variables.tf` | Input variable definitions |
| `terraform.tfvars` | Your specific values |
| `s3.tf` | S3 bucket for static hosting |
| `cloudfront.tf` | CDN distribution |
| `acm.tf` | SSL/TLS certificate |
| `route53.tf` | DNS configuration |
| `outputs.tf` | Output values |

## Common Commands

```bash
# View outputs
terraform output

# Get specific output
terraform output cloudfront_distribution_id

# Destroy everything (careful!)
terraform destroy

# Format code
terraform fmt

# Validate configuration
terraform validate
```

## Costs (Approximate)

- **Route 53**: $0.50/month per hosted zone
- **S3**: ~$0.023/GB storage + $0.0004/request
- **CloudFront**: ~$0.085/GB transfer out (first 10TB)
- **ACM**: Free

**Estimated monthly cost for a small site: ~$1-5/month**

## Troubleshooting

### Certificate stuck in "Pending validation"
- Ensure nameservers are updated at your registrar
- Check Route 53 for the CNAME validation records
- Wait up to 48 hours for DNS propagation

### 403 Forbidden errors
- Check S3 bucket policy allows CloudFront
- Ensure files are uploaded to S3
- Verify `default_root_object` is set correctly

### Changes not appearing
- Invalidate CloudFront cache after S3 updates
- Check browser cache (try incognito mode)
