echo -e "\e[31m>>>>>>>>>>>>>>> create catalogue service <<<<<<<<<<<<<<\e[0m"
cp  catalogue.service /etc/systemd/system/catalogue.service
echo -e "\e[32m>>>>>>>>>>>>>>> create Mongo DB Repo<<<<<<<<<<<<<<\e[0m"
cp  mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[33m>>>>>>>>>>>>>>> Install Nodejs Repos<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e ">>>>>>>>>>>>>>>  Install Nodejs <<<<<<<<<<<<<<\e[0m"
yum install nodejs -y
echo -e "\e[34m>>>>>>>>>>>>>>> create application user<<<<<<<<<<<<<<\e[0m"

useradd roboshop

echo -e "\e[31m>>>>>>>>>>>>>>> remove the old content<<<<<<<<<<<<<<\e[0m"
rm -rf /app

echo -e "\e[35m>>>>>>>>>>>>>>> create application Directory<<<<<<<<<<<<<<\e[0m"

mkdir /app
echo -e "\e[36m>>>>>>>>>>>>>>> download apllication content <<<<<<<<<<<<<<\e[0m"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
cd /app
npm install
yum install mongodb-org-shell -y
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

