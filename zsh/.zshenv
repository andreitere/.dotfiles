# Functions needed in all zsh sessions (interactive, non-interactive, SSH)
monitor_on() {
  local dir=/run/user/$(id -u)/hypr
  [[ -d $dir ]] || { echo "Hyprland not running"; return 1; }
  local sig
  for sig in "$dir"/*/; do
    sig=${sig%/}
    sig=${sig##*/}
    HYPRLAND_INSTANCE_SIGNATURE=$sig hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'
    return
  done
  echo "No Hyprland instance found"
}

monitor_off() {
  local dir=/run/user/$(id -u)/hypr
  [[ -d $dir ]] || { echo "Hyprland not running"; return 1; }
  local sig
  for sig in "$dir"/*/; do
    sig=${sig%/}
    sig=${sig##*/}
    HYPRLAND_INSTANCE_SIGNATURE=$sig hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })'
    return
  done
  echo "No Hyprland instance found"
}

poweroff() {
  XDG_RUNTIME_DIR=/run/user/$(id -u) qs -c noctalia-shell ipc call sessionMenu poweroff
}
