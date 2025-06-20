variable "aws_region" {
  description = "AWS region to deploy"
  type        = string
  default     = "eu-north-1"
}

variable "key_name" {
  description = "Name of the AWS key pair"
  type        = string
  default     = "solar_sys_pair"
}

variable "public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "/home/eldi.kacori/.ssh/id_web_aws_rsa.pub"
}

variable "ami_id" {
  description = "AMI ID to use for EC2"
  type        = string
  # Amazon Linux 2 AMI in eu-north-1 
  default     = "ami-05fcfb9614772f051"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "instance_name" {
  description = "Name tag for EC2 instance"
  type        = string
  default     = "terraform-solsys-web"
}

