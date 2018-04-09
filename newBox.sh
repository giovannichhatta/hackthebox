#!/bin/bash

boxName=$1;
IP=$2;
dir=$1-$2;
rootdir="/root/hackthebox";

function empty {
	if [[ $(echo $1 | wc -m) == 1 ]]; then
		echo "Usage: ./newHTB.sh [boxname] [IP address]";
		exit;
	fi
}

function dirCheck {
	if [ -d $1 ]; then
		mkdir -p $rootdir;
	fi
}

empty "$boxName";
empty "$IP";
dirCheck "$rootdir";

echo "[+] Doing this manually would probably more efficient, but if you just want to scan and watch some Netflix this is your thang";

echo "[+] Building a new directory";

cd $rootdir;
mkdir $dir;
echo "[+] Navigating to $dir";
cd $dir;
touch logs;
echo "[+] Starting nmap scan..";
echo "[+] Adding $boxName.htb to /etc/hosts";
echo "$IP $boxName.htb" >> /etc/hosts;
nmap -sV -p- -T5  -v $IP -oN $IP.nmap;
echo "[+] Test to see if a webserver is running on port 80";

if [[ $(curl -Is http://10.10.10.73 |grep HTTP/1.1| awk {'print $2'}) == 200 ]]; then
	echo "[+] Starting simple dirb scan";
	dirb http://$IP > dirb.out
else
	echo "[+] $IP doesn't seem to have a webserver on port 80";
fi

