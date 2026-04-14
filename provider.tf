provider "aws" {
  region = var.aws_region

  # To use AWS credentials, set AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, or use IAM role
  # For CI/CD, these will be set as env vars in Jenkins
}

