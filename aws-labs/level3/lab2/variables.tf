variable "vpc_id" {
  description = "The ID of the VPC where the resources will be created" 
  type = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the resources will be created"
  type = list(string)
}

variable "ami_id" {
  description = "The ID of the AMI to use for the EC2 instance"
  type = string
}

variable "key_name" {
  description = "The name of the key pair to use for the EC2 instance"
  type = string
}


variable "proj_name" {  
  description = "The name of the project"
  type = string
}

variable "region" {
  description = "The region where the resources will be created"
  type = string
  default = "us-east-1"
}

variable "profile" {
  description = "The name of the AWS CLI profile to use"
  type = string
  default = "kodek"
}

