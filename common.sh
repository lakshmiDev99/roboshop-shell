#variable declaration/
 log=/tmp/roboshop.log
func_apprereq()
{
  echo -e "\e[31m>>>>>>>>>>>>>>> create $component service <<<<<<<<<<<<<<\e[0m"
    cp $component.service /etc/systemd/system/$component.service &>>${log}
   echo -e "\e[34m>>>>>>>>>>>>>>> create application user<<<<<<<<<<<<<<\e[0m"

   useradd roboshop  &>>${log}

   echo -e "\e[31m>>>>>>>>>>>>>>> remove the old content<<<<<<<<<<<<<<\e[0m"
   rm -rf /app  &>>${log}

   echo -e "\e[35m>>>>>>>>>>>>>>> create application Directory<<<<<<<<<<<<<<\e[0m"

   mkdir /app  &>>${log}
   echo -e "\e[36m>>>>>>>>>>>>>>> download apllication content <<<<<<<<<<<<<<\e[0m"

   curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>${log}
    echo -e "\e[36m>>>>>>>>>>>>>>> extract apllication content <<<<<<<<<<<<<<\e[0m"
   cd /app ${log}
   unzip /tmp/$component.zip &>>${log}
   cd /app &>>${log}
}
func_nodejs()
{
   echo -e "\e[32m>>>>>>>>>>>>>>> create Mongo DB Repo<<<<<<<<<<<<<<\e[0m"
 cp  mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
 echo -e "\e[33m>>>>>>>>>>>>>>> Install Nodejs Repos<<<<<<<<<<<<<<\e[0m"
 curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
 echo -e ">>>>>>>>>>>>>>>  Install Nodejs <<<<<<<<<<<<<<\e[0m" | tee -a log
 yum install nodejs -y  &>>${log}

 func_apprereq

   echo -e "\e[36m>>>>>>>>>>>>>>> install dependencies <<<<<<<<<<<<<<\e[0m"

 npm install &>>${log}
 yum install mongodb-org-shell -y &>>${log}
 mongo --host MONGODB-SERVER-IPADDRESS </app/schema/user.js &>>${log}
func_systemd
}

func_systemd()
{
  echo -e "\e[31m>>>>>>>>>>>>>>> start $component service <<<<<<<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  systemctl enable $component &>>${log}
  systemctl restart $component &>>${log}
  }

func_java()
{

  echo -e "\e[31m>>>>>>>>>>>>>>> install maven <<<<<<<<<<<<<<\e[0m"
  yum install maven  &>>${log}

   func_apprereq

  echo -e "\e[31m>>>>>>>>>>>>>>> Build $component service <<<<<<<<<<<<<<\e[0m"
  mvn clean package &>>${log}
  mv target/$component-1.0.jar shipping.jar &>>${log}
    echo -e "\e[31m>>>>>>>>>>>>>>> Install Mysql service <<<<<<<<<<<<<<\e[0m"
  yum install mysql -y &>>${log}
      echo -e "\e[31m>>>>>>>>>>>>>>> load schema <<<<<<<<<<<<<<\e[0m"
  mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/$component.sql &>>${log}
func_systemd
}
func_python()
{
    echo -e "\e[31m>>>>>>>>>>>>>>> Build $component service <<<<<<<<<<<<<<\e[0m"
  yum install python36 gcc python3-devel -y
  useradd roboshop

  func_apprereq
    echo -e "\e[31m>>>>>>>>>>>>>>> Build $component service <<<<<<<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt

  func_systemd

}