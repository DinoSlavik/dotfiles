#!/bin/bash
#
#Battery Cheker
# Автор скрипту Манжара Владислав. Скрипт створений для особистого користування. 
# Я дозволяю його копіювати, поширювати та модифікувати. 
# Бажано використовувати з mako


acNew=$(acpi --ac-adapter | awk '{print $3}')
# gov=$(cpufreq-info | grep decide | awk '{print $3}' | head -n 1)
acOld="on-line"
govOld="\"ondemand\""
isExit=1
bc=$(acpi --battery | awk '{print $4}' | cut -d '%' -f1)

while [ $isExit = 1 ] 
do 
	bc=$(acpi --battery | awk '{print $4}' | cut -d '%' -f1)
	if [ $acOld = "off-line" ]; then
	 	if [[ $bc < 25 && $bc != 100 ]]
	 	# if [[ $bc < 30 ]]
	 	then
	 		notify-send "Battery" "Battery charge is $bc"
	 	   sleep 10
	 	   # ~/.config/notify-send/notify-send.sh --replace=3 --print-id "Battery" "Battery charge is $bc"

	 	fi
	 	if [[ $bc < 14 && $bc != 100 ]]
	 	then
		   notify-send -t 40000 -c mpv "Battery" "Suspend after 60 sec. Save youre work!"
	 	   sleep 60
		   acNew=$(acpi --ac-adapter | awk '{print $3}')
		   if [ $acNew = "off-line" ]; then
			 systemctl suspend
		   fi
	 	fi
	fi

	acNew=$(acpi --ac-adapter | awk '{print $3}')
	if [ $acOld = $acNew ]; then
			# echo "All good"
			echo $bc
			# echo $acOld
			# echo $acNew
		else
			notify-send -c mpv "Battery" "Battery is $acNew"
			acOld=$(acpi --ac-adapter | awk '{print $3}')
			# if [ "$gov" = $govOld ]; then 
			# 	cpufreq-set -c 0 -g powersave
			# 	gov=$(cpufreq-info | grep decide | awk '{print $3}' | head -n 1)
			# 	echo "Switch to $gov"
			# 	# notify-send "Battery" "Battery is $acNew"
			# else
			# 	cpufreq-set -c 0 -g ondemand
			# 	gov=$(cpufreq-info | grep decide | awk '{print $3}' | head -n 1)
			# 	echo "Switch to $gov"
			# 	# notify-send "Battery" "Battery is $acNew"
			# fi
			# echo $acOld
			# echo $acNew
		fi
	sleep 5
done
