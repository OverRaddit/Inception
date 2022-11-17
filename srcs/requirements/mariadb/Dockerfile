# ===========================
# ╔╦╗╔═╗╦═╗╦╔═╗╔╦╗╔╗
# ║║║╠═╣╠╦╝║╠═╣ ║║╠╩╗
# ╩ ╩╩ ╩╩╚═╩╩ ╩═╩╝╚═╝
# ===========================

FROM alpine:3.14

# 필요한 패키지를 설치한다.
RUN apk update && apk upgrade
RUN apk add openrc bash mariadb mariadb-common mariadb-client tini

#ENTRYPOINT [ "rc-service", "mariadb", "restart", ";" , "mariadb" ]
COPY /tools/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY /tools/mariadb_conf.sh /

RUN chmod +x /mariadb_conf.sh

ENTRYPOINT ["/sbin/tini", "--", "./mariadb_conf.sh"];

EXPOSE 3306
#VOLUME [ “/sys/fs/cgroup” ]
## Helpful Tutorial
# https://techviewleo.com/how-to-install-mariadb-on-alpine-linux/

# # starting openrc
# mkdir -p run/nginx

# # start services
# rc-service php-fpm7 start
# rc-service nginx start

# mysql 데몬을 기동한다.
