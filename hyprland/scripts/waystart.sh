#/bin/bash

if [[ ! `pidof waybar` ]]; then
	waybar
else
	pkill waybar
fi
