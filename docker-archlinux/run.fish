#!/usr/bin/env fish

set HOSTNAME "archlinux"
set LOCAL_CODE_DIRECTORY "$HOME/Documents"
set REMOTE_CODE_DIRECTORY "/root/code"
set DOCKER_IMAGE "antoinebache/archlinux"

docker run -it --rm --hostname $HOSTNAME -v /var/run/docker.sock:/var/run/docker.sock -v $LOCAL_CODE_DIRECTORY:$REMOTE_CODE_DIRECTORY $DOCKER_IMAGE
