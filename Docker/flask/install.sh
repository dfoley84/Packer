#!/bin/bash 

# Install Ansible repository.
export DEBIAN_FRONTEND=noninteractive
apt -y update && apt-get -y upgrade
apt -y install software-properties-common
apt-add-repository ppa:ansible/ansible

apt update
apt install ansible git python3.3 python3-dev gcc libpng-dev g++ build-essential libssl-dev libffi-dev curl wget -y
apt install python3-pip  libpython2.7-stdlib -y
