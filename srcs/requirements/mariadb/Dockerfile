# ===========================
# ╔╦╗╔═╗╦═╗╦╔═╗╔╦╗╔╗
# ║║║╠═╣╠╦╝║╠═╣ ║║╠╩╗
# ╩ ╩╩ ╩╩╚═╩╩ ╩═╩╝╚═╝
# ===========================

FROM alpine:3.14

# 필요한 패키지를 설치한다.
RUN apk update
RUN apk upgrade
RUN apk add openrc
RUN apk add bash
RUN apk add mariadb mariadb-common mariadb-client

# db 데이터를 담을 volume 선언
# 매번 새로 생성하는건가?
VOLUME /tools

# mysql DB를 초기화 해준다.
#CMD ["/etc/init.d/mariadb", "setup;"]

# MariaDB 서비스 시작하기
#CMD ["rc-service", "mariadb", "start;"]

EXPOSE 3306/tcp

## Helpful Tutorial
# https://techviewleo.com/how-to-install-mariadb-on-alpine-linux/

# # starting openrc
# mkdir -p run/nginx
# openrc default
# openrc boot
# # start services
# rc-service php-fpm7 start
# rc-service nginx start