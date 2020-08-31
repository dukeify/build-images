#!/bin/bash

PREVIOUS_CWD="$(pwd)"
TARGET_GROUP="$1"
if [[ ! -n "$TARGET_GROUP" ]]; then
 printf 'You must supply the desired group to configure for:\n%s\n' "$(ls docker/)"
 exit -1
fi

#Install docker
yay -Sy --noconfirm --sudoloop docker
sudo dockerd 2>&1 > /dev/null &

#Enable desired architectures
#TODO other groups will require special logic
#cd docker/$TARGET_GROUP
#for image in $(ls); do
# target_arch=$(echo "$image" | cut -d- -f1)
# update-binfmts --enable "qemu-$target_arch"
#done

#Start and login to docker
#systemctl start docker
sudo ~/login_to_dockerhub.sh

#Return to previous CWD
cd "$PREVIOUS_CWD"
