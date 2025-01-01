# Build with a specific version

set docker_hub_user wbfw109v2 (my nickname)

# or docker build -t synergy-hub-backup-env . (but if you want to push later, you must ... later..)

docker build -t $docker_hub_user/synergy-hub-backup-env:0.1 .

# Add latest tag

docker tag $docker_hub_user/synergy-hub-backup-env:0.1 $docker_hub_user/synergy-hub-backup-env:latest

# Push both tags

docker push $docker_hub_user/synergy-hub-backup-env:0.1
docker push $docker_hub_user/synergy-hub-backup-env:latest

docker tag synergy-hub-backup-env:0.1 <docker_hub_username>/synergy-hub-backup-env:0.1
docker push <docker_hub_username>/synergy-hub-backup-env:0.1

### how to use

docker run -it --rm wbfw109v2/synergy-hub-backup-env

check from pushed docker hub
docker rmi synergy-hub-backup-env
docker pull

how to push

docker login

규악이 꽤 있는 lfs 대신 docker hub 를 public 으로 저장소를 사용하자자 것은 다음 링크로부터 영감을 받음.

## https://github.com/PhysicsX/QTonRaspberryPi/tree/main
