#Download base image ubuntu 20.04
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update Ubuntu Software repository
RUN apt-get update

# Install dependencies
RUN apt-get install -y wget apt-utils
RUN wget https://apt.kitware.com/kitware-archive.sh
RUN bash kitware-archive.sh
RUN apt-get install -y --no-install-recommends git cmake ninja-build gperf \
    ccache dfu-util device-tree-compiler wget \
    python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
    make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1

# Create user
RUN useradd -rm -d /home/zduser -s /bin/bash -g root -G sudo -u 1001 zduser
RUN groupadd -g 986 uucp_dk && addgroup zduser uucp_dk
USER zduser
WORKDIR /home/zduser

# Install west
RUN pip3 install --user -U west
ENV PATH="/home/zduser/.local/bin:${PATH}"
# ENV ZEPHYR_BASE=$HOME/zephyrproject/zephyr

# Get Zephyr
RUN west init ~/zephyrproject && cd ~/zephyrproject && west update && west zephyr-export && pip3 install --user -r ~/zephyrproject/zephyr/scripts/requirements.txt

RUN wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.14.2/zephyr-sdk-0.14.2_linux-x86_64.tar.gz && wget -O - https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.14.2/sha256.sum | shasum --check --ignore-missing && tar xvf zephyr-sdk-0.14.2_linux-x86_64.tar.gz

#probar WORKDIR
RUN cd zephyr-sdk-0.14.2 && ./setup.sh -t all -h -c

RUN cd $HOME/zephyrproject/zephyr && west update && west espressif install && west espressif update

RUN mkdir /home/zduser/zephyrproject/zephyr/Projects

VOLUME ["/home/zduser/zephyrproject/zephyr/Projects"]

CMD ["/bin/bash"]