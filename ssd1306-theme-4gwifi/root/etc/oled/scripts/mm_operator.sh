while [ 1 = 1 ];do
OPINFO=$(mmcli -m any -J | jq -r '.["modem"]["3gpp"]["operator-name"]')
SPEEDINFO=$(mmcli -m any -J | jq -r '.["modem"]["generic"]["access-technologies"][0]')
if [ $SPEEDINFO = "null" ]; then
	echo 无服务 > /tmp/oled/operator
	sleep 1
else
	echo $OPINFO $SPEEDINFO > /tmp/oled/operator
	sleep 5
fi
done
