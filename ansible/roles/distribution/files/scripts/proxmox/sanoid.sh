#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
sanoid 
if [[ $? -gt 0 ]]; then
   ls /var/run/ | grep 'sanoid.*\.lock' | xargs -i rm /var/run/{}
   echo "triggered at $(date)" >> /var/log/sanoid.sh
fi
