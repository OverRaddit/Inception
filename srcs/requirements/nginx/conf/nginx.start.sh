#!/bin/sh

# Make a Directory for SSL
mkdir /etc/nginx/ssl
chmod 700 /etc/nginx/ssl

# 개인키,인증서 생성
openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=Lee/CN=gshim.42.fr" -keyout /etc/nginx/ssl/gshim.42.fr.key -out /etc/nginx/ssl/gshim.42.fr.crt

# Run Nginx as foreground
/usr/sbin/nginx -g "daemon off;"


# -newkey rsa:4096
# 새로운 인증서 요청과 개인키를 생성한다.


# -nodes
# 개인키가 생성될때 암호화되지 않는다.

# x509
# This option outputs a self signed certificate instead of a certificate request.
# This is typically used to generate a test certificate or a self signed root CA.

	# -days 365
	# x509옵션이 사용될때 인증서 유효기간 일수를 지정함. 아니면 무시됨
	# 양의 정수이며 기본값 30일

	# -subj
	# 새 request나 supersedes에 대해 subject이름을 설정한다.
	# 형식은 다음과 같다.
	# /type-=value0/type1=value1/type2=...
