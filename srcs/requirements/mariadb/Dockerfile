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
#RUN /etc/init.d/mariadb setup

# MariaDB 서비스 시작하기
# 왜 그런지 모르겠는데,, 이걸 배쉬로 직접 입력해야 mariadb가 실행된다.
#RUN rc-service mariadb restart

#ENTRYPOINT [ "rc-service", "mariadb", "restart", ";" , "mariadb" ]
COPY gshim.sh /

RUN chmod +x /gshim.sh

RUN apk add tini -y

ENTRYPOINT [ "/sbin/tini", "---", "./gshim.sh"];

EXPOSE 3306/tcp

## Helpful Tutorial
# https://techviewleo.com/how-to-install-mariadb-on-alpine-linux/

# # starting openrc
# mkdir -p run/nginx

# # start services
# rc-service php-fpm7 start
# rc-service nginx start

# mysql 데몬을 기동한다.
