#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo apt-get install -y php
sudo apt-get
sudo systemctl start apache2
sudo systemctl enable apache2
echo "<h1>Deployed via Mati</h1>" | sudo tee /var/www/html/index.html
sudo apt  install awscli -y
mkdir ~/.aws
