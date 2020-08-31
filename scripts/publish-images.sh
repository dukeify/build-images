#!/bin/bash

PREVIOUS_CWD="$(pwd)"
TARGET_GROUP="$1"
if [[ ! -n "$TARGET_GROUP" ]]; then
 printf 'You must supply the desired image group to publish:\n%s\n' "$(ls docker/)"
 exit -1
fi

#Tag all images and publish to dockerhub
cd docker/$TARGET_GROUP
for image in $(ls); do
 image="$(echo "$image" | cut -d. -f1)"
 to_publish="dukeify/build-images:$image"
 printf 'Publishing: %s\n' "$to_publish"
 docker push "$to_publish"
done

#Return to previous CWD
cd "$PREVIOUS_CWD"
