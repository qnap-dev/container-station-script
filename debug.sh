#!/bin/sh

ps aux > /tmp/ps.txt
ll /share/CACHEDEV?_DATA/.qpkg/container-station/* > /tmp/ls.txt

tar cjvf container-station-log.tbz \
    /etc/platform.conf \
    /etc/default_config/uLinux.conf \
    /etc/config/uLinux.conf \
    /etc/config/qpkg.conf \
    /tmp/{ps,ls}.txt \
    /var/log/container-station
