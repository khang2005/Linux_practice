variable "environment" {
  description = "Deployment environment (dev/stage/prod)"
  type        = string
  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "Valid values: dev, stage, prod"
  }
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}
