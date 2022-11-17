#!/bin/bash
sudo dnf update -y
sudo dnf install -y python3
subscription-manager repos --enable ansible-2.8-for-rhel-8-x86_64-rpms
sudo  dnf -y install ansible

