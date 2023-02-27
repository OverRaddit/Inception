#!/bin/sh

set -x

if [ ! -d /var/lib/mysql/$MYSQL_DATABASE ]; then
	# install database
	# why this cmd? what is these options?
	# --user=mysql : Run mysqld daemon as user.
	# mysql이라는 유저명을 만든적이 없는데...?
	# --datadir= : Directory where the data is stored.
	mysql_install_db --user=mysql --datadir=/var/lib/mysql

	# why do this?
	# this change [/run/mysqld]
	#chown -R mysql:mysql /var/lib/mysql /run/mysqld
#RUN chown -R mariadb:mariadb /var/lib/mysql /var/run/mysqld
	# Secure Installation...?
	mysqld --user=mysql --datadir=/var/lib/mysql --bootstrap << EOF
-- Reload Privilege Tables
FLUSH PRIVILEGES;
-- Set root Password
SET PASSWORD FOR 'root'@localhost = PASSWORD('$MYSQL_ROOT_PASSWORD');
-- Remove anonymous Users
DELETE FROM mysql.user WHERE User='';
-- Remove Remote root
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
-- Remove test Database
DROP DATABASE IF EXISTS test;
-- Insert User Database
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
-- Insert New User
GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
-- Reload Privilege Tables
FLUSH PRIVILEGES;
EOF
# 	Use mysql;
# 	FLUSH PRIVILEGES;
# 	SET PASSWORD FOR 'root'@localhost = PASSWORD('$MYSQL_ROOT_PASSWORD');

# 	-- rm anonymous user
# 	DELETE FROM mysql.user WHERE User='';

# 	-- Remove Remote root ???????
# 	DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

# 	CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
# 	USE $MYSQL_DATABASE;
# 	CREATE USER '$MYSQL_USR'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
# 	GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USR'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
# 	GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USR'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';
# 	FLUSH PRIVILEGES;
# EOF
	# # -- set root pw
	# mysql -e "DELETE FROM mysql.user WHERE User=''";
	# mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')";
	# mysql -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE";
	# mysql -e "USE $MYSQL_DATABASE";
	# mysql -e "CREATE USER '$MYSQL_USR'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'";
	# mysql -e "GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USR'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'";
	# mysql -e "GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USR'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD'";
	# mysql -e "FLUSH PRIVILEGES";
	# mysql -e "SET PASSWORD FOR 'root'@localhost = PASSWORD('$MYSQL_ROOT_PASSWORD')";
else
	echo "You already got your DB!";
fi

mysqld --user=mysql
