#!/bin/bash
#
mainMenu=" Shutdown
 Reboot
 Sleep
 Logout
 Cancel
"
confirmMenu="Так
Ні
"

# bindsym $mod+x exec dmenu_run  
choos=$(echo -e "$mainMenu" | wofi --show dmenu --columns=1 --height 230 --width 50 -p "Choose: " --auto-select --markup-rows --print-query --query)

if [[ $choos == " Shutdown" ]]
then
	choos2=$(echo -e "$confirmMenu" | wofi --show dmenu --columns=1 --height 230 --width 50 -p "Choose: " --auto-select --markup-rows --print-query --query)
	if [[ $choos2 == "Так" ]]
	then
		systemctl poweroff
	else
		$HOME/.config/scripts/shutdownDmenu.sh 
	fi
fi

if [[ $choos == " Reboot" ]] 
then
	choos2=$(echo -e "$confirmMenu" | wofi --show dmenu --columns=1 --height 230 --width 50 -p "Choose: " --auto-select --markup-rows --print-query --query)
	if [[ $choos2 == "Так" ]]
	then
		systemctl reboot
	else
		$HOME/.config/scripts/shutdownDmenu.sh 
	fi
fi

if [[ $choos == " Sleep" ]]
then
	systemctl suspend
fi

if [[ $choos == " Logout" ]]
then
	loginctl terminate-session ${XDG_SESSION_ID-}
fi

if [[ $choos == " Cancel" ]]
then
	echo "Cancel"
fi

# if [ $choos == "Logout" ] then
# 	systemctrl poweroff
# fi

