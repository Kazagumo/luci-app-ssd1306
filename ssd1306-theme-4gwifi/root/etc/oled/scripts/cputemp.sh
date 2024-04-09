echo 温度:$(expr $(cat /sys/class/thermal/thermal_zone2/temp) / 1000)℃
