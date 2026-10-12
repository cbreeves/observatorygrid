variable "aws_profile" {
  description = "Local AWS shared configuration profile used by Terraform."
  type        = string
  default     = "ObservatoryGrid-AdminAccess"
}

variable "aws_region" {
  description = "AWS region for ObservatoryGrid resources."
  type        = string
  default     = "us-east-2"
}
