#!/usr/bin/env bash

img_mvn="maven:3.3.3-jdk-8";                 # docker image of maven
m2_cache=~/.m2;                              # the local maven cache dir
proj_home=$PWD;                              # the project root dir
img_output="chenglu/demo";         # output image tag
img_name = "demo";

git pull  # should use git clone https://name:pwd@xxx.git

echo "using docker maven to build the project";
docker run --rm \
   -v $m2_cache:/root/.m2 \
   -v $proj_home:/opt/maven \
   -w /opt/maven $img_mvn mvn clean package -U;

mv $proj_home/target/demo-*.jar $proj_home/target/demo.jar;
docker build -t $img_output .;

# 删除容器
docker rm -f $img_name &> /dev/null;

version=`date "+%Y%m%d%H"`;

# 启动镜像
docker run -d --restart=on-failure:5 --privileged=true \
    --net=host \
    -w /home \
    -v $PWD/logs:/home/logs \
    --name $img_name $img_output \
    java \
        -Djava.security.egd=file:/dev/./urandom \
        -Duser.timezone=Asia/Shanghai \
        -XX:+PrintGCDateStamps \
        -XX:+PrintGCTimeStamps \
        -XX:+PrintGCDetails \
        -XX:+HeapDumpOnOutOfMemoryError \
        -Xloggc:logs/gc_$version.log \
        -jar /home/demo.jar \;
echo "delete the unused images";
docker rmi $(docker images -f "dangling=true" -q)
docker logs -f $img_name
