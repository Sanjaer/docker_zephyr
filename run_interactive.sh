#!/bin/bash

if [[ $1 == "build" ]]; then
    docker build -t zephyr_build .
elif [[ $1 == "root" ]]; then
    docker run -v $(pwd)/Projects/:/home/zduser/zephyrproject/zephyr/Projects -itu root zephyr_build:latest
else
    docker run --device=/dev/ttyUSB0 -v $(pwd)/Projects/:/home/zduser/zephyrproject/zephyr/Projects -it zephyr_build:latest
fi
