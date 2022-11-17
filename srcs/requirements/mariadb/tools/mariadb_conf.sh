#!/bin/sh

set -x

openrc
touch /run/openrc/softlevel

# mysql DB를 초기화 해준다.
/etc/init.d/mariadb setup

# MariaDB 서비스 시작하기
rc-service mariadb restart

# 필요한가?
rc-update add mariadb default

# wordpress에서 사용할 계정 & DB를 생성해야 한다...!
# mysql -e는 무슨 계정으로 실행하는거지?
# mysql -e "DELETE FROM user WHERE password=''";
mysql -e "CREATE DATABASE wordpress_db";
mysql -e "USE wordpress_db";
mysql -e "CREATE USER 'gshim'@'%' IDENTIFIED BY '1234'";
mysql -e "GRANT ALL ON *.* TO 'gshim'@'%'";
mysql -e "FLUSH PRIVILEGES";
mysql -e "Use mysql;SELECT host, user from user";

mysqld
bash # 보험용
