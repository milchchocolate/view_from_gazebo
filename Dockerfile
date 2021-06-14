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
    gnupg software-properties-common \
    wget curl

# cmake
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null \
    && apt-add-repository 'deb https://apt.kitware.com/ubuntu/ focal main' \
    && apt-get install --yes kitware-archive-keyring \
    && rm /etc/apt/trusted.gpg.d/kitware.gpg \
    && apt-get install --yes cmake

# clang
RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

# packages
RUN apt-get install --yes \
    bash-completion \
    build-essential \
    git \
    libboost-dev \
    libceres-dev \
    libeigen3-dev \
    libopencv-dev \
    tree

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
