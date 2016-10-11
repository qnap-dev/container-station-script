#!/bin/sh

ps aux > /tmp/ps.txt
ls -al /share/CACHEDEV?_DATA/.qpkg/container-station/* > /tmp/ls.txt

supervisorctl -c /share/CACHEDEV?_DATA/.qpkg/container-station/etc/supervisord.conf status > /tmp/supervisor-status.log
ls -R /share/CACHEDEV?_DATA/.qpkg/container-station/etc/ > /tmp/ls-etc.txt
ls -l /share/CACHEDEV?_DATA/.qpkg/container-station/var/* > /tmp/ls-var.txt
lsof -ni TCP|grep LISTEN > /tmp/listen-ports.txt

# disk
df > /tmp/df.txt
#du --max-depth=3 --exclude=/sys -exclude=/share --exclude=/proc --exclude=/mnt --exclude=/dev -h -a / > /tmp/du-1.txt
#echo "This may spend a long time..."
#du --max-depth=2 -h -a /share > /tmp/du-2.txt

# lxc
lxc-ls -f > /tmp/lxc.txt

# docker
docker ps -a > /tmp/docker-ps.txt
docker images > /tmp/docker-image.txt

# kernel version
uname -a > /tmp/kernel.txt

# env
env > /tmp/env.txt

# network
ip a > /tmp/ip_addr.txt
ip route > /tmp/ip_route.txt
brctl show > /tmp/bridge.txt
curl -m 10 http://google.com > /tmp/curl_test.txt

# Linux Station 
if [ -n "$(getcfg ubuntu-hd Install_Path -f /etc/config/qpkg.conf -d "")" ]; then
    installpath=$(getcfg ubuntu-hd Install_Path -f /etc/config/qpkg.conf -d "")
    logfile=/tmp/ubuntu.txt
    exec 6>&1
    exec > $logfile
    lxc-attach -P ${installpath}/lxc -n ubuntu-hd -- bash -c "sudo -u root -i service x11vnc status"
    lxc-attach -P ${installpath}/lxc -n ubuntu-hd -- bash -c "sudo -u root -i service novnc status"
    lxc-attach -P ${installpath}/lxc -n ubuntu-hd -- bash -c "ip a"
    lxc-attach -P ${installpath}/lxc -n ubuntu-hd -- bash -c "netstat -ntulp"
    echo "# curl http://127.0.0.1:6055/"
    curl http://127.0.0.1:6055/
    echo "# curl http://127.0.0.1:8080/ubuntu-hd/"
    curl http://127.0.0.1:8080/ubuntu-hd/
    echo "# curl http://127.0.0.1:8080/ubuntu-hd-vnc/"
    curl http://127.0.0.1:8080/linux-station-vnc/
    echo "# QBUS"
    qbus get com.qnap.hd-station/system
    qbus get com.qnap.hd-station/config
    exec 1>&6 6>&-
fi

tar cjvfh container-station-log.tbz \
    /etc/platform.conf \
    /etc/default_config/uLinux.conf \
    /etc/config/uLinux.conf \
    /etc/config/qpkg.conf \
    /etc/config/br.conf \
    /etc/config/vswitch.conf \
    /tmp/{ps,ls}.txt \
    /tmp/ls-*.txt \
    /tmp/lxc.txt \
    /tmp/docker-*.txt \
    /tmp/listen-ports.txt \
    /tmp/bridge.txt \
    /tmp/ip_addr.txt \
    /tmp/ip_route.txt \
    /tmp/kernel.txt \
    /var/log/container-station/* \
    /var/log/network/* \
    /etc/qbus \
    /tmp/curl_test.txt \
    /tmp/df.txt \
    /tmp/ubuntu.txt \
    /etc/apache-container.conf /etc/apache-sys-proxy.conf /etc/container-proxy.d/
