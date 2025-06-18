variable "apm_version" {
  type    = string
}

variable "source_name" {
  type = string
}

variable "tomcat_images" {
  type = map(string)
  default = {
    tomcat9    = "public.ecr.aws/docker/library/tomcat:9-jdk8-corretto"
    corretto11 = "public.ecr.aws/amazoncorretto/amazoncorretto:11"
  }
}

variable "ecr_repo_url" {
  type = map(string)
  default = {
    tomcat9    = ".dkr.ecr.eu-west-1.amazonaws.com/"
    corretto11 = ".dkr.ecr.eu-west-1.amazonaws.com/"
  }
}

packer {
  required_plugins {
    docker = {
      version = ">=1.1.0"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "tomcat" {
  image  = var.tomcat_images[var.source_name]
  commit = true
}

build {
  name    = var.source_name
  sources = ["source.docker.tomcat"]

  provisioner "shell" {
    inline = [
      "yum update && yum install -y wget",
      "mkdir -p /app",
      var.source_name == "corretto11" ?
        "wget -O /app/agent.jar https://repo1.maven.org/maven2/co/elastic/apm/elastic-apm-agent/${var.apm_version}/elastic-apm-agent-${var.apm_version}.jar" :
        "wget -O /app/agent.jar https://search.maven.org/remotecontent?filepath=co/elastic/apm/elastic-apm-agent/${var.apm_version}/elastic-apm-agent-${var.apm_version}.jar"
    ]
  }

post-processors {
  post-processor "docker-tag" {
    repository = var.ecr_repo_url[var.source_name]
    tags       = [var.apm_version, "latest"]
    keep_input_artifact = true
  }

  post-processor "docker-push" {
    ecr_login     = true
    login_server  = var.ecr_repo_url[var.source_name]
  }
}
}
