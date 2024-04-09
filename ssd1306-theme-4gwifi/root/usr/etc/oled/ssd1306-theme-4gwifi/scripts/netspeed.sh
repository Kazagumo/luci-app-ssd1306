#!/bin/ash
IF=$1
if [ -z "$IF" ]; then
        IF=`ls -1 /sys/class/net/ | head -1`
fi
RXPREV=-1
TXPREV=-1
echo "Listening $IF..."
while [ 1 == 1 ] ; do
        RX=`cat /sys/class/net/${IF}/statistics/rx_bytes`
        TX=`cat /sys/class/net/${IF}/statistics/tx_bytes`
        if [ $RXPREV -ne -1 ] ; then
                #let BWRX=$(expr $(expr $RX - $RXPREV) / 8)
                #let BWTX=$(expr $(expr $TX - $TXPREV) / 8)
		let BWRX=$RX-$RXPREV
		let BWTX=$TX-$TXPREV
		if [ $BWRX -lt 1000 ]; then
			BWRX="$BWRX"B/s
		elif [ $BWRX -gt 1000 ] && [ $BWRX -lt 1000000 ]; then
			BWRX="$(expr $BWRX / 1000)KB/s"
		elif [ $BWRX -gt 1000000 ]; then
			BWRX="$(expr $BWRX / 1000000)MB/s"
		fi
		if [ $BWTX -lt 1000 ]; then
			BWTX="$BWTX"B/s
		elif [ $BWTX -gt 1000 ] && [ $BWTX -lt 1000000 ]; then
			BWTX="$(expr $BWTX / 1000)KB/s"
		elif [ $BWTX -gt 1000000 ]; then
			BWTX="$(expr $BWTX / 1000000)MB/s"
		fi
                echo "↑$BWTX">/tmp/oled/netspeed_tx
		echo "↓$BWRX">/tmp/oled/netspeed_rx
        fi
        RXPREV=$RX
        TXPREV=$TX
        sleep 1
done
