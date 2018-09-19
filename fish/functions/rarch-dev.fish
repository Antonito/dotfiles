# Run a Docker container, containing all the development tools
function rarch-dev
    begin
        set -l HOSTNAME "archlinux"
        set -l LOCAL_CODE_DIRECTORY "$HOME/Documents"
        set -l REMOTE_CODE_DIRECTORY "/root/code"
        set -l DOCKER_IMAGE "antoinebache/archlinux"

        docker run -it --rm --hostname $HOSTNAME -v /var/run/docker.sock:/var/run/docker.sock -v $LOCAL_CODE_DIRECTORY:$REMOTE_CODE_DIRECTORY $DOCKER_IMAGE
    end
end
