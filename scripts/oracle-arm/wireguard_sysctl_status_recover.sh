#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
systemctl status wg-quick@wg0.service | grep 'Active: failed'
wg_status=$(echo $?)

[ $wg_status -eq 0 ] && systemctl restart wg-quick@wg0.service || echo "already working" && exit 0
