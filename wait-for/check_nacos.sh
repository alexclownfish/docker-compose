#!/bin/bash

while :
    do
        # 访问nacos注册中心，获取http状态码
        CODE=`curl -I -m 10 -o /dev/null -s -w %{http_code}  http://172.62.0.15:8848/nacos/#/login`
        # 判断状态码为200
        if [[ $CODE -eq 200 ]]; then
            # 输出绿色文字，并跳出循环
            echo -e "\033[42;34m nacos-server is ok \033[0m"
            break
        else
            # 暂停1秒
            sleep 1
            echo -e "\033[41;37m nacos-server is not ok \033[0m"
        fi
    done

# while结束时，也就是nacos启动完成后，执行容器中的run.sh。
bash /root/run.sh
