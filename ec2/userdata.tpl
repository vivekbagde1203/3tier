#!/bin/bash
yum -y install httpd
echo "this is coming from terraform" >> /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
