#!/bin/bash
sudo su
yum update -y
yum install -y httpd
cd /var/www/html
echo "<html><body>This is a test server!</body></html>" > index.html
service httpd start
chkconfig httpd on

sudo yum install git -y
git clone https://github.com/codetrash/rest-crud.git 
cd rest-crud                
sed -i "24s/.*/        host     : '${DBEndpoint}',/" server.js
sed -i "25s/.*/        user     : '${DBUsername}',/" server.js
sed -i "26s/.*/        password     : '${DBPassword}',/" server.js
sed -i "27s/.*/        database     : '${DBName}',/" server.js

yum install curl
curl --silent --location https://rpm.nodesource.com/setup_10.x | sudo bash -
sudo yum install -y nodejs
npm install
sudo npm install -g pm2
pm2 startup
pm2 start server.js
pm2 save

yum install mysql -y
mysql -h ${DBEndpoint} -P ${DBPort} -u ${DBUsername} -p${DBPassword} ${DBName} < t_user.sql