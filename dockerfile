FROM tomcat:9.0-jdk11-openjdk-slim AS builder
WORKDIR /app
COPY . .
RUN chmod +x ./mvnw
RUN ./mvnw clean package -DskipTests
FROM tomcat:9.0-jdk11-openjdk-slim
WORKDIR /usr/local/tomcat/webapps
COPY --from=builder /app/target/jpetstore.war .
EXPOSE 8080
CMD ["catalina.sh", "run"]