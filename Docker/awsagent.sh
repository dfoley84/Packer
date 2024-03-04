#!/bin/bash
if [ "$INSTALL_AWS_AGENT" == "yes" ]; then
    echo "Installing AWS Agent"
    yum install -y unzip
    yum clean all
    rm -rf /var/cache/yum
    curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'
    unzip awscliv2.zip
    ./aws/install
    rm -rf aws
    aws --version
else
    echo "AWS Agent installation is not required"
    exit 0
fi
