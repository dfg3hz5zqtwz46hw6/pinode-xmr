#!/bin/bash
#IP tables rule for Tor
sudo iptables -I OUTPUT -p tcp -d 127.0.0.1 -m tcp --dport 18081 -j ACCEPT


#Establish IP
	DEVICE_IP="$(hostname -I)"
	echo "Your PiNode-XMR IP is: ${DEVICE_IP}"
	sleep "1"
#Download update file
	sleep "1"
	wget -q https://raw.githubusercontent.com/shermand100/pinode-xmr/master/xmr-new-ver.sh -O xmr-new-ver.sh
	echo "Version Info recieved:"
#Permission Setting
	chmod 755 /home/pinodexmr/current-ver.sh
	chmod 755 /home/pinodexmr/xmr-new-ver.sh
#Load Variables
. /home/pinodexmr/current-ver.sh
. /home/pinodexmr/xmr-new-ver.sh
. /home/pinodexmr/monero-port.sh
echo $NEW_VERSION 'New Version'
echo $CURRENT_VERSION 'Current Version'
echo $DEVICE_IP 'Device IP'
echo $MONERO_PORT 'Monero Port'
sleep "3"
if [ $CURRENT_VERSION -lt $NEW_VERSION ]
then
	sh /home/pinodexmr/monerod-exit.sh
	echo "stop command sent"
	rm -rf ./monero
	echo "Deleting Old Version"
	sleep "2"
	mkdir monero
	wget https://downloads.getmonero.org/cli/linuxarm7
	tar -xvf ./linuxarm7 -C ./monero --strip 2
	echo "Software Update Complete - Resuming Node"
	sleep "2"
	sh /home/pinodexmr/monerod-start.sh
	echo "Monero Node Started in background"
	echo "Tidying up leftover installation packages"
	#Clean-up stage
	#Update system version number
	echo "#!/bin/bash
CURRENT_VERSION=$NEW_VERSION" > current-ver.sh
	#Remove downloaded version check file
	rm /home/pinodexmr/xmr-new-ver.sh
	rm /home/pinodexmr/linuxarm7
else
	echo "Your node is up to date"
#Start Node
sh /home/pinodexmr/monerod-start.sh
fi


	
echo "Script complete - PiNode-XMR booted successfully"

#Notes:
#