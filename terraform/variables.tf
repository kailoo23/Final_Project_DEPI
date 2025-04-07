variable "aws_region" {
  description = "AWS region to deploy the EC2 instance"
  type        = string
  default     = "us-east-1" # Replace with your preferred region
}

variable "ami_id" {
  description = "AMI ID for Ubuntu 20.04 LTS (varies by region)"
  type        = string
  default     = "ami-0e86e20dae9224db8" # us-east-1 Ubuntu 20.04 LTS AMI; replace with your region's AMI
}

variable "key_name" {
  description = "Name of the SSH key pair to access the instance"
  type        = string
  default     = "jpetstore-key" # Replace with your AWS key pair name
}