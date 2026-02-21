#!/bin/bash

bssid=$(nmcli -f SSID,BSSID,SIGNAL,RATE,BARS,SECURITY dev wifi list | sed -n '1!p' | wofi --show dmenu -p "Обери WiFi: "  | awk '{print $2}')
pass=$( echo "" | wofi --show dmenu -P "Введіть пароль: ")
echo $bssid

if [[ -n $pass ]]
then
	echo "pass"
	text=$(nmcli device wifi connect $bssid password $pass)
	dunstify "Interner" "$text"
else
	echo "no pass"
	text=$(nmcli device wifi connect $bssid)
	dunstify "Interner" "$text"
fi


