#!/bin/bash

#Start docker and login if it isn't running
export LOGGED_IN_TO_DOCKERHUB=1

function is_docker_running() {
 if [ -n "$(ps -a | grep -i docker | awk '{ print $4 }')" || -f "/var/run/docker.pid" ]; then
  echo 0
 else
  echo 1
 fi
}

function assert_docker_is_running() {
 if [ "$(is_docker_running)" != 0 ]; then
  printf 'FATAL: Failed to start docker daemon'
  exit -1
 fi
}

function is_logged_in() {
 if [ "$(is_docker_running)" == 0 ]; then
  if [ -f "/home/build/.docker/config.json" ]; then
   echo 0
   return
  fi
 fi
 echo 1
}

if [[ "$(is_docker_running)" == 1 ]]; then
 #Start docker and confirm that the daemon has started
 printf 'Starting docker\n'
 sudo dockerd 2>&1 > /dev/null &
 sleep 5
 assert_docker_is_running
 #Login to dockerhub if the secret is present
 if [ -f /home/build/login_to_dockerhub.sh ]; then
  export LOGGED_IN_TO_DOCKERHUB=0
  /home/build/login_to_dockerhub.sh
 fi
else
 printf 'Docker is already running\n'
fi
