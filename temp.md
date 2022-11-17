 | nginx: [emerg] invalid parameter "server_name" in /etc/nginx/http.d/default.conf:13

ㅇㅣ미지 가볍게하고 쉘스크립트 돌

UNIX-domain socket

# Regular Expression in nginx

일단 ~ 뒤에 사용을 해야 한다.
~ \.(gif|jpg|png)$
	-> .gif, .jpg, .png로 끝나는 요청을 말함.

# NGINX 설정파일에서 가상호스트명을 쓰는방법?

당연히 쓸수있다.
내가 쓰지 못한 이유는 컨테이너간 의존성 설정을 하지않았기 때문.
wordpress, db를 먼저 만들고 nginx가 생성되게 하지 않았음.
wordpress를 만들기전에 nginx에서 wordpress 가상호스트를 접근함.

nginx: [emerg] host not found in upstream

이 에러가 뜬 이유
- 알 수 없는 hostname인 경우 설정파일 내에서 upstream 블록에 기재된
가상호스트명을 찾는데. 여기에서도 hostname을 찾지못하면 위 에러가 반환된다.

# 어떻게 컴포즈 서비스명을 호스트네임으로 사용될 수 있음?

# 왜 dockerignore 사용? 왜 dockerfile경로를안주고 context를 사용?
- because the client and daemon may not even run on the same machine

요약
- 우리가 사용하는 docker명령어는 dockerd 데몬프로세스에게 보내는 클라이언트 프로그램이다.
- 데몬프로세스와 클라이언트가 다른 머신에서 작동될 수 있다.
- 이경우 dockerfile에 ADD,COPY로 사용될 파일에 대한 정보를 데몬프로세스에서는 알 수 없다.
https://stackoverflow.com/questions/44465703/what-is-the-purpose-of-the-docker-build-context

# fastcgi 지시어들은 무엇을 의미함?

# 쉘스크립트 첫줄에 #!/bin/sh는 왜 있어야 함?
It's called a shebang, and tells the parent shell which interpreter should be used to execute the script.

# Nginx에서 쉘스크립트를 tini로 돌리도록 바꾸며 마주한 에러들.
| nginx        | [FATAL tini (10)] exec ./nginx.start.sh failed: Exec format error
	-> nginx.start.sh에 shabang을 넣지 않았다.

# compose : restart의 필요성?

# 환경변수 넣기.

- use .env file
environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}

WARNING: The MYSQL_ROOT_PASSWORD variable is not set. Defaulting to a blank string.

ERROR: The Compose file './docker-compose.yml' is invalid because:
services.wordpress.environment contains {"MYSQL_ROOT_PASSWORD": "1234"}, which is an invalid type, it should be a string
services.mariadb.environment contains {"MYSQL_ROOT_PASSWORD": "1234"}, which is an invalid type, it should be a string

docker-compose.yml에서 Environment를 넣을때 각 변수에 - 를 빼라.
docker-compose config를 치면 환경변수가 들어간 최종 yml을 확인할 수 있다.

.... -> 실제로 컨테이너에서 확인해보니 환경변수 선언만 되고 값이 비어있다.

env_file 옵션을 통해 넣는 것에 성공했다.



# wordpress config 돌려보면 오류남.... -> 그냥 cli를 써서 설정하는 것이 좋을듯 하다.

- 설치법
	- curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	- php wp-cli.phar --info
		-> 에러 발생....??
			apk add php7-phar
			apk add php7-json
	- chmod +x wp-cli.phar
	- mv wp-cli.phar /usr/local/bin/wp
	- wp --info
- cli 설정
	- wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USR --dbpass=$MYSQL_PASSWORD --dbhost=$MYSQL_HOST
	- wp config get
		- 오류...?
	- wp core install --admin_user=admin --admin_email=admin@gmail.com --url=http://$DOMAIN_NAME --title='테스트'

# 왜 mariadb를 껐다키면 연결을 못함?
- 각 컨테이너에서 설정.sh과 entrypoint.sh를 분리하여 작업해야 함.. 지금 혼재...
	- 어떤 작업을 conf에 하고 어떤 작업을 entrypoint에서 해야할까?
# wordpress...

- wordpress cli 설치
	- https://developer.wordpress.org/cli/commands/ 이거있으면 무적임^오^
	- cli로 설정파일 생성 -> 성공
	- config파일을 php로 컴파일해보니 에러 발생...
		- wordpress파일 자체를 다른 방법으로 받아볼까?
			- wp core download
			- 속도가 훨씬 빠르다. 그렇지만 문제해결은 하지 못했다.
			- 일단 wordpress 설치는 이 방식으로 고치자.

현재 발생하는 에러
PHP Warning:  require_once(/var/www/html/wp-includes/class-wp-textdomain-registry.php): failed to open stream: No such file or directory in /var/www/html/wp-settings.php on line 155
-> class-wp-textdomain-registry.php파일이 없다.

PHP Fatal error:  require_once(): Failed opening required '/var/www/html/wp-includes/class-wp-textdomain-registry.php' (include_path='.:/usr/share/php7') in /var/www/html/wp-settings.php on line 155
-> -> class-wp-textdomain-registry.php파일을 여는데 실패했다.

**해결**
make re를 해도 이전에 사용한 볼륨이 남아있었으며,
내가 cli로 설치한 wordpress는 볼륨에 설치가 아닌 루트디렉토리에서 설치되고 있었다.
wordpress container는 볼륨에 있는 php파일들을 보여주므로 완전 엉뚱한 장소에서 작업한 셈....

- 1 error
+ wp config create '--dbname=wordpress_db' '--dbuser=gshim' '--dbpass=1234' '--dbhost=mariadb'
Error: This does not seem to be a WordPress installation.
Pass --path=`path/to/wordpress` or run `wp core download`.
-> wordpress 설치전에 config를 해서 그런듯. 순서를 바꿔보자.

- 1 error
Error: The 'wp-config.php' file already exists.
-> 이전 오류는 예상대로 서순문제가 맞는 것 같다. 이번엔 새로만든 config파일이 기존 것을 대체해야 한다.
-> 1)기존것을 삭제하고 만들어주거나 2) 기존것을 대체하는 wp config create 옵션을 넣자.
-> 2) [--force]Overwrites existing files, if present.

- 성공!!

그렇지만 php no file 에러는 아직 해결하지 못했다.

qkdlsem

# make re시, 볼륨도 삭제후 재생성...?!

# 현재에러
Error: Insufficient permission to create directory '//=/var/www/html/'.
-> 볼륨이 안만들어진건가...?
-> 볼륨이 만들어지는 시점은??
-> 볼륨 생성전에 마운트대상 폴더에 접근하면 어떻게 됨?
--path==/var/www/html -> --path=/var/www/html
=이 2개 있었네..ㅎㅎ

Error: This does not seem to be a WordPress installation.
Pass --path=`path/to/wordpress` or run `wp core download`.
-> 혹시 wordpress가 설치되지 않은것 같다는 건가?
-> 이전에는 설치시 path를 주지않아 같은 디렉토리가 곧 설치디렉토리였다.
-> 이제 다른디렉토리(볼륨)에 설치했으니 실행하는 명령에도 path를 붙여주어야 한다!!
-> 이 경로또한 매번 달라지므로, 환경변수로 등록하는 것이 좋을 것 같다.

# 22.11.03 02:54 UI깨짐에러

GET https://gshim.42.fr/wp-includes/blocks/navigation/style.min.css?ver=6.0.2 net::ERR_NAME_NOT_RESOLVED
html css js등의 파일을 get으로 요청하는데 서버도메인명이 gshim.42.fr이라 인식이 안되는듯.
일단 localhost로 도메인명을 바꾸고 다시해보자...!!
-> 도메인명은 localhost로 바뀌었으니 해당 요청들을 NGINX에서 막고있다...!
-> location / {} 블럭 하나만 선언해서 모든 요청이 저 블럭으로 들어갈줄 알았는데.... 아닌가?

# 22.11.03 03:35 아무것도 안나옴에러...?
위 UI깨짐 에러를 해결했는데 이번엔 아무화면도 안나온다;;;
어떻게 이럴수가....??😂
nginx에서 fast_cgi관련 인자들을 적절히 넣지 못해서 그런듯하다.
-> 어? 로케이션블락 수정하니 wp-login.php가 안깨지고 나온다.
-> 근데 index.php는 깨진다.... 왜???!!


# 할일
- [O]ssl_protocols  TLSv1.2 TLSv1.3;
- [X]모든요청 wordpress로 돌리기
- [X]domain name을 추가하기. etc/hosts에 추가하면 되려나?
	- gshim.42.fr로 접근할 수 있도록 해야함.

- [X]DB가 저장되는 곳이 볼륨이 되게 한다.
	- show variables like 'datadir'; 쿼리를 통해 data가 실제로 저장되는 디렉토리를 확인한다.
MariaDB [(none)]> show variables like 'datadir';
+---------------+-----------------+
| Variable_name | Value           |
+---------------+-----------------+
| datadir       | /var/lib/mysql/ |
+---------------+-----------------+
1 row in set (0.002 sec)
	- 해당 디렉토리를 volume 마운트포인트로 잡는다.
	- 현재, datadir를 설정값을 줘서 바꾸었지만 오류가 발생한다.
mariadb      |  * Datadir '/home/gshim/data' is empty or invalid.
mariadb      |  * Run '/etc/init.d/mariadb setup' to create new database.
mariadb      |  * ERROR: mariadb failed to start

- [O]이 볼륨의 path는 home/dohykim/data여야합니다.
	- 그런데 subject를 보니 해당 위치를 /home/login/data로 해야한단다.
	- 볼륨이 호스트머신에서 저기있어야 된다는건지, 컨테이너속에서 저 경로에 있다는 건지 모르겠다.
	- 아, website볼륨이 각 컨테이너에서 /home/gshim/data에 위치해 있어야 한다는 뜻인듯@!
	- 같은 볼륨이 컨테이너마다 다른 디렉토리에 마운트될 수 있다는 걸 간과했다.

- chown을 해줘야 하는 이유??
- docker-compose의 각 서비스에 restart:always를 붙이는 이유?
- wordpress 계정 2개(관리자,일반) 모두 추가되었는지 확인할 것.

리서치...
MariaDB 팁
- mysql_install_db 명령어를 사용하면 mysql 데이터 디렉터리를 초기화시킬 수 있다.
- 기본으로 사용되는 디렉터리(/var/lib/mysql)를 사용하지 않고자 할 때 사용하면 유용하다.
- mysqld_safe를 사용하여 mysql서버를 실행시킬 수 있는 방법이 있다.
- mysqladmin 명령어로 mysql을 사용하여 데이터베이스 생성, 루트 패스워드 설정 등 다양한 작업을 쉘로 할 수 있다.

mysqld_safe가 뭐지? 찾아봐야겠다.

===================================================

- etc/hosts로 gshim.42.fr로 NGINX 접근하기
- volume 이름지정 + bind방식 사용
- DB컨테이너가 재실행되도 연결이 되도록 고치기
- DB에 wordpress 2개의 계정이 추가되는지 확인하기
