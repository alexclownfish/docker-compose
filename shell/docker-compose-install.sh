#!/bin/bash
echo -e "\e[35m 输入1自定义安装，2默认docker-ce-18.06.1.ce-3.el7安装 \e[0m"
read -p " 请输入1,2: " select_docker_version
if [ $select_docker_version == 1 ]; then
        read -p "docker_version版本:" docker_version
        yum install -y yum-utils && \
        yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo && \
        yum -y install $docker_version && \
        systemctl start docker && \
        systemctl enable docker > /dev/null
        if [ $? -eq 0 ]; then
                echo -e "\e[35m $docker_version 安装完成，启动完成并开启开机自启 \e[0m"
        else
                echo -e "\e[31m $docker_version 安装失败 \e[0m"
	fi
        echo "安装docker-compose version 1.18.0"
        curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
        chmod +x /usr/local/bin/docker-compose && \
        ln -s /usr/local/bin/docker-compose /usr/bin/ > /dev/null
        if [ $? -eq 0 ]; then
                echo -e "\e[35m docker-compose version 1.18.0 安装完成，已内置系统命令 \e[0m"
        else
                echo -e "\e[31m docker-compose version 1.18.0安装失败 \e[0m"
	fi
elif [ $select_docker_version == 2 ]; then
        yum install -y yum-utils && \
        yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo && \
        yum -y install docker-ce-18.06.1.ce-3.el7 && \
        systemctl start docker && \
        systemctl enable docker > /dev/null
        if [ $? -eq 0 ]; then
                echo -e "\e[35m docker-ce-18.06.1.ce-3.el7 安装完成，启动完成并开启开机自启 \e[0m"
        else
                echo -e "\e[31m docker-ce-18.06.1.ce-3.el7 安装失败 \e[0m"
	fi
        echo "安装docker-compose version 1.18.0"
        curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
        chmod +x /usr/local/bin/docker-compose && \
        ln -s /usr/local/bin/docker-compose /usr/bin/ > /dev/null
        if [ $? -eq 0 ]; then
                echo -e "\e[35m docker-compose version 1.18.0 安装完成，已内置系统命令 \e[0m"
        else
                echo -e "\e[31m docker-compose version 1.18.0安装失败 \e[0m"
	fi
else 
	echo -e "输入1,2"
fi
