#!/bin/bash

if [[ $1 == "root" ]]; then
    docker run -v /home/sanjo/Programs/docker_zephyr/Projects/:/home/zduser/zephyrproject/zephyr/Projects -itu root zephyr_build:latest
else
    docker run --device=/dev/ttyUSB0 -v /home/sanjo/Programs/docker_zephyr/Projects/:/home/zduser/zephyrproject/zephyr/Projects -it zephyr_build:latest
fi
