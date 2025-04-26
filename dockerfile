
FROM tomcat:9.0
WORKDIR /usr/local/tomcat/webapps
COPY --from=builder /app/target/jpetstore.war .
EXPOSE 8080
CMD ["catalina.sh", "run"]
