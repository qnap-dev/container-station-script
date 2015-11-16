#!/bin/sh

ps aux > /tmp/ps.txt
ls -al /share/CACHEDEV?_DATA/.qpkg/container-station/* > /tmp/ls.txt

supervisorctl -c /share/CACHEDEV?_DATA/.qpkg/container-station/etc/supervisord.conf status > /tmp/supervisor-status.log
ls -R /share/CACHEDEV?_DATA/.qpkg/container-station/etc/ > /tmp/ls-etc.txt
ls -l /share/CACHEDEV?_DATA/.qpkg/container-station/var/* > /tmp/ls-var.txt

docker ps -a > /tmp/docker-ps.txt
docker images > /tmp/docker-image.txt

tar cjvfh container-station-log.tbz \
    /etc/platform.conf \
    /etc/default_config/uLinux.conf \
    /etc/config/uLinux.conf \
    /etc/config/qpkg.conf \
    /tmp/{ps,ls}.txt \
    /tmp/ls-*.txt \
    /tmp/docker-*.txt \
    /var/log/container-station/* \
    /etc/qbus
