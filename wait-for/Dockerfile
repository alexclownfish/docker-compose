FROM java:8
COPY ./core4ct-gateway-1.0-SNAPSHOT.jar /root
COPY ./check_nacos.sh /root
COPY ./run.sh /root 
EXPOSE 9000
ENTRYPOINT ["bash","/root/check_nacos.sh"]
