FROM openjdk:8
MAINTAINER cheng lu
COPY  target/demo-0.0.1.SNAPSHOT.jar  /chenglu/demo.jar
CMD java -jar demo.jar
