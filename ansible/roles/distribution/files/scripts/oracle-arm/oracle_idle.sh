#!/bin/bash
# This script was to prevent oracle shutting down our instance due to no traffics
cd /tmp
wget https://cdimage.ubuntu.com/ubuntustudio/releases/22.04.2/release/ubuntustudio-22.04.2-dvd-amd64.iso
sleep 10
rm ubuntustudio-22.04.2-dvd-amd64.iso
echo "Idle abolishment completed on $(date)" >> /opt/idle_sh.log