#!/bin/bash

if [[ $1 == "build" ]]; then
    if [[ $2 == "base" ]]; then
        docker build -t zephyr_build -f Dockerfile .
    elif [[ $2 == "esp32" ]]; then
        echo "Building for ESP32..."
        docker build -t zephyr_build_esp32 -f Dockerfile.esp32 .
    elif [[ -n $2 ]]; then
        echo "Board not yet supported"
        exit -1
    else
        echo "Provide board argument:"
        echo "    base      -> build base image"
        echo "    esp32     -> build base image and extensions for Espressif's ESP32 boards"
        exit -1
    fi
elif [[ $1 == "root" ]]; then
    docker run -v $(pwd)/Projects/:/home/zduser/zephyrproject/zephyr/Projects -itu root zephyr_build_esp32:latest
else
    docker run --device=/dev/ttyUSB0 -v $(pwd)/Projects/:/home/zduser/zephyrproject/zephyr/Projects -it zephyr_build_esp32:latest
fi
