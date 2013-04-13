#!/bin/bash 
echo ""
echo "SCRIPT NAME:  DyRoute"
echo "BASH VERSION: ${BASH_VERSION}"
echo ""
echo "-------------------------------------------------------------------------"
echo ""

# define array with interfaces
NIC[0]="eth0"
NIC[1]="wlan0"

# define array with regular expressions - search parameters - Network ID
RULES[0]="10.1.1.0/24"
RULES[1]="192.168.1.0/24"

# define routes for submission
ROUTES[0]="route add -net 10.10.10.0 netmask 255.255.0.0 gw 10.1.1.25"
ROUTES[1]="route add -net 192.168.100.0 netmask 255.255.255.0 gw 192.168.1.254"

# array length
N=${#NIC[@]}

# array iteration
for (( i=0; i<${N}; i++ ))
do
	echo "[  INFO   ] SELECTED NIC: ${NIC[$i]}"
	NETWORK_ID=`ip addr show dev wlan0 | sed -nr 's/.*inet ([^ ]+).*/\1/p' | sed 's/[0-9]\{1,3\}\(\/.*\)$/0\1/'`
	echo "[  INFO   ] NETWORK ID:   ${NETWORK_ID}"
	if [ ${RULES[$i]} == $NETWORK_ID ]; then
		echo "[  INFO   ] NETWORK FOUNDED"
		`${ROUTES[$i]}`
		PRINT=`echo "${ROUTES[$i]}" | sed 's/.*-net \(.*\) netmask.*gw \(.*\)$/\1 via \2/'`
		echo "[ SUCCESS ] ROUTE ADDED:  ${PRINT}"
	else
		echo "[  ERROR  ] NETWORK NOT FOUNDED"
	fi
done

echo "[  EXIT   ] SCRIPT COMPLETED"
echo ""
echo "-------------------------------------------------------------------------"
echo ""

exit 0
