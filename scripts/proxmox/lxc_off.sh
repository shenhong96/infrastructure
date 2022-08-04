#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
function print_time(){
	NW_TIME=$(date | grep $1 | awk '{printf $5}')  	#grep the timestamp xx:yy:zz
	MATCH_TIME=$(echo "${NW_TIME%%:*}")		#grep the hour-stamp xx
	VAL_TRIGGER=$(echo "${MATCH_TIME#0}")		#remove the zero eg: 09 -> 9
	echo $VAL_TRIGGER
}

AM_DESIRED=7						#AM timestamp to turn-on machine
PM_DESIRED=11						#PM timestamp to shutdown machine
LXC=("103" "116" "201")					#LXC PCT ID target

#OFF-TRIGGER
print_time PM
[ -z $VAL_TRIGGER ] && VAL_TRIGGER=$((PM_DESIRED+1)) 		         	#Increase desired value by 1, so script wouldn't throw error and wouldn't triggered 
if [ $VAL_TRIGGER -eq $PM_DESIRED ]; then
	for i in "${!LXC[@]}"; do pct stop "${LXC[$i]}"; done			#Shutdown item listed in $LXC
fi

#ON THE LXC
print_time AM
[ -z $VAL_TRIGGER ] && VAL_TRIGGER=$((AM_DESIRED+1)) 
if [ $VAL_TRIGGER -eq $AM_DESIRED ]; then
	for i in "${!LXC[@]}"; do pct start "${LXC[$i]}"; done
fi




########### OLD SCRIPT #############
#function off_lxc(){
#	print_time PM
#	[ -z $VAL_TRIGGER ] && VAL_TRIGGER=12
#	if [ $VAL_TRIGGER -eq '11' ]; then
#		for i in "${!LXC[@]}"
#		do
#			echo "now is $(date) and proceed to shutdown the LXCs" >> .log/turn_off_history.txt
#			pct stop "${LXC[$i]}"
#			sleep 5
#		done
#	else
#		echo "Time is not up or Job is over" >> turn_off_done.txt
#		exit 1
#	fi
#}


#function on_lxc(){
#	print_time AM
#	[ -z $VAL_TRIGGER ] && VAL_TRIGGER=12
#	if [ $VAL_TRIGGER -eq '07' ]; then
#		for i in "${!LXC[@]}"
#		do
#			echo "now is $(date) and proceed to powerup the LXCs" >> .log/turn_off_history.txt
#			pct start "${LXC[$i]}"
#			sleep 5
#		done
#	else
#		echo "Time is not up or Job is over" >> turn_off_done.txt
#		exit 1
#	fi
#}

#off_lxc
#on_lxc
