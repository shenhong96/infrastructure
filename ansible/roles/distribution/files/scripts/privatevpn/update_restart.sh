#!/bin/bash
CONTAINER=(qbittorrent radarr sonarr lidarr bazarr readarr)

if [ -z $1 ]
then
	echo "action required: restart / update / full"
	exit 1
fi

update_docker(){
    echo "Downloading the latest docker image"
    docker-compose pull
    echo -e "\n"
    echo "Recreating docker with latest image"
    docker-compose up -d --force-recreate
    docker image prune --force
    echo -e "\n"
    restart_docker
}

restart_docker(){
    echo "Rebuild the VPN connection in correct order"
    docker restart vpn
    sleep 2
    docker restart ${CONTAINER[@]}
    echo "Operation has been completed."
    docker exec vpn bash /config/myannonymous.sh
}

repair_docker(){
    echo "Rebuild Arr"
    docker-compose stop
    docker container prune -f
    docker-compose up -d
    restart_docker
}

case $1 in
restart)
    restart_docker
    ;;
update)
    update_docker
    ;;
full)
    update_docker
    restart_docker
    ;;
repair)
    MEMORY=$(free -m | grep Mem: | awk '{print $3}')
    echo ${MEMORY}
    if [ $MEMORY -gt 5000 ]; then repair_docker
    fi    
    ;;
esac
