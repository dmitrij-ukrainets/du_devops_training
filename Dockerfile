FROM tomcat:7-jre8
ARG task_version
RUN wget -P /usr/local/tomcat/webapps http://${rnexus}/task4/${warvers}/task4.war
EXPOSE 8080