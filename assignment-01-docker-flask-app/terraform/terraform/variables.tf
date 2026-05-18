variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "c7i-flex.large"
}

variable "ami_id" {
  description = "Ubuntu AMI"
  default     = "ami-0f58b397bc5c1f2e8"
}

variable "key_name" {
  description = "AWS key pair name"
}
