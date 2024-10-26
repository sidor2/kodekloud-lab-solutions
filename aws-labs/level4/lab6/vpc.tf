# Retrieve the default VPC
data "aws_vpc" "default" {
  default = true
}

# Retrieve the default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}