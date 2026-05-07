#!/bin/bash

yum update -y

yum install -y httpd

systemctl enable httpd
systemctl start httpd

echo "<h1>Project 18 Terraform EC2</h1>" > /var/www/html/index.html
