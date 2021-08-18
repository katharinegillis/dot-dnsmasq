#!/usr/bin/env bash

SYSTEM=$3

if [ ! -d "$HOME/utils" ]; then
    mkdir "$HOME/utils"
fi

cd "$HOME/utils" || return

git clone git@github.com:katharinegillis/docker-dnsmasq.git dnsmasq

echo "# .docker local urls" >> $HOME/utils/dnsmasq/dnsmasq.conf
echo "address=/.docker/127.0.0.1" >> $HOME/utils/dnsmasq/dnsmasq.conf

if [ "$SYSTEM" == "linux" ]; then
    sudo systemctl disable systemd-resolved
    sudo systemctl stop systemd-resolved
    sudo rm /etc/resolv.conf

    echo "nameserver 127.0.0.1" | sudo tee /etc/resolv.conf
    echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
else
    echo "\e[33mPlease ensure your DNS resolver is pointed to 127.0.0.1 as preferred.\e[0m"
fi

cd "$HOME/utils/dnsmasq" || return
docker-compose up -d