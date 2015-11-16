# container-station-script

Ssh to NAS, then run the following command
```
cd /share/Public && \
    curl -k -o- https://raw.githubusercontent.com/qnap-dev/container-station-script/master/debug.sh | sh
```

Copy ```/share/Public/container-station-log.tbz``` back
