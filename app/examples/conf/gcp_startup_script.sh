#!/bin/bash

# install apache2
sudo apt install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2

# create default html
sudo rm -rf /var/www/html/*
echo '<html><body><h1>I am GCE!</h1></body></html>' | sudo tee /var/www/html/index.html
sudo mkdir /var/www/html/gce
echo '<html><body><h1>I am GCE!</h1></body></html>' | sudo tee /var/www/html/gce/index.html
