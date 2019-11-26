#!/usr/bin/env bash
git pull;
mvn clean package -U;
mv target/demo-*.jar /opt/application/demo.jar;
docker build -t "demo.jar";

# 删除容器
docker rm -f demo &> /dev/null;

version=`date "+%Y%m%d%H"`;

# 启动镜像
docker run -d --restart=on-failure:5 --privileged=true \
    --net=host \
    -w /home \
    -v $PWD/logs:/home/logs \
    --name demo chenglu/demo \
    java \
        -Djava.security.egd=file:/dev/./urandom \
        -Duser.timezone=Asia/Shanghai \
        -XX:+PrintGCDateStamps \
        -XX:+PrintGCTimeStamps \
        -XX:+PrintGCDetails \
        -XX:+HeapDumpOnOutOfMemoryError \
        -Xloggc:logs/gc_$version.log \
        -jar /opt/application/demo.jar \

sudo docker rmi $(docker images -f "dangling=true" -q)

docker logs -f demo