#!/bin/bash

PREVIOUS_CWD="$(pwd)"
TARGET_GROUP="$1"
if [[ ! -n "$TARGET_GROUP" ]]; then
 printf 'You must supply the desired group to configure for:\n%s\n' "$(ls docker/)"
 exit -1
fi

#Install dependencies 
yay -Sy --noconfirm --sudoloop qemu-user-static-bin docker pigz wget
yay -Sy --noconfirm --sudoloop binfmt-qemu-static

#Configure binfmt and start docker
sudo systemctl enable systemd-binfmt
sudo systemctl stop systemd-binfmt
#Disable outdated binfmt configuration
for dir in /lib/binfmt.d/ /usr/lib/binfmt.d/ /usr/local/lib/binfmt.d/ /etc/binfmt.d/; do
 if [[ -d "$dir" ]]; then
  echo "Found binfmt configuration directory: $dir"
  cd "$dir"
  for old_config in $(ls | grep -i '.conf' | grep -vi '.conf.disabled'); do
   printf 'Disabling old config: %s\n' "$dir$old_config"
   sudo mv "$old_config" "$old_config.disabled"
  done
 fi
done
cd "$PREVIOUS_CWD"
#Generate new binfmt configuration from qemu/master
wget https://raw.githubusercontent.com/qemu/qemu/master/scripts/qemu-binfmt-conf.sh
chmod +x qemu-binfmt-conf.sh
sudo ./qemu-binfmt-conf.sh --credential=yes --persistent=yes --systemd ALL --exportdir /etc/binfmt.d/ --qemu-path /usr/bin --qemu-suffix -static
#Start systemd-binfmt service
sudo systemctl start systemd-binfmt

#Add 'build' user to 'docker' so it can use docker 
#source ~/build-images/scripts/common/start_docker.sh
sudo usermod -aG docker build 

#Return to previous CWD
cd "$PREVIOUS_CWD"
