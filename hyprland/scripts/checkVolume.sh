#!/bin/bash

isMuted=$(wpctl get-volume @DEFAULT_SINK@ | grep MUTED)
vol_text=$(wpctl get-volume @DEFAULT_SINK@ | awk -F"." '/./{ print $2 }')
vol=$(echo ${vol_text})
# echo $vol
#echo $isMuted
if [[ -z $isMuted ]]; then
	# echo  $vol
	if [ $vol -eq 0 ]; then 
        echo  $vol
    elif [ $vol -lt 25 ]; then
        echo  $vol
    elif [ $vol -lt 50 ]; then
        echo  $vol
    else
        echo 墳 $vol
	fi

	# echo  $(amixer get Master | awk -F'[][]' 'END{ print $2 }')
else
	echo  0%
fi
