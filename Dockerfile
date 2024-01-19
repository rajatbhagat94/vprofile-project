FROM tomcat:latest
COPY /target/vprofile-v2.war /usr/local/tomcat/webapps
WORKDIR /usr/local/tomcat/webapps
RUN chmod -R 700 /usr/local/tomcat/webapps
EXPOSE 8080
CMD ["catalina.sh" ,"run"]
