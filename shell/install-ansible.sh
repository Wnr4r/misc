#!/bin/bash

ops=$1

case $ops in
	"redhat") 
		sudo dnf update -y
		sudo dnf install -y python3
		subscription-manager repos --enable ansible-2.8-for-rhel-8-x86_64-rpms
		sudo  dnf -y install ansible
		;;
	"ubuntu") 
		sudo apt update
		sudo apt install software-properties-common
		sudo add-apt-repository --yes --update ppa:ansible/ansible
		sudo apt install ansible
		;;
	"centos")
		sudo yum install epel-release
		sudo yum install ansible
		;;
	"fedora")
		sudo dnf install ansible
		;;
	"debian")
		sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
		sudo apt update
		sudo apt install ansible
		;;
	*)
		echo "The OS:$ops specified isnt part of the list"
esac
