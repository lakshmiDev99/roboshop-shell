echo -e "\e[36m>>>>>>>>>>>>>>> create catalogue service <<<<<<<<<<<<<<\e[0m"
cp  catalogue.service /etc/systemd/system/catalogue.service
echo -e ">>>>>>>>>>>>>>> create Mongo DB Repo<<<<<<<<<<<<<<"
cp  mongo.repo /etc/yum.repos.d/mongo.repo
echo -e ">>>>>>>>>>>>>>> Install Nodejs Repos<<<<<<<<<<<<<<"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e ">>>>>>>>>>>>>>>  Install Nodejs <<<<<<<<<<<<<<\e[0m"
yum install nodejs -y
echo -e "\e[36m>>>>>>>>>>>>>>> create application user<<<<<<<<<<<<<<"

useradd roboshop
echo -e ">>>>>>>>>>>>>>> create application Directory<<<<<<<<<<<<<<"

mkdir /app
echo -e ">>>>>>>>>>>>>>> download apllication content <<<<<<<<<<<<<<"

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

