# 자주 사용하는 도커 커맨드 정리


dockerfile로 이미지 만들기
docker build -t [img_name] [dockerfile_dir]
=> dir에 있는 도커파일을 써서 img_name이라는 이름으로 컨테이너를 만듭니다.

이미지로 컨테이너 돌리기
docker run --name gshim-nginx-con -p 8080:80 gshim-nginx-img3
쉘 연상태로 돌리는 방법
docker run -it --name gshim-nginx-con -p

모든컨테이너 삭제
docker rm `docker ps -a -q`

# 모든 컨테이너 중지
docker stop $(docker ps -aq)

# 사용되지 않는 모든 도커 요소(컨테이너, 이미지, 네트워크, 볼륨 등) 삭제
docker system prune -a

# 특정 컨테이너에 명령어 실행하기

docker exec -it 04f94334b838 bash
