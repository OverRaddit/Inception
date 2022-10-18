## 이미지의 구조에 대해...

- 도커 이미지는 몇겹의 레이어에 의해 빌드된다.
- 각 레이어는 dockerfile의 한 instruction에 해당된다.
  - FROM, COPY, RUN등과 같은 명령어들!
- 마지막 계층을 제외한 각 계층은 읽기 전용이다.
- 스토리지 드라이버는 이러한 계층이 서로 상호 작용하는 방식에 대한 세부 정보를 처리합니다. 상황에 따라 장단점이 있는 다양한 스토리지 드라이버를 사용할 수 있습니다.

- R/W layer
  - image 레이어의 최상단에 놓아짐으로써 컨테이너가 되게해주는 layer층
  - container layer라고도 함.

## Containers and Layers

- 컨테이너와 이미지의 주된 차이는 최상단의 writable layer이다.
- container를 대상으로 하는 모든 write(파일 추가, 수정 등)는 여기에 저장된다.
- 컨테이너가 삭제될 때, 이 writable layer 또한 삭제된다. 밑에 있는 것들은 유지됨.
	-> 종료가 아닌 삭제라고 했다.
	-> 그럼 종료후 다시 restart를 하면 기존 writable layer는 왜 삭제된 거지?
- 각 컨테이너들은 컨테이너 레이어를 각자 가지지만, 그 밑에 레이어들은 공유한다.
- 도커는 img layer와 writable container layer의 내용물을 관리하기 위해 스토리지 드라이버를 사용한다.
  - 각 스토리지 드라이버는 구현을 다르게 처리한다.
  - 단, 모든 드라이버들은 stackable img layer와 copy-on-write 전략을 사용한다.

## Container size on disk

- running container의 대략적인 크기를 보기 위해 docker ps -s 를 사용할 수 있다.
  - size col : writable layer에서 사용중인 데이터의 양
  - virtual size : 컨테이너에서 쓸 [read-only img layer data] + [writable layer data]의 양
    - 한 이미지를 공유하는 컨테이너들은 read-only img data를 공유한다.
    - -> 각 컨테이너들의 virtual size합은 실제 용량보다 클 수 있는 이유가, 같은 이미지를 공유하는 컨테이너들끼리는 중복된 read-only img를 공유하는데 계산시 이를 중첩해서 더하기 때문이다.
- 컨테이너가 디스크 공간을 차지할 수 있는 다음과 같은 추가 방법은 포함되지 않습니다.
  - 이 부분은 생략함...

## The copy-on-write(COW) strategy

COPY-on-write란?
- 리소스가 복제되었지만 수정되지 않은 경우에 새 리소스를 만들 필요 없이 복사본과 원본이 리소스를 공유하고, 복사본이 수정되었을 때만 새 리소스를 만드는 리소스 관리 기법
- 파일 혹은 폴더가 이미지 내부 하위계층에 존재하면서 다른 레이어에서 그것에 read 접근이 필요할 경우, 기존 파일을 사용.
- -> 타 레이어에서 읽기권한으로 사용하는 파일/디렉토리가 하위 레이어에 이미 존재할 경우 하위 레이어에 있는걸 사용한다는뜻.
- 그 파일이 현 레이어에서 처음으로 수정될 경우, 그제서야 파일은 복사된다.
- 이것이 I/O와 각 하위 레이어의 크기를 최소화한다.


그렇다면 이미지가 삭제되었을 때, 왜 컨테이너는 다시 돌릴 수 있을까?

????
컨테이너는 그 이미지의 인스턴스이다.
이전에 생성된 컨테이너가 존재하고 <- ????
삭제되지 않는 한 기본 컨테이너 이미지에 종속되지 않는다.

https://stackoverflow.com/questions/58828646/what-happens-to-a-docker-container-when-i-delete-its-image

https://docs.docker.com/storage/storagedriver/
