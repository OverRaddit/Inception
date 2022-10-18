# Docker Volume

- 컨테이너마다 독립적인 볼륨이 할당되고, 컨테이너가 삭제되면 같이 삭제된다.
- 컨테이너 삭제시 내부에 저장되는 데이터가 같이 **삭제**될 수 있다!
- 즉, 컨테이너 안에 중요한 데이터를 두는 것은 안전한 방법이 아니다.

도커에서 데이터의 영속성을 보장하기 위해 여러 방법을 지원하는데,
가장 쉽고 대중적인 방법은 **도커 볼륨**을 이용하는 것이다.

도커볼륨은 영속성을 보장하며 파일시스템과 컨테이너를 분리하여 관리한다.
- 컨테이너를 지웠다가 재실행해도 도커볼륨만 연결하면 데이터는 그대로 유지된다.

# Docker Volume의 종류

## Docker Volume
- docker volume create 명령어
  - 도커 엔진이 관리하는 볼륨을 생성할 수 있다.

## Host bind mount
호스트 파일 시스템의 특정 디렉터리를 컨테이너 내부 볼륨의 디렉터리와 마운트한다.
컨테이너에서 호스트 파일시스템에 접근한다.
	- 보안에 영향을 미칠 수 있는 강력한 기능....
## tmpfs mount
리눅스에서 도커를 실행하는 경우에만 사용할 수 있다.
볼륨을 호스트의 파일 시스템이 아닌, 메모리에 저장하는 방식이다.
컨테이너가 살아있는 동안 메모리에 저장된다.
파일로 저장하면 안되는 민감정보/비밀 정보를 저장할 때 사용된다.
# 질문
- 마운트가 뭐야...? 매핑이랑 비슷한 개념인가

출처
https://deveric.tistory.com/111?category=387263


# volumes in docker-compose
- (https://docs.docker.com/compose/compose-file/compose-file-v3/#volumes)

- host 경로/볼륨명을 서비스의 sub-options로 명시해야 한다.
- host 경로를 단일 서비스의 정의 일부로 마운트할 수 있으며 해당 경우에는 top-level에 volumes key를 정의할 필요가 없다.
- 하지만 한 볼륨을 여러 서비스간에 재사용하고 싶은경우, top-level에 볼륨키를 통해 **네임볼륨**을 정의하라.
- -> 네임볼륨 : named volume용어를 내식대로 부른단어. 이름이 정의되어있는 볼륨이다.
- -> version3부터는 top-level 볼륨키에 각 서비스 아 뭔소린지모르겟음

## Short syntax

[SOURCE:]TARGET[:MODE]

- SOURCE	: host path / volume name
  - host path : compose 파일로부터의 상대경로를 입력할 수 있다(단, ".", ".."으로 시작해야함) 절대경로도 가능
- TARGET	: 볼륨이 마운트되는 컨테이너의 경로
- MODE		: readonly(ro), read-write(rw, **default**)

```yml
volumes:
  # Just specify a path and let the Engine create a volume
  - /var/lib/mysql

  # Specify an absolute path mapping
  - /opt/data:/var/lib/mysql

  # Path on the host, relative to the Compose file
  - ./cache:/tmp/cache

  # User-relative path
  - ~/configs:/etc/configs/:ro

  # Named volume
  - datavolume:/var/lib/mysql
```
## Long syntax

short syntax에서 설정하지 못한 세부 필드까지 설정을 허용한다.

- type: mount type인 volume, bind, tmpfs, npipe중 하나
- -> 각 타입은 뭐가 다를까?
- source: 마운트되는 부분의 원본.
  - 호스트의 경로나 top-level에 정의한 볼륨명이 올 수 있다.
  - tmpfs mount에서는 사용할 수 없다.
  - -> 왜?
- target: 볼륨이 마운트되는 컨테이너의 경로. 컨테이너의 어디에 볼륨을 넣을까?
- read_only: 설명생략
- bind: 추가적인 bind 옵션을 설정한다.
  - propagation: bind의 propagation 모드
  - -> 그게 뭔데;;
- volume: 추가적인 volume 옵션을 설정한다.
  - nocopy: 컨테이너에서 볼륨이 생성될 때 데이터를 복사하지 못하도록 하는 플래그
  - -> 즉, nocopy가 true일때는 볼륨을 복사해오는게 아닌 원본을 참조하는 방식으로 동작하는 것 같다.
- tmpfs: 추가적인 tmpfs 옵션을 설정한다.
  - size: tmpfs mount의 byte 크기

NOTE
- 바인드 마운트를 생성할 때 긴 구문을 사용하려면 미리 참조된 폴더를 만들어야 합니다.
- 짧은 구문을 사용하면 폴더가 없는 경우 즉시 생성됩니다.