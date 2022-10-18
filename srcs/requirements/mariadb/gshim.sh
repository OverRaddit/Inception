#!/bin/sh

set -x
# mysql DB를 초기화 해준다.
/etc/init.d/mariadb setup


# MariaDB 서비스 시작하기
rc-service mariadb restart

exec mariadb
