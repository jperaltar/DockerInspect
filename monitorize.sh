#!/bin/bash

while IFS='' read -r line || [[ -n "$line" ]]; do
    echo "Container name: $line"
    echo "    Image: $(docker inspect -f='{{json .Config.Image}}' $line)"
    network=$(docker inspect -f='{{json .HostConfig.NetworkMode}}' $line | sed -e 's/^"//' -e 's/"$//')
    ip=$(docker inspect -f='{{json .NetworkSettings.Networks.'"$network"'.IPAddress}}' $line | sed -e 's/^"//' -e 's/"$//')
    echo "    IP: $ip"
    echo "    Docker network: $network"
    #echo "$(sshpass -p docker ssh docker@$ip cat /proc/cpuinfo)"
done < "$1"
