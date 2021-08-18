#!/usr/bin/env bash

cd "$HOME/utils/dnsmasq" || return
docker-compose down
cd "$HOME" || return
rm -rf "$HOME/utils/dnsmasq"