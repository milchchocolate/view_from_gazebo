FROM gazebo:libgazebo11-focal
# FROM gazebo:libgazebo9-bionic
# FROM nvidia/driver:460.73.01-ubuntu20.04
# FROM nvidia/cuda:11.3.1-devel-ubuntu20.04

# essentials
RUN apt-get update \
    && apt-get upgrade --yes \
    && apt-get install --yes \
    ca-certificates \
    apt-transport-https \
    apt-utils \
    gpg gnupg software-properties-common \
    wget curl

# cmake
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null \
    && echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null \
    && apt-get update \
    && rm /usr/share/keyrings/kitware-archive-keyring.gpg \
    && apt-get install --yes kitware-archive-keyring \
    && apt-get install --yes \
    cmake \
    cmake-curses-gui \
    cmake-qt-gui

# clang / llvm
RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
RUN apt-get install --yes \
    clang-format \
    clang-tidy \
    iwyu

# packages
RUN apt-get update \
    && apt-get install --yes \
    auto-complete-el \
    bash-completion \
    build-essential \
    cppcheck \
    git \
    libboost-dev \
    libceres-dev \
    libeigen3-dev \
    libopencv-dev \
    locate \
    tree

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install --yes \
    iputils-ping

# graphics
RUN apt update \
    && apt install --yes \
    xserver-xorg-video-intel xserver-xorg-core \
    mesa-utils libgl1-mesa-glx

# cleanup
RUN apt autoremove --yes \
    && apt autoclean --yes

# create shared dirs
RUN mkdir -p /root/.gazebo
RUN mkdir -p /root/models
RUN mkdir -p /root/worlds
RUN mkdir -p /root/src

# use local bashrc
COPY .bash_custom /root/
RUN echo "source ~/.bash_custom" > ~/.bashrc

# path on entry
WORKDIR /root/
