#!/bin/sh

set -x
chmod 777 -R /var/www/html

# wordpress 미설치시..
if [ ! -d /var/www/html/wp-admin ]; then
	echo "There's no wordpress! Download Now...🚀"
	# wordpress cli 설치
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
	wp --allow-root core download --version=latest --path=/var/www/html # --locale=ko_KR

	# wordpress에서 필요한 database를 저장 (유저정보, 데이터데이스 이름) -> wp.config.php파일 생성
	wp --allow-root config create --force --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USR --dbpass=$MYSQL_PASSWORD --dbhost=$MYSQL_HOST --path=/var/www/html

	# wordpress에서 database를 찾을수 있으니깐 해당 데이터베이스에 저장할 wordpress root 유저 추가
	wp --allow-root core install --url=$DOMAIN_NAME --title=hello_admin --admin_user=$ADMIN_USER --admin_password=$ADMIN_PASSWORD --admin_email=$ADMIN_EMAIL --path=/var/www/html
	# 일반계정추가
	wp --allow-root user create $REG_USER $REG_EMAIL --user_pass=$REG_PASSWORD --path=/var/www/html

else
	echo "You already have wordpress in your Volume! ✅"
fi
chmod 777 -R /var/www/html

# php-fpm 설정파일
#mv /www.conf /etc/php7/php-fpm.d/www.conf

# php-fpm foreground
php-fpm7 -F
