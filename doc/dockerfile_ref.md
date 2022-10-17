# docker docs 정리번역

https://docs.docker.com/engine/reference/builder/

### docker build

- dockerfile -> docker image 작업
- dockerfile이 있는 디렉토리를 보내야함
- 도커데몬은 디렉토리를 받아 하위디렉토리까지 뒤짐
- 디렉토리를 "/"로 보내면 모든 하드디스크를 탐색함
- t옵션으로 이미지명 명시, f옵션으로 디렉토리 명시가능

### dockerfile

- 각 instruction은 독립적으로 실행됨
  - RUN cd /tmp는 다음 instruction에 영향을 주지 않는다는 뜻.
- 가능할 때마다 Docker는 빌드 캐시를 사용하여 도커 빌드 프로세스를 크게 가속화합니다. 이는 콘솔 출력의 CASHED 메시지로 나타납니다.
  - cache 내용은 생략.
- 빌드 이후, 이미지 스캔과 도커허브 업로드가 가능해진다.

### BuildKit

- 18.09버전부터 도커에서 지원하는 하는 백엔드 시스템
- 모비/빌드킷 프로젝트는 빌드를 실행해주는 시스템이다.
특성
- 사용하지 않는 빌드 단계 실행 검색 및 건너뛰기
- 독립적인 빌드 단계 구축 병렬화
- 빌드 간 빌드 컨텍스트에서 변경된 파일만 증분 전송
- 빌드 컨텍스트에서 사용하지 않는 파일 검색 및 전송 건너뛰기
- 새로운 기능이 많은 외부 Docker 파일 구현 사용
- 나머지 API(중간 이미지 및 용기)로 인한 부작용 방지
- 자동 가지치기를 위해 빌드 캐시 우선 순위 지정

- DOCKER_BUILDKIT=1 환경변수를 셋팅하고 docker build를 하면 사용할 수 있다.

빌드킷과 프론트/백에 관한 정보
https://stackoverflow.com/questions/73067660/what-exactly-is-the-frontend-and-backend-of-docker-buildkit

요약하자면,
빌드에 관한 사용자의 정의를 buildkit의 프론트엔드.
정의된 내용을 토대로 빌드작업을 최적화하는 것이 buildkit의 백엔드인 것 같다.

### Format

```dockerfile
INSTRUCTION arguments
RUN echo hello
```
- instruction은 대소문자 구분을 하지 않지만 관습상 대문자로 함.
- 순서대로 실행함.
- FROM 명령으로 시작해야함(파서 지시, 주석, ARG는 예외)
- #이 아니여도 유효한 지시어가 아니면 주석취급함.
- #로 시작하는 줄은 주석, 어느 중간에 #이 있으면 인자취급

### FROM

- ARG를 제외하고 보통 dockerfile 첫줄에 온다.
  - ARG로 선언한 변수값은 FROM 이후에 이름만 재선언하여 사용할 수 있다.
```dockerfile
ARG VERSION=latest
FROM busybox:$VERSION
ARG VERSION
RUN echo $VERSION > image_version
```
- 새 빌드 스테이지를 초기화한다.
- 하나의 dockerfile에서 여러번 사용할 수 있다.
  - 여러개의 이미지를 생성하거나 의존성을 가진 이미지를 생성할 수 있음.
- 사용 이후 이전 instruction으로 생성된 상태를 모두 초기화함.

### RUN
```dockerfile
#/bin/sh -c command
RUN <command>
#exec-form
RUN ["executable", "param1", "param2"]
```
- RUN 명령은 현재 이미지 위에 있는 새 레이어에서 명령을 실행하고 결과를 커밋합니다. 결과 커밋된 이미지는 Docker 파일의 다음 단계에 사용됩니다.
- exec 폼을 사용하면 셸 문자열 munging을 방지하고 기본쉘이 없는 이미지에서 명령어 실행가능
- exec 폼은 쉘을 통해서 수행하는게 아니기때문에 환경변수 변환이 안됨($HOME이 환경변수변환이 안되고 그대로 전달된다)


### CMD
```dockerfile
CMD ["executable","param1","param2"] (exec form, this is the preferred form)
CMD ["param1","param2"] (as default parameters to ENTRYPOINT)
CMD command param1 param2 (shell form)
```

- 하나의 dockerfile엔 하나의 CMD만 적용된다.(여러개일 경우 마지막것만 적용됨)
- CMD의 주요 목적은 실행 중인 컨테이너에 기본값을 제공하는 것입니다.
- 이러한 기본값은 실행 파일을 포함하거나 실행 파일을 생략할 수 있으며, 이 경우 엔트리 포인트 명령도 지정해야 합니다.

=> CMD, ENTRYPOINT의 차이는???
- 컨테이너가 매번 동일한 실행 파일을 실행하도록 하려면 CMD와 함께 ENTRYPOINT를 사용하는 것을 고려해야 합니다. ENTRYPOINT를 참조하십시오.

### LABEL

### EXPOSE

- 컨테이너가 몇번포트를 열어놓을지 결정하는 명령어
- 실제 호스트환경의 포트를 여는게 아님임을 유의할것.
  - 해당상황을 원하는 경우 docker run -p 80:80/tcp -p 80:80/udp ...를 사용

### ENV

- ARG, ENV의 차이점
  - ARG는 빌드중, ENV는 run-time
- 컨테이너 환경변수로 사용됨.
- 환경변수 지속성은 예상치 못한 부작용을 일으킬 수 있다.
  - 예를 들어 ENVDIVAN_FRONTEND=noninteractive를 설정하면 apt-get의 동작이 변경되고 이미지 사용자에게 혼란을 줄 수 있습니다.
- 환경 변수가 빌드 중에만 필요하며 최종 이미지에는 필요하지 않은 경우 단일 명령에 대한 값을 설정하는 것이 좋습니다.

### ADD

### COPY
```dockerfile
COPY [--chown=<user>:<group>] <src>... <dest>
COPY [--chown=<user>:<group>] ["<src>",... "<dest>"]

COPY hom* /mydir/
COPY hom?.txt /mydir/
```
컨테이너 속에 맨 마지막 인자인 dest에 src디렉토리들을 복사해넣어둔다.
- dest는 절대경로(/ 로 시작) or WORKDIR의 상대경로
- src는 상대경로

### ENTRYPOINT
```dockerfile
# exec-form
ENTRYPOINT ["executable", "param1", "param2"]
# shell-form
ENTRYPOINT command param1 param2
```
Command line arguments to docker run <image> will be appended after all elements in an exec form ENTRYPOINT, and will override all elements specified using CMD. This allows arguments to be passed to the entry point, i.e., docker run <image> -d will pass the -d argument to the entry point. You can override the ENTRYPOINT instruction using the docker run --entrypoint flag.

- shell-form
  - CMD, RUN command를 막는다.
  - /bin/sh -c 의 하위 명령어 된다.
    - 실행될시 컨테이너의 PID 1이 아니게 됨
    - 유닉스 신호를 받을 수 없어서 docker stop으로 인한 SIGTERM을 수신할 수 없게됨.
- exec-form

Only the last ENTRYPOINT instruction in the Dockerfile will have an effect.

- 엔트리 포인트를 사용하면 실행 파일로 실행할 컨테이너를 구성할 수 있습니다.


### VOLUME

### USER

### HEALTHCHECK