# 왜 컨테이너 환경에서 Alpine Linux가 선호될까?


## Small(Lighter)

- 알파인 리눅스는 가볍다.
  - 커널을 제외한 용량이 8MB이다.
  - Glibc가 아닌 Musl을 사용하여 더더욱 임베디드에서 가볍게 동작한다.
  - 비지박스기반으로 단일 바이너리의 용량을 줄였다.

- 클라우드 환경의 경우, 용량이 적은 것이 장점이다.
  - 네트워크 사용량에 따라 과금비용이 올라감.
  - 컨테이너환경에서는 지속해서 배포가 이루어지고 여러 이미지를 받음.

## Secure

- 모든 유저 레벨의 바이너리들은 PIE로 컴파일이 되어 Stack Smashing Protection이 되어있다.
  - PIEㄴ는 리눅스 환경에서의 메모리 보호기법이다.
  - PIE를 사용하여 컴파일 된 실행파일은 ROP공격이 더 어렵다.
  - 2014년, ShellShock 취약점이 발견됨 -> Bash터짐
    - Bash를 기본으로 설치하지 않는 알파인 리눅스는 영향안받음.

## 그래서 왜 선호?

Docker가 호스트 운영체제의 커널 위에 격리를 시켜주는 반가상화 시스템이기 때문이다. 이러한 가벼움 덕분에 Docker를 사용하여 많은 패키지를 가상화하여 올리는 경우나 정말로 서버에 올리고 싶은 것만 깔끔히 올리고 싶은 경우에 Alpine Linux를 사용한다. 리눅스를 데스크톱으로 사용하는 경우에는 직접 모든 것을 세팅하는 시간보다 다른 사용성에 더 중점을 맞춘 배포판을 설치하는 시간이 더 짧다.