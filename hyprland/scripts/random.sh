#!/bin/bash

while [ 1 == 1 ]
do
	WALLPAPER_DIRECTORY=~/.local/share/wallpapers
	
	WALLPAPER=$(find "$WALLPAPER_DIRECTORY" -type f | shuf -n 1)
	echo $WALLPAPER
	
	hyprctl hyprpaper preload "$WALLPAPER"
	hyprctl hyprpaper wallpaper "HDMI-A-1,$WALLPAPER"
	
	sleep 1
	
	hyprctl hyprpaper unload unused
	
	sleep 300
done
