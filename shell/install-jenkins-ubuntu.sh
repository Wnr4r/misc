#!/bin/bash

sudo apt-get update -y

sudo apt-get install openjdk-11-jdk -y

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y

sudo apt-get install jenkins

sudo systemctl start jenkins.service

# sudo systemctl status jenkins

sudo ufw allow 8080

sudo ufw allow 22

sudo ufw enable

sudo cat /var/lib/jenkins/secrets/initialAdminPassword > pass.txt
