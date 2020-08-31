#Start docker and login if it isn't running
export LOGGED_IN_TO_DOCKERHUB=1

function is_docker_running() {
 if [ ! -n "$(ps -a | grep -i docker | awk '{ print $4 }')" ]; then
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

if [[ "$(is_docker_running)" == 1 ]]; then
 #Start docker and confirm that the daemon has started
 sudo dockerd 2>&1 > /dev/null &
 assert_docker_is_running
 #Login to dockerhub if the secret is present
 if [ -f ~/login_to_dockerhub.sh ]; then
  export LOGGED_IN_TO_DOCKERHUB=0
  sudo ~/login_to_dockerhub.sh
 fi
fi
