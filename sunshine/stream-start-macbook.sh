#!/bin/bash
SIG=$(ls -1t /run/user/$UID/hypr/ | head -1)
export HYPRLAND_INSTANCE_SIGNATURE=$SIG
hyprctl keyword monitor HDMI-A-1,,0x0,2
