provider "aws" {
    region = "us-west-2"
    version = "~> 0.1"
}


resource "aws_iam_instance_profile" "beanstalk_service" {
    name = "beanstalk-service-user"
    role = "${aws_iam_role.beanstalk_service.name}"
}

resource "aws_iam_instance_profile" "beanstalk_ec2" {
    name = "beanstalk-ec2-user"
    role = "${aws_iam_role.beanstalk_ec2.name}"
}

resource "aws_iam_role" "beanstalk_service" {
    name = "beanstalk-service-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticbeanstalk.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "elasticbeanstalk"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role" "beanstalk_ec2" {
    name = "beanstalk-ec2-role"
    assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "beanstalk_service" {
    name = "elastic-beanstalk-service"
    roles = ["${aws_iam_role.beanstalk_service.id}"]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

resource "aws_iam_policy_attachment" "beanstalk_service_health" {
    name = "elastic-beanstalk-service-health"
    roles = ["${aws_iam_role.beanstalk_service.id}"]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_policy_attachment" "beanstalk_ec2_worker" {
    name = "elastic-beanstalk-ec2-worker"
    roles = ["${aws_iam_role.beanstalk_ec2.id}"]
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_policy_attachment" "beanstalk_ec2_web" {
    name = "elastic-beanstalk-ec2-web"
    roles = ["${aws_iam_role.beanstalk_ec2.id}"]
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_policy_attachment" "beanstalk_ec2_container" {
    name = "elastic-beanstalk-ec2-container"
    roles = ["${aws_iam_role.beanstalk_ec2.id}"]
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}


resource "aws_elastic_beanstalk_application" "api" {
    name =  "${var.app_name}"
    description = "REST api"
}

resource "aws_s3_bucket" "releaseases_bucket" {
    bucket = "${var.app_name}-releases"
    versioning {
        enabled = true
    }

    tags {
        "name" = "${var.app_name}-releases"
        "service" = "${var.app_name}"
    }

}

resource "aws_s3_bucket_object" "default" {
    bucket = "${aws_s3_bucket.releaseases_bucket.id}"
    key    = "default-Dockerrun.aws.json"
    source = "../Dockerrun.aws.json"
}

//resource "aws_elastic_beanstalk_application" "default" {
//    name        = "${var.app_name}"
//    description = "beanstalk web testing"
//}

resource "aws_elastic_beanstalk_application_version" "default" {
    name        = "${var.app_name}-default"
    application = "${var.app_name}"
    description = "application version created by terraform"
    bucket      = "${aws_s3_bucket.releaseases_bucket.id}"
    key         = "${aws_s3_bucket_object.default.id}"
}


resource "aws_elastic_beanstalk_environment" "api" {
    name = "${var.app_name}"
    application = "${aws_elastic_beanstalk_application.api.name}"
    solution_stack_name = "64bit Amazon Linux 2017.03 v2.7.4 running Docker 17.03.2-ce"
    wait_for_ready_timeout = "10m"
  
    setting {
        namespace = "aws:ec2:vpc"
        name      = "VPCId"
        value     = "${var.vpc_id}"
    }
  
    setting {
        namespace = "aws:ec2:vpc"
        name      = "Subnets"
        value     = "${var.private_subnet_one}"
    }
  
    setting {
        namespace = "aws:ec2:vpc"
        name      = "ELBSubnets"
        value     = "${var.subnet_one}"
    } 
  
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "InstanceType"
        value     = "${var.instance_type}"
    } 
  
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "SSHSourceRestriction"
        value     = "tcp, 22, 22, 0.0.0.0/0"
    } 
  
    setting {
        namespace = "aws:autoscaling:asg"
        name      = "MaxSize"
        value     = "${var.loadbalancing_max_nodes}"
    } 
  
    setting {
        namespace = "aws:autoscaling:asg"
        name      = "MinSize"
        value     = "${var.loadbalancing_min_nodes}"
    } 
  
    setting {
        # Allows 600 seconds between each autoscaling action
        namespace = "aws:autoscaling:asg"
        name      = "Cooldown"
        value     = "600"
    } 
  
    setting {
        namespace = "aws:elasticbeanstalk:application"
        name      = "Application Healthcheck URL"
        value     = "${var.healthcheck_location}"
    }
  
    setting {
        # High threshold for taking down servers for debugging purposes
        namespace = "aws:elb:healthcheck"
        name      = "Interval"
        value     = "300"
    }
  
    setting {
        # High threshold for taking down servers for debugging purposes
        namespace = "aws:elb:healthcheck"
        name      = "UnhealthyThreshold"
        value     = "10"
    }
  
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "EC2KeyName"
        value     = "${var.ssh_key}"
    }
  
    setting {
        namespace = "aws:elb:loadbalancer"
        name      = "CrossZone"
        value     = "true"
    }
  
    setting {
        namespace = "aws:elb:listener:443"
        name      = "ListenerProtocol"
        value     = "HTTPS"
    }
  
    setting {
        namespace = "aws:elb:listener:443"
        name      = "InstancePort"
        value     = "80"
    }
  
    setting {
        namespace = "aws:elb:listener:443"
        name      = "SSLCertificateId"
        value     = "${var.certificate_arn}"
    }
  
    setting {
        namespace = "aws:elb:policies"
        name      = "ConnectionDrainingEnabled"
        value     = "true"
    }
  
    setting {
        namespace = "aws:elb:policies"
        name      = "ConnectionDrainingTimeout"
        value     = "20"
    }

    setting {
        namespace = "aws:elasticbeanstalk:environment"
        name      = "ServiceRole"
        value     = "${aws_iam_instance_profile.beanstalk_service.name}"
    }

    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "IamInstanceProfile"
        value     = "${aws_iam_instance_profile.beanstalk_ec2.name}"
    }

}

output "api_cname" {
    value = "${aws_elastic_beanstalk_environment.api.cname}" 
}