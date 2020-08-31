#!/bin/bash

#Enable desired architectures
for image in $(ls docker/linux/); do
 target_arch=$(echo "$image" | cut -d- -f1)
 update-binfmts --enable "qemu-$target_arch"
done

#Start and login to docker
systemctl start docker
~/login_to_dockerhub.sh
