FROM maven:3.8.4-openjdk-17-slim AS builder
WORKDIR /app
COPY . .
RUN mvn -N io.takari:maven:wrapper
RUN chmod +x ./mvnw
RUN ./mvnw clean package 
FROM tomcat:9.0
WORKDIR /usr/local/tomcat/webapps
COPY --from=builder /app/target/jpetstore.war .
EXPOSE 8080
CMD ["catalina.sh", "run"]
