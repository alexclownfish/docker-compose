docker network create --driver bridge --subnet 172.62.0.0/16 --gateway 172.62.0.1 cq-data-security

IsNetworkOk=`docker network ls | grep cq-data-security | awk {'print $2'}`

sleep 2

if [ $IsNetworkOk == 'cq-data-security' ] 
then 
	echo -e "\e[35m  cq-data-security 网格创建完成，执行docker-compose up -d启动项目 \e[0m"
else
	echo -e "\e[31m  cq-data-security 网格创建失败 \e[0m"
fi
