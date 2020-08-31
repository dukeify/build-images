#!/bin/bash

PREVIOUS_CWD="$(pwd)"
TARGET_GROUP="$1"
if [[ ! -n "$TARGET_GROUP" ]]; then
 printf 'You must supply the desired group to configure for:\n%s\n' "$(ls docker/)"
 exit -1
fi

#Install dependencies 
yay -Sy --noconfirm --sudoloop qemu-user-static-bin docker
yay -Sy --noconfirm --sudoloop binfmt-qemu-static

#Configure binfmt and start docker
sudo systemctl enable systemd-binfmt
sudo systemctl start systemd-binfmt
sudo dockerd 2>&1 > /dev/null &

#Login to docker
sudo ~/login_to_dockerhub.sh

#Return to previous CWD
cd "$PREVIOUS_CWD"
