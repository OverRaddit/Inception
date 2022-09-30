# Mandatory

- 특정한 규칙아래 서로다른 서비스로 구성된 작은 인프라를 구성하는 프로젝트
- docker-compose를 사용해야함
- 각 도커이미지는 해당 서비스와 같은 이름을 가진다.
- 각 서비스는 전용 컨테이너에서 실행되어야 한다.

- 성능의 이유로, 그 컨테이너는 Alpine Linux의 두번째 안정적인 버전 혹은 Debian Buster에서 제작되어야 한다.
- 당신은 각 서비스당 도커파일을 작성해야 한다.
	- 도커파일은 makefile에 의해 당신의 docker-compose.yml파일에서 불러져야 한다.
	- 이는 당신이 스스로 프로젝트의 도커 이미지를 빌드해야 한다는 것을 의미한다.
	- 도커허브와 같은 서비스를 사용하는 것 뿐만 아니라 준비된 도커 이미지를 가져오는 것이 금지된다.(알파인/데비안은 이룰에서 제외된다.)
		- 선택지가 둘밖에없는데 둘다 해당룰에서 제외된다는 것은 이상한데;;

- 당신이 셋팅해야 하는 것
	- NGINX with TLSv1.2 or TLSv1.3를 포함하는 도커 컨테이너
	- NGINX없이 WordPress + php-fpm를 포함하는 도커 컨테이너
	- NGINX없이 MariaDB를 포함하는 도커 컨테이너
	- WordPress DB를 포함하는 volume ->.....?
	- WordPress website files를 포함하는 2번째 volume
	- 당신의 컨테이너간 연결을 설립할 docker-network
- 당신의 컨테이너는 crash 상황에 재시작해야 한다.

(i) 도커 컨테이너는 가상머신이 아니다. 따라서, tail -f에 기반한 hacky path를 사용하는 것은 추천하지 않는다.
어떻게 데몬이 동작하는지, 그것을 사용하는 것이 좋은생각인지 아닌지 읽어보라.

(주의) 당연히 네트워크를 사용하는 것은 금지된다.(host, --link, links)
그 네트워크 라인은 당신의 docker-compose.yml파일에 존재해야 한다.
당신의 컨테이너는 무한루프를 돌리는 커맨드로 시작되지 않아야 한다.
따라서 이는 진입점으로 사용되거나 진입점 스크립트에서 사용되는 모든 명령에도 적용됩니다. 다음은 몇 가지 금지된 해커 패치입니다: tail -f, bash, sleep infinity, when true.

(i) PID1, dockerfile 예제에 대해 읽어보라

2개의 유저를 가진 당신의 WordPress DB에서 그둘중 하나는 관리자가 된다.
관리자의 유저이름은 admin/Admin, administrator/Administrator를 포함할 수 없다.
(e.g., admin, administrator, Administrator, admin-123, and
so forth).

(i) 당신의 volumes는 도커를 이용한 호스트머신의 /home/login/data 폴더에서 사용가능하다.
물론, login을 당신것으로 바꾸어야 한다.(폴더를 갈아끼우라는듯...?)

간단히 만들기 위해, 당신은  도메인 이름을 구성해야 한다.
