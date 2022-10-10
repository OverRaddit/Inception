# Inception

## docker-compose

- 여러 개의 컨테이너를 실행시키는 도커 애플리케이션을 정의할 툴.
- yaml 파일을 이용하여 구성한다.
- single command?
- compose(CI등)는 모든 환경을 포함한다.

### 프로세스 3단계

1. 각 컨테이너의 Dockerfile을 작성한다.

2. docker-compose.yml에서 앱을 구성할 수 있는 서비스를 정의합니다.
	-> 단 하나의 환경에서 실행할 수 있게 함.

3. docker-compose up 명령어를 실행함.

```yml
version: '3'
services:
  web:
    build: .
    ports:
    - "5000:5000"
    volumes:
    - .:/code
    - logvolume01:/var/log
    links:
    - redis
  redis:
    image: redis
volumes:
  logvolume01: {}
```
