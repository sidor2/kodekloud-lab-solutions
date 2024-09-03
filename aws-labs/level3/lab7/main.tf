resource "aws_elastic_beanstalk_application" "kodek_webapp" {
  name        = var.application_name
  description = "Elastic Beanstalk Application for ${var.application_name} Webapp"

  # appversion_lifecycle {
  #   service_role = var.service_role_arn
  #   max_count             = 128
  #   delete_source_from_s3 = false
  # }
}


resource "aws_elastic_beanstalk_application_version" "kodek_webapp_version" {
  name        = "${var.application_name}-${var.version_label}"
  application = aws_elastic_beanstalk_application.kodek_webapp.name
  bucket      = aws_s3_bucket.kodek_s3.id
  key         = aws_s3_object.app_zip.key
  description = "Version ${var.version_label} of ${var.application_name} Webapp"
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


resource "aws_elastic_beanstalk_configuration_template" "kodek_webapp_template" {
  name                = "${var.application_name}-template-config"
  application         =  var.application_name
  solution_stack_name = "64bit Amazon Linux 2023 v4.1.3 running Python 3.11"

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
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.small"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.instance_profile_name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = var.key_name
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PYTHONPATH"
    value     = "/var/app/venv/staging-LQM1lest/bin"
  }

  setting {
    namespace = "aws:elasticbeanstalk:container:python"
    name      = "NumProcesses"
    value     = "1"
  }

  setting {
    namespace = "aws:elasticbeanstalk:container:python"
    name      = "NumThreads"
    value     = "15"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:proxy"
    name      = "ProxyServer"
    value     = "nginx"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "AllAtOnce"
  }

  # setting {
  #   namespace = "aws:elasticbeanstalk:managedactions"
  #   name      = "ManagedActionsEnabled"
  #   value     = "true"
  # }

  # setting {
  #   namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
  #   name      = "UpdateLevel"
  #   value     = "minor"
  # }

  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "PreferredStartTime"
    value     = "MON:11:52"
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "EnhancedHealthAuthEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "DisableIMDSv1"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = "false"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "DeleteOnTerminate"
    value     = "false"
  }

  # setting {
  #   namespace = "aws:elasticbeanstalk:cloudwatch:logs"
  #   name      = "RetentionInDays"
  #   value     = "7"
  # }

  # setting {
  #   namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
  #   name      = "RetentionInDays"
  #   value     = "7"
  # }
  
  setting {
    namespace = "aws:elasticbeanstalk:monitoring"
    name      = "Automatically Terminate Unhealthy Instances"
    value     = "true"
  }
  
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Cooldown"
    value     = "360"
  }

  setting {
    name     = "InstancePort"
    namespace = "aws:cloudformation:template:parameter"
    value    = "80"
  }

  setting {
    name     = "DefaultSSHPort"
    namespace = "aws:elasticbeanstalk:control"
    value    = "22"
  }
}

resource "aws_elastic_beanstalk_environment" "kodek_webapp_env" {
  name                = "${var.application_name}-env"
  application         = aws_elastic_beanstalk_application.kodek_webapp.name
  version_label       = aws_elastic_beanstalk_application_version.kodek_webapp_version.name
  template_name       = aws_elastic_beanstalk_configuration_template.kodek_webapp_template.name
  

  depends_on = [ aws_s3_object.app_zip, aws_elastic_beanstalk_application_version.kodek_webapp_version, aws_elastic_beanstalk_configuration_template.kodek_webapp_template ]
}
