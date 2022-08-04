#!/bin/bash

CONTAINER=(vpn qbittorrent radarr prowlarr sonarr lidarr bazarr readarr)

echo -e " \n" >> ./.ip.txt
echo -e "###### *arr SERVICE VPN IP CHECKING REPORT ###### \n" >> ./.ip.txt

for c in ${CONTAINER[@]}
do
    docker exec ${c} curl ifconfig.me >> ./.ip.txt
    echo -e " ${c} \n" >> ./.ip.txt
done

cat .ip.txt
rm .ip.txt
