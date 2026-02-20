###############################################################################
# providers.tf
# 
# Configures Terraform and the AWS provider.
# 
# WHY TWO PROVIDERS?
# - CloudFront requires ACM certificates to be in us-east-1
# - Your main resources can be in any region
# - We create an aliased provider specifically for the certificate
###############################################################################

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state storage - uncomment and configure after first run
  # backend "s3" {
  #   bucket = "thefretdetective-terraform-state"
  #   key    = "prod/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

# Primary AWS provider - used for most resources
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "thefretdetective"
      ManagedBy   = "terraform"
      Environment = var.environment
    }
  }
}

# Secondary provider for ACM certificate (must be us-east-1 for CloudFront)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = "thefretdetective"
      ManagedBy   = "terraform"
      Environment = var.environment
    }
  }
}
