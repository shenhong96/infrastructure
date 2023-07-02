#!/bin/bash
iptables -I INPUT -p TCP --dport 2278 -j ACCEPT
iptables -I INPUT -p TCP --dport 443 -j ACCEPT
iptables -I INPUT -p TCP -i br-f84234396689 --dport 3300 -j ACCEPT
iptables -I INPUT -p TCP -i br-f84234396689 --dport 8080 -j ACCEPT