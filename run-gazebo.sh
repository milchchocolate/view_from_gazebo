#!/bin/bash

xhost +local:root

# build docker image
    # --rm                 \
    # --force-rm           \
    # --compress           \
docker build             \
    --network="host"     \
    --tag gazebo-vm      \
    .

# run docker
docker run                    \
    --rm                      \
    --net="host"              \
    -e DISPLAY=unix$DISPLAY   \
    -it                       \
    --name "gazebo-vm"        \
    --entrypoint "/bin/bash"  \
    --volume "${PWD}/vm_shared/.gazebo":"/root/.gazebo"  \
    --volume "${PWD}/vm_shared/worlds":"/root/worlds"    \
    --volume "${PWD}/vm_shared/models":"/root/models"    \
    --volume "${PWD}/vm_shared/plugins":"/root/plugins"  \
    --volume "${PWD}/vm_shared/src":"/root/src"          \
    --volume "${PWD}/vm_shared/.vscode":"/root/.vscode"  \
    --volume "/tmp/.X11-unix":"/tmp/.X11-unix:rw"        \
    gazebo-vm

xhost -local:root

# ===============================================================
# Open additional bash terminal to the vm while it is running:
#   docker exec -it gazebo-vm bash
#
# Ref: https://docs.docker.com/engine/reference/commandline/exec/
