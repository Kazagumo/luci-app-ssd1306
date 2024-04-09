#/bin/bash
#echo "我让你飞起来"
num=$(ubus call hostapd.phy0-ap0 get_clients | jq '.["clients"]' | jq length)
if [ -z num ]; then
	echo ""
else
	echo $num 已连接
fi
