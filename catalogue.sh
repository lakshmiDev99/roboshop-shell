log=/tmp/roboshop.log
echo -e "\e[31m>>>>>>>>>>>>>>> create catalogue service <<<<<<<<<<<<<<\e[0m"
cp  catalogue.service /etc/systemd/system/catalogue.service &${log}
echo -e "\e[32m>>>>>>>>>>>>>>> create Mongo DB Repo<<<<<<<<<<<<<<\e[0m" | tee -a log
cp  mongo.repo /etc/yum.repos.d/mongo.repo &${log}
echo -e "\e[33m>>>>>>>>>>>>>>> Install Nodejs Repos<<<<<<<<<<<<<<\e[0m" | tee -a log
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &${log}
echo -e ">>>>>>>>>>>>>>>  Install Nodejs <<<<<<<<<<<<<<\e[0m" | tee -a log
yum install nodejs -y  &${log}
echo -e "\e[34m>>>>>>>>>>>>>>> create application user<<<<<<<<<<<<<<\e[0m" | tee -a log

useradd roboshop  &${log}

echo -e "\e[31m>>>>>>>>>>>>>>> remove the old content<<<<<<<<<<<<<<\e[0m" | tee -a log
rm -rf /app  &${log}

echo -e "\e[35m>>>>>>>>>>>>>>> create application Directory<<<<<<<<<<<<<<\e[0m" | tee -a log

mkdir /app  &${log}
echo -e "\e[36m>>>>>>>>>>>>>>> download apllication content <<<<<<<<<<<<<<\e[0m" | tee -a log

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &${log}
cd /app ${log}
unzip /tmp/catalogue.zip &${log}
cd /app &${log}
npm install &${log}
yum install mongodb-org-shell -y &${log}
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js &${log}
systemctl daemon-reload &${log}
systemctl enable catalogue &${log}
systemctl restart catalogue &${log}

