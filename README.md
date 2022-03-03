## 安装docker18.06.1-ce
### 1.添加docker-ce yum源
安装扩展yum功能，以便使用yum-config-manager添加docker软件源信息
```
yum install -y yum-utils
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```
### 2.查看当前可以安装docker-ce版本
安装指定版本的格式 ,注意3:xxx 请移除3:    我这里使用docker-ce-18.06.1.ce-3.el7
```
yum list docker-ce --showduplicates | sort -r
yum -y install docker-ce-[VERSION]   
yum install -y docker-ce-18.06.1.ce-3.el7 
```
### 3.启动测试
```
systemctl start docker && systemctl enable docker
docker info

Containers: 15
 Running: 12
 Paused: 0
 Stopped: 3
Images: 26
Server Version: 18.06.1-ce
Storage Driver: overlay2
 Backing Filesystem: xfs
 Supports d_type: true
 Native Overlay Diff: true
Logging Driver: json-file
Cgroup Driver: systemd
Plugins:
 Volume: local
 Network: bridge host macvlan null overlay
 Log: awslogs fluentd gcplogs gelf journald json-file logentries splunk syslog
Swarm: inactive
Runtimes: runc
Default Runtime: runc
Init Binary: docker-init
containerd version: 468a545b9edcd5932818eb9de8e72413e616e86e
runc version: 69663f0bd4b60df09991c08812a60108003fa340
init version: fec3683
Security Options:
 seccomp
  Profile: default
Kernel Version: 3.10.0-693.el7.x86_64
Operating System: CentOS Linux 7 (Core)
OSType: linux
Architecture: x86_64
CPUs: 2
Total Memory: 7.585GiB
Name: k8s-node3
ID: 5BLO:XOV2:EFX3:5SXB:M2JF:L6D7:TWGR:UQ6E:A56P:MXAZ:TTQR:R2DG
Docker Root Dir: /var/lib/docker
Debug Mode (client): false
Debug Mode (server): false
Registry: https://index.docker.io/v1/
Labels:
Experimental: false
Insecure Registries:
 127.0.0.0/8
Live Restore Enabled: false

WARNING: bridge-nf-call-iptables is disabled
WARNING: bridge-nf-call-ip6tables is disabled
```
## 安装docker-compose
### 1.下载docker-compose
```
curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
```
### 2.赋予docker-compose全局可执行权
```
chmod +x /usr/local/bin/docker-compose && ln -s /usr/local/bin/docker-compose /usr/bin/
docker-compose --version

docker-compose version 1.18.0, build 8dd22a9
```
## docker-compose java项目目录规划
### 1.环境描述
* docker：18.06.1-ce
* docker-comepose：1.18.0
* vue 2 && npm 14.17.3
* java1.8
### 2.文件目录解释
* config目录：config目录内放项目运行所需要挂载进容器的配置文件及数据文件
* import-base-image目录：docker save所保留下的tar归档基础镜像文件，例：java:8、mysql:8、nginx:1.21.3等，还有docker load镜像的脚本
* java目录：每个java项目在java目录内单独一个目录，目录内放置jar包、Dockerfile、build.sh（打包镜像所用脚本）
* docker-compose.yml ： 我所理解的docker-compose.yml跟k8s内的资源清单一样，就是docker-compose编排配置文件
* build_java_image.sh：进入到所有java项目目录内，把jar包打入docker镜像内
### 3.目录层级展示
![image](https://user-images.githubusercontent.com/63449830/149712209-71e562da-2aba-465a-836b-e6910d7d8030.png)
![image](https://user-images.githubusercontent.com/63449830/149712340-11cb5f19-0f67-46f5-b0b2-45ff1bb0745c.png)

## docker-compose常用命令
* docker-compose ps ：查看运行容器
* docker-compose up -d ：后台启动容器 && 资源清单有变化镜像有更新可以更新
* docker-compose down -v : 关闭，下线
* docker-compose up -d --build : 更新镜像

### docker网格优化
以上项目启动时会自动生成一个docker网络，因为我们docker-compose.yml内定义了网络的子网，所以单项目正常使用起来也没什么问题。如果有多个项目多个docker-compose.yml的场景下，多个项目之间也有微服务需要通过docker内部网络进行通信，或者我们docker-compose down -v时这个网卡都会随着我们项目的关闭而被释放掉。介于这种情况我们需要在外建立一个docker网格并指定网卡，再通过docker-compose.yml使用此网卡，即可实现多项目、多docker-compose.yml互相通过内部调用微服务、单独启动关闭某个项目；以下是配置摘要：
#### 创建docker网格
```
docker network create --driver bridge --subnet 172.62.0.0/16 --gateway 172.62.0.1 cq-data-security
```
#### 修改编排文件，多个docker-compose.yml配置方法一致
docker-compose.yml
```
version: '3'

networks:
  cq-data-security:
    external: true

services:
  mysql:
    image: mysql:8.0.20
    container_name: mysql
    networks:
      cq-data-security:
        ipv4_address: 172.62.0.5
```


