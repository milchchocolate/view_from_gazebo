#!/bin/bash

xhost +local:root

if [ ! -f ${PWD}/vm_shared/.bash_history ]; then
    touch ${PWD}/vm_shared/.bash_history
fi

docker build             \
    --network="host"     \
    --tag gazebo-vm      \
    .

# run docker
docker run                    \
    --rm                      \
    --net="host"              \
    -e DISPLAY=unix$DISPLAY   \
    -e TZ="Europe/Berlin"     \
    -it                       \
    --name "gazebo-vm"        \
    --entrypoint "/bin/bash"  \
    --volume "${PWD}/vm_shared/.bash_history":"/root/.bash_history"  \
    --volume "${PWD}/vm_shared/.gazebo":"/root/.gazebo"              \
    --volume "${PWD}/vm_shared/worlds":"/root/worlds"                \
    --volume "${PWD}/vm_shared/models":"/root/models"                \
    --volume "${PWD}/vm_shared/plugins":"/root/plugins"              \
    --volume "${PWD}/vm_shared/src":"/root/src"                      \
    --volume "${PWD}/vm_shared/.vscode":"/root/.vscode"              \
    --volume "/tmp/.X11-unix":"/tmp/.X11-unix:rw"                    \
    gazebo-vm

xhost -local:root

# ===============================================================
# Open additional bash terminal to the vm while it is running:
#   docker exec -it gazebo-vm bash
#
# Ref: https://docs.docker.com/engine/reference/commandline/exec/
