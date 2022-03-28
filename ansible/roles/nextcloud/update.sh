#!/bin/bash
shopt -s extglob

function job_fail(){
	if [[ $? -eq 0 ]]; then
    	echo "success"
	else
    	echo "fail and exit"
		exit 0
	fi
}

if [ -z $1 ]; then 
	echo 'WARNING: Please input version to download, eg: 23.0.2, if unsure please check nextcloud updater app for latest version.'
	exit 0
fi

export DATE=$(date +%m-%d-%Y@%R)

echo -e "\n" $DATE

echo  -e "\n" "****create nextcloud backup folder by cp command"
if [ -d /var/www/nextcloud ]; then 
	cp -r /var/www/nextcloud /var/www/nextcloud_bak_$DATE
    mv /var/www/nextcloud /var/www/.nextcloud_hid
    job_fail
else
    echo "nextcloud folder is not present"
    exit 0
fi

echo -e "\n" "stopping webserver"
systemctl stop nginx

echo downloading nextcloud latest package
wget https://download.nextcloud.com/server/releases/nextcloud-$1.zip

echo -e "\n" unzipping file
unzip nextcloud-$1.zip

echo -e "\n" copying config from backup nextcloud file
cp /var/www/nextcloud_bak_$DATE/config/config.php ./nextcloud/config/config.php

echo -e "\n" setting permission
cd /var/www
chown -R www-data:www-data nextcloud
find nextcloud/ -type d -exec chmod 750 {} \;
find nextcloud/ -type f -exec chmod 640 {} \;

echo -e "\n" starting webserver
systemctl start nginx

echo -e "\n" upgrading nextcloud through occ command
cd /var/www/nextcloud && sudo -u www-data php occ upgrade
echo "Delete the hidden backup files .nextcloud_hid?"

select option in yes no
do
    case $option in 
        "yes")
            rm -r ./.nextcloud_hid
            ;;
        "no")
            echo "Hidden backup files will be remained"
            exit 0
            ;;
    esac
done
