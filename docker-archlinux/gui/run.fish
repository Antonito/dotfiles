#!/usr/bin/env fish

set HOSTNAME "archlinux"
set LOCAL_CODE_DIRECTORY "$HOME/Documents"
set REMOTE_CODE_DIRECTORY "/root/code"
set DOCKER_IMAGE "antoinebache/archlinux-gui"

set X11_IP (ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')

docker run -it --rm --hostname $HOSTNAME -p 5901:5901 -v /var/run/docker.sock:/var/run/docker.sock -v $LOCAL_CODE_DIRECTORY:$REMOTE_CODE_DIRECTORY $DOCKER_IMAGE
