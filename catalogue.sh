echo -e "\e[31m>>>>>>>>>>>>>>> create catalogue service <<<<<<<<<<<<<<\e[0m"
cp  catalogue.service /etc/systemd/system/catalogue.service >/tmp/robhoshop.log
echo -e "\e[32m>>>>>>>>>>>>>>> create Mongo DB Repo<<<<<<<<<<<<<<\e[0m"
cp  mongo.repo /etc/yum.repos.d/mongo.repo >/tmp/robhoshop.log
echo -e "\e[33m>>>>>>>>>>>>>>> Install Nodejs Repos<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash >/tmp/robhoshop.log
echo -e ">>>>>>>>>>>>>>>  Install Nodejs <<<<<<<<<<<<<<\e[0m"
yum install nodejs -y >/tmp/robhoshop.log >/tmp/robhoshop.log
echo -e "\e[34m>>>>>>>>>>>>>>> create application user<<<<<<<<<<<<<<\e[0m"

useradd roboshop >/tmp/robhoshop.log >/tmp/robhoshop.log

echo -e "\e[31m>>>>>>>>>>>>>>> remove the old content<<<<<<<<<<<<<<\e[0m"
rm -rf /app >/tmp/robhoshop.log >/tmp/robhoshop.log

echo -e "\e[35m>>>>>>>>>>>>>>> create application Directory<<<<<<<<<<<<<<\e[0m"

mkdir /app >/tmp/robhoshop.log >/tmp/robhoshop.log
echo -e "\e[36m>>>>>>>>>>>>>>> download apllication content <<<<<<<<<<<<<<\e[0m"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip >/tmp/robhoshop.log
cd /app >/tmp/robhoshop.log
unzip /tmp/catalogue.zip >/tmp/robhoshop.log
cd /app >/tmp/robhoshop.log
npm install >/tmp/robhoshop.log
yum install mongodb-org-shell -y >/tmp/robhoshop.log
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js >/tmp/robhoshop.log
systemctl daemon-reload >/tmp/robhoshop.log
systemctl enable catalogue >/tmp/robhoshop.log
systemctl restart catalogue >/tmp/robhoshop.log

