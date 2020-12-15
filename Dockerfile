FROM tomcat:9.0
RUN apt update
RUN WORKDIR /home/boxfuse-sample-java-springboot-hello
ADD /home/gendalf/boxfuse-sample-java-springboot-hello/ .
RUN apt install maven -y
RUN mvn package
RUN cp ./target/*.war /var/lib/tomcat9/webapps/"]
EXPOSE 8080
CMD ["catalina.sh", "run"]