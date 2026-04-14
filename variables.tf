variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "dynatrace_tenant" {
  description = "Dynatrace tenant URL (e.g., https://abc123.live.dynatrace.com)"
  type        = string
}

variable "dynatrace_token" {
  description = "Dynatrace API token for OneAgent install"
  type        = string
  sensitive   = true
}

