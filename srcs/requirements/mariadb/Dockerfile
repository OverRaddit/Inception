# ===========================
# ╔╦╗╔═╗╦═╗╦╔═╗╔╦╗╔╗
# ║║║╠═╣╠╦╝║╠═╣ ║║╠╩╗
# ╩ ╩╩ ╩╩╚═╩╩ ╩═╩╝╚═╝
# ===========================

FROM alpine:3.14

# 필요한 패키지를 설치한다.
RUN apk update && apk upgrade
RUN apk add bash mariadb mariadb-client tini

#ENTRYPOINT [ "rc-service", "mariadb", "restart", ";" , "mariadb" ]
COPY /tools/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY /tools/mariadb_conf.sh /

RUN mkdir -p /var/run/mysqld /var/lib/mysql
RUN chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
RUN chmod +x /mariadb_conf.sh

ENTRYPOINT ["/sbin/tini", "--", "./mariadb_conf.sh"]

CMD ["/usr/bin/mysqld", "--user=mysql"]

EXPOSE 3306
