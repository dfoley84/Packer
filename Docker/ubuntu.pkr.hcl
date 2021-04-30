
source "docker" "example" {
    image = "ubuntu"
    commit = true
    changes = [
      "WORKDIR /app",
      "EXPOSE 5000",
      "ENTRYPOINT [\"sh\", \"entrypoint.sh\"]"

    ]
    
}

build {
    sources = ["source.docker.example"]


provisioner "file"{
  source = "."
  destination = "/app"
}

provisioner "shell" {
  script = "install.sh"

}

 provisioner "ansible-local" {
    playbook_file   = "msql.yaml"


  }

 provisioner "ansible-local" {
    playbook_file   = "pipmodules.yaml"

  }

post-processors { 
post-processor "docker-tag" {
    repository = " < REPO > "
    tag        = ["1.0"]
  }
post-processor "docker-push"{}

}

}
