variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-0dee22c13ea7a9a67"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "instance_name" {
  description = "Name tag for EC2"
  type        = string
  default     = "terraform-ec2"
}