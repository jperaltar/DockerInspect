#!/bin/bash

while IFS='' read -r line || [[ -n "$line" ]]; do
    echo "Container name: $line"
    echo "    Image: $(sudo docker inspect -f='{{json .Config.Image}}' $line)"
    network=$(sudo docker inspect -f='{{json .HostConfig.NetworkMode}}' $line | sed -e 's/^"//' -e 's/"$//')
    ip=$(sudo docker inspect -f='{{json .NetworkSettings.Networks.'"$network"'.IPAddress}}' $line | sed -e 's/^"//' -e 's/"$//')
    echo "    IP: $ip"
    echo "    Docker network: $network"
    echo "    $(sshpass -p docker ssh docker@$ip cat /proc/cpuinfo | grep -m 1 'model name')"
    echo "    $(sshpass -p docker ssh docker@$ip cat /proc/cpuinfo | grep -m 1 'cpu cores')"
done < "$1"
