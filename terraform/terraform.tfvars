###############################################################################
# terraform.tfvars
#
# Your specific configuration values.
# This file should be in .gitignore if it contains sensitive data.
###############################################################################

aws_region  = "us-east-1"
environment = "prod"

domain_name               = "thefretdetective.com"
subject_alternative_names = ["www.thefretdetective.com"]

bucket_name = "thefretdetective-website"

# Price class options:
# "PriceClass_100" - US, Canada, Europe (cheapest)
# "PriceClass_200" - Above + Asia, Middle East, Africa
# "PriceClass_All" - All edge locations worldwide
price_class = "PriceClass_100"

# Cache TTLs (in seconds)
min_ttl     = 0
default_ttl = 86400   # 1 day
max_ttl     = 31536000 # 1 year
