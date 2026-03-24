#!/bin/bash

sudo apt_get update
sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

echo "<h1> simple shell script in terraform </h1>" | sudo tee /var/www/html/index.html