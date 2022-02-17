docker network create --driver bridge --subnet 172.62.0.0/16 --gateway 172.62.0.1 cq-data-security
docker network ls | grep cq-data-security
echo -e "\e[35m docker-compose version 1.18.0 cq-data-security 网格创建完成，执行docker-compose up -d \e[0m"
