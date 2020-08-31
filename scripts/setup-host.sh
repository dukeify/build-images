#!/bin/bash

PREVIOUS_CWD="$(pwd)"
TARGET_GROUP="$1"
if [[ ! -n "$TARGET_GROUP" ]]; then
 printf 'You must supply the desired group to configure for:\n%s\n' "$(ls docker/)"
 exit -1
fi

#Install dependencies 
yay -Sy --noconfirm --sudoloop qemu-user-static-bin docker pigz
yay -Sy --noconfirm --sudoloop binfmt-qemu-static

#Configure binfmt and start docker
sudo systemctl enable systemd-binfmt
sudo systemctl start systemd-binfmt

#Start docker and confirm that it is functioning
source ~/build-images/scripts/common/start_docker.sh

#Return to previous CWD
cd "$PREVIOUS_CWD"
