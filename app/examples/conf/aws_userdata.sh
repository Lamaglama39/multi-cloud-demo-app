#!/bin/bash

# ssm install
sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

# install httpd
sudo dnf install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd

# create default html
sudo rm -rf /var/www/html/*
echo '<html><body><h1>I am EC2!</h1></body></html>' | sudo tee /var/www/html/index.html
sudo mkdir /var/www/html/ec2
echo '<html><body><h1>I am EC2!</h1></body></html>' | sudo tee /var/www/html/ec2/index.html
