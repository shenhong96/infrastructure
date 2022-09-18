#!/bin/bash
[ -f $HOME/.ssh/id_ed25519 ] || ssh-keygen -t ed25519

echo enter ip address you want to scan for available host eg: 192.168.0.0
read NETWORK

mapfile -t hosts< <(nmap -sn ${NETWORK}/24 | grep ${NETWORK%.*} | awk '{print $5 $6}')

for value in "${hosts[@]}"
do
	echo $value
done

PS3='which host do you want to setup? (ctrl-c to quit)'
select host in "${hosts[@]}"
do
	case $host in
		*)
			echo you selected $host
			set -v
			ssh-copy-id root@$host
			ssh root@$host
			set +v
			;;
	esac
done
##