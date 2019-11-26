#!/usr/bin/env bash

img_mvn="maven:3.3.3-jdk-8"                 # docker image of maven
m2_cache=~/.m2                              # the local maven cache dir
proj_home=$PWD                              # the project root dir
img_output="chenglu/demo"         # output image tag

git pull  # should use git clone https://name:pwd@xxx.git

echo "使用docker的maven"
docker run --rm \
   -v $m2_cache:/root/.m2 \
   -v $proj_home:/opt/maven \
   -w /opt/maven $img_mvn mvn clean package -U

mv $proj_home/target/demo-*.jar $proj_home/target/demo.jar;
docker build -t "chenglu/demo" .;

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
        -jar /home/demo.jar \;
echo "删除没有名字的旧镜像";
docker rmi $(docker images -f "dangling=true" -q)
docker logs -f demo
