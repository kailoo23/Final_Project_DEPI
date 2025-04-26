
# Base image: Tomcat server
FROM tomcat:9.0

# Set working directory inside container
WORKDIR /usr/local/tomcat/webapps

# Copy the pre-built WAR file into Tomcat's webapps
COPY target/jpetstore.war ./jpetstore.war

# Expose port 8080 for Tomcat
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
