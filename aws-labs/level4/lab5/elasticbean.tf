# Create Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "kodek_app" {
  name        = "${var.project_name}-app"
  description = "Elastic Beanstalk application for kodek"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "default VPC"
  }
}

data "aws_subnets" "default_subs" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

# Create Elastic Beanstalk Application Environment
resource "aws_elastic_beanstalk_environment" "kodek_app_env" {
  name                = "${var.project_name}-app-env"
  application         = aws_elastic_beanstalk_application.kodek_app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.2.0 running Python 3.11"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_default_vpc.default.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", data.aws_subnets.default_subs.ids)
  }
  
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

    setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "API_KEY_SECRET_NAME"
    value     = aws_secretsmanager_secret_version.kodek_api_key_version.secret_string
  }
}

output "application_name" {
  value = aws_elastic_beanstalk_application.kodek_app.name
}

output "environment_name" {
  value = aws_elastic_beanstalk_environment.kodek_app_env.name
}
