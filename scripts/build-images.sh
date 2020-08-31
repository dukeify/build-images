#!/bin/bash

PREVIOUS_CWD="$(pwd)"
TARGET_GROUP="$1"
if [[ ! -n "$TARGET_GROUP" ]]; then
 printf 'You must supply the desired image group to build:\n%s\n' "$(ls docker/)"
 exit -1
fi

#Start docker and login if it isn't running
source common/start_docker.sh

#Build all images in group
cd docker/$TARGET_GROUP
for image in $(ls); do
 suffix="$(echo "$image" | cut -d. -f1)"
 tag="dukeify/build-images:$suffix"
 printf 'Building "%s" as and tagging as "%s"\n' "$image" "$tag"
 sudo docker build -t "$tag" -f "$image" .
done

#Return to previous CWD 
cd "$PREVIOUS_CWD" 
