
source "docker" "jenkins" {
    image = "jenkins/jenkins:lts"
    commit = true
    changes = [
      "USER root",
      "EXPOSE 8080",
      "ENV JAVA_OPTS=\"-Djenkins.install.runSetupWizard=false\""
    ]
}

build {
    sources = ["source.docker.jenkins"]


provisioner "shell" {
  script = "installAnsible.sh"
}

provisioner "ansible-local" {
    playbook_file   = "pipmodules.yaml"
}

provisioner "file"{
  source = "plugins.txt"
  destination = "./plugins.txt"
}

provisioner "shell-local" {
  inline = [
      "/usr/local/bin/install-plugins.sh < /plugins.txt"
  ]
}

post-processors { 
post-processor "docker-tag" {
    repository = " < REPO > "
    tag        = ["2.1"]
  }
post-processor "docker-push"{}

}


}