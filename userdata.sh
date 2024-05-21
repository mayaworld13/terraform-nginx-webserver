#!/bin/bash
sudo apt-get update -y
sudo apt-get install nginx -y
sudo systemctl enable nginx --now
sudo echo "<h1> Hello Mayank </h1>" > /var/www/html/index.nginx-debian.html
sudo mv /tmp/flask.html /var/www/html/flask.html