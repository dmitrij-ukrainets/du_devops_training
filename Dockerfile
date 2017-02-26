FROM tomcat:7-jre8
ARG task_version
RUN wget -P /usr/local/tomcat/webapps http://192.168.0.10:8080/repository/training/task4/$task_version/task4.war
EXPOSE 8080:8081