#!/bin/bash
#
# Автор скрипту Манжара Владислав. Скрипт створений для особистого користування. 
# Я дозволяю його копіювати, поширювати та модифікувати. 
# Скрипти можна знайти на моємо gitlab репозиторії. https://gitlab.com/manzhara157/i3bygamerua

if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ "$1" == "" ]; then
	echo "Usage $0 [up|down|mute]"
	exit 0
fi

read_held_key() {
	while read -s -n 1 -t 0.1 key; do
		echo ""
	done
}

while true; do
	if [ "$1" == "up" ]; then
		wpctl set-volume @DEFAULT_SINK@ 0.05+
		st="󰝝 "
		vol=`wpctl get-volume @DEFAULT_SINK@ | awk '{print $2}'`
		vol_1=$(echo $vol | cut -d "." -f -1)
		vol_2=$(echo $vol | cut -d "." -f 2- | cut -c -2)
		vol_p="."
		if (( $vol_1 == 1 )); then
			echo $vol_a
			vol=100
		else
			vol=$vol_2
		fi
	fi
	
	if [ "$1" == "down" ]; then
		wpctl set-volume @DEFAULT_SINK@ 0.05-
		st="󰝞 "
		vol=`wpctl get-volume @DEFAULT_SINK@ | awk '{print $2}'`
		vol_1=$(echo $vol | cut -d "." -f -1)
		vol_2=$(echo $vol | cut -d "." -f 2- | cut -c -2)
		vol_p="."
		if (( $vol_1 == 1 )); then
			echo $vol_a
			vol=100
		else
			vol=$vol_2
		fi
	fi
	if [ "$1" == "mute" ]; then
		wpctl set-mute @DEFAULT_SINK@ toggle
		is_muted=`wpctl get-volume @DEFAULT_SINK@ | grep MUTED`
		if [[ -z "$is_muted" ]]; then
			st=" "
			vol=`wpctl get-volume @DEFAULT_SINK@ | awk '{print $2}'`
			vol_1=$(echo $vol | cut -d "." -f -1)
			vol_2=$(echo $vol | cut -d "." -f 2- | cut -c -2)
			vol=$vol_2
		else
			st="󰝟 "
			vol=0
		fi
	fi
	read -s -n 1 -t 0.1 input
	if [[ -z "$input" ]]; then
		# echo $input
		# echo "do something"
		break
	fi
	sleep 0.2
done

notify-send -a center -c mpv  --print-id "Volume  $st" "поточна: $vol" -h int:value:$vol
