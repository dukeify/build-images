#!/bin/bash

PREVIOUS_CWD="$(pwd)"
TARGET_GROUP="$1"
if [[ ! -n "$TARGET_GROUP" ]]; then
 printf 'You must supply the desired image group to publish:\n%s\n' "$(ls docker/)"
 exit -1
fi

#Start docker and login if it isn't running
source ~/build-images/scripts/common/start_docker.sh

#Publish to dockerhub and collect images to export
TO_EXPORT=""
cd docker/$TARGET_GROUP
for image in $(ls); do
 image="$(echo "$image" | cut -d. -f1)"
 tagged_image="dukeify/build-images:$image"
 TO_EXPORT="$tagged_image $TO_EXPORT"
 #Publish if logged into dockerhub 
 if [ "$(is_logged_in)" == 0 ]; then
  printf 'Publishing: %s\n' "$tagged_image"
  docker push "$tagged_image"
 else
  printf 'Not logged into Dockerhub, not publishing images\n'
 fi
done 

#Export all images and compress
#Trim excess whitespace
TO_EXPORT="$(echo "$TO_EXPORT" | awk '{$1=$1};1')"
cd /home/build/build-images
printf 'Exporting images: %s\n' "$TO_EXPORT"
docker save -o dukeify-all.tar $TO_EXPORT
pigz --fast dukeify-all.tar

#Return to previous CWD
cd "$PREVIOUS_CWD"
