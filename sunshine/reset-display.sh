#!/bin/bash
# Quick reset: restore HDMI monitor, disable DP-1, reload Hyprland
export HYPRLAND_INSTANCE_SIGNATURE=$(ls /run/user/$UID/hypr/ | head -1)
hyprctl reload
sleep 1
hyprctl keyword monitor HDMI-A-1,3840x2160@60,0x0,1.20
hyprctl keyword monitor DP-1,disable
