packer {
  required_plugins {
    docker = {
      version = ">= 0.0.5"
      source  = "github.com/hashicorp/docker"
    }
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}


variable "apm_agent_version" {
  default = "1.30.1"
}
variable "aws_account" {}
variable "region" {}
variable "repository_name" {}
variable "tag" {}

variable "Install_AWS_Agent" {
  default = "no"
}

source "docker" "jdk8" {
  image  = "public.ecr.aws/docker/library/tomcat:9-jdk8-corretto"
  commit = true
}

build {
  sources = ["sources.docker.jdk8"]

  provisioner "shell" {
    inline = [
      "mkdir -p /app",
      "curl -L -o /app/agent.jar 'https://search.maven.org/remotecontent?filepath=co/elastic/apm/elastic-apm-agent/${var.apm_agent_version}/elastic-apm-agent-${var.apm_agent_version}.jar'",
    ]
  }

  provisioner "shell" {
      scripts = [
        "awsagent.sh",
        "harden.sh"
      ]
      environment_vars = [
        "Install_AWS_Agent=${var.Install_AWS_Agent}"
      ]
  }

  post-processors {
    post-processor "docker-tag"{
      repository = "${var.aws_account}.dkr.ecr.${var.region}.amazonaws.com/${var.repository_name}"
      tags = [var.tag]
    }
    post-processor "docker-push" {
      ecr_login = true
      login_server  = "${var.aws_account}.dkr.ecr.${var.region}.amazonaws.com/${var.repository_name}"
    }
  }

}
