#!/bin/bash

sudo apt update
sudo apt install mysql-server -y

mysql -u root <<-EOF
CREATE DATABASE dtapi;
GRANT ALL ON dtapi.* TO 'dtapi'@'%' IDENTIFIED BY 'dtapi' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

sudo sed -i.bak '/bind-address/ s/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

wget https://dtapi.if.ua/~yurkovskiy/dtapi_full.sql
wget https://dtapi.if.ua/~yurkovskiy/IF-108/sessions.sql
mysql -u root dtapi < ./dtapi_full.sql
mysql -u root dtapi < ./sessions.sql
sudo systemctl restart mysql


