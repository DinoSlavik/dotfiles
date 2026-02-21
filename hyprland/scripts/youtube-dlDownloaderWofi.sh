#!/bin/bash
#
# This Script for comfort download from youtube.
# Script can Download video/audio, Play video/audio
# Script use yt-dlp, wofi, wl-clipboard, kitty, mpv
# So, install this package
# Athor: gamerua
# My gitlab repo: https://gitlab.com/manzhara157/i3bygamerua
#
url=$(wl-paste)
isUrl=$(echo $url | grep http)
echo $isUrl
menu="Download
Download Audio
Play
No Video
"
if [[ -n $isUrl ]]; then
	whatDo=$(echo -e "$menu" | wofi --show dmenu -l 10 -p "Whot to do?")
	if [[ "$whatDo" == "Download" ]]; then
		notify-send "YouScript" "Start Downloads"
		audio=$(yt-dlp -F $url | grep audio | head -n 1 | awk '{print $1}')
		video=$(yt-dlp -F $url | grep video | wofi --show dmenu -l 10  | awk '{print $1}')
		echo $video
		echo $audio
		notify-send "YouScript" "Search resolution"	
		yt-dlp -P "~/Downloads/" -f $video+$audio $url | awk '{print $2}' 
	fi
	
	if [[ "$whatDo" == "Download Audio" ]]; then
		notify-send "YouScript" "Start Downloads"
		yt-dlp -P "~/Downloads/podcast" -f 139 $url | awk '{print $2}' 
	fi

	if [[ "$whatDo" == "Play" ]]; then
		echo "Play"
		audio=$(yt-dlp -F $url | grep audio | head -n 1 | awk '{print $1}')
		video=$(yt-dlp -F $url | grep video | wofi --show dmenu -l 10  | awk '{print $1}')
		echo $video
		echo $audio
		mpv --ytdl-format=$video+$audio $url
	fi
	
	if [[ "$whatDo" == "No Video" ]]; then
		echo "Play audio"
		kitty mpv --no-video $url
	fi
else
	notify-send "YouScript" "Not URL. Copy the URL and try agane."
fi
notify-send "YouScript" "Done!"

