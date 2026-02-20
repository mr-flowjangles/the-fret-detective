###############################################################################
# variables.tf
#
# All configurable inputs for the infrastructure.
# Override these in terraform.tfvars or via -var flags.
###############################################################################

variable "aws_region" {
  description = "AWS region for main resources (S3 bucket location)"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (prod, staging, dev)"
  type        = string
  default     = "prod"
}

variable "domain_name" {
  description = "Primary domain name for the website"
  type        = string
  default     = "thefretdetective.com"
}

variable "subject_alternative_names" {
  description = "Additional domain names for the SSL certificate"
  type        = list(string)
  default     = ["www.thefretdetective.com"]
}

variable "bucket_name" {
  description = "S3 bucket name for hosting static files (must be globally unique)"
  type        = string
  default     = "thefretdetective-website"
}

variable "price_class" {
  description = "CloudFront price class - controls which edge locations are used"
  type        = string
  default     = "PriceClass_100" # US, Canada, Europe only (cheapest)
  # Other options:
  # "PriceClass_200" - US, Canada, Europe, Asia, Middle East, Africa
  # "PriceClass_All" - All edge locations (most expensive)
}

variable "min_ttl" {
  description = "Minimum time (seconds) objects stay in CloudFront cache"
  type        = number
  default     = 0
}

variable "default_ttl" {
  description = "Default time (seconds) objects stay in CloudFront cache"
  type        = number
  default     = 86400 # 1 day
}

variable "max_ttl" {
  description = "Maximum time (seconds) objects stay in CloudFront cache"
  type        = number
  default     = 31536000 # 1 year
}
