#!/bin/bash
while [ 1 = 1 ]; do
SIGNAL=$(mmcli -J -m any | jq -r '.["modem"]["generic"]["signal-quality"]["value"]')
if [ -z $SIGNAL ]; then 
    echo "正在搜索.." > /tmp/oled/signal
    sleep 1
elif [ $SIGNAL = 0 ]; then
    echo "离线" > /tmp/oled/signal
    sleep 1
else
    echo "$SIGNAL%" > /tmp/oled/signal
    sleep 5
fi
done
