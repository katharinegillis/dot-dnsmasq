#!/usr/bin/env bash

PKG_PATH=$2
SYSTEM=$3

if [ ! -d "$HOME/utils" ]; then
    mkdir "$HOME/utils"
fi

cd "$HOME/utils" || return

git clone git@github.com:katharinegillis/docker-dnsmasq.git dnsmasq

if ! grep -Fxq "# .docker local urls" "$HOME/utils/dnsmasq/dnsmasq.conf"; then
    echo "# .docker local urls" >> $HOME/utils/dnsmasq/dnsmasq.conf
    echo "address=/.docker/127.0.0.1" >> $HOME/utils/dnsmasq/dnsmasq.conf
fi

if [ "$SYSTEM" == "linux" ]; then
    if [ ! -d /etc/systemd/resolved.conf.d ]; then
        sudo mkdir /etc/systemd/resolved.conf.d
    fi
    sudo cp "$PKG_PATH/config/noresolved.conf" /etc/systemd/resolved.conf.d/noresolved.conf
    sudo systemctl restart systemd-resolved

    sudo rm /etc/resolv.conf

    echo "nameserver 127.0.0.1" | sudo tee /etc/resolv.conf
    echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf

    sudo cp "$PKG_PATH/config/disableresolv.conf" /etc/NetworkManager/conf.d/disableresolv.conf
    sudo systemctl restart NetworkManager
else
    echo "\e[33mPlease ensure your DNS resolver is pointed to 127.0.0.1 as preferred.\e[0m"
fi

cd "$HOME/utils/dnsmasq" || return
docker-compose up -d