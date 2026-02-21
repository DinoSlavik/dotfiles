#!/bin/bash

sink=$(pactl list short sinks | wofi --dmenu)
sink=$(echo $sink | awk '{print $2}')
pactl set-default-sink $sink
