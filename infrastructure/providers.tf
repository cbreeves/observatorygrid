provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region

  default_tags {
    tags = {
      Project   = "ObservatoryGrid"
      ManagedBy = "Terraform"
    }
  }
}

# CloudFront requires its viewer certificate in us-east-1.
provider "aws" {
  alias   = "us_east_1"
  profile = var.aws_profile
  region  = "us-east-1"

  default_tags {
    tags = {
      Project   = "ObservatoryGrid"
      ManagedBy = "Terraform"
    }
  }
}
