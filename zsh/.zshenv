# Functions needed in all zsh sessions (interactive, non-interactive, SSH)
# Run a hyprctl command against the first live (reachable) Hyprland instance.
_hyprctl_live() {
  local dir=/run/user/$(id -u)/hypr sig
  [[ -d $dir ]] || { echo "Hyprland not running"; return 1; }
  for sig in "$dir"/*(N); do
    sig=${sig:t}
    if HYPRLAND_INSTANCE_SIGNATURE=$sig hyprctl rollinglogger_status &>/dev/null; then
      HYPRLAND_INSTANCE_SIGNATURE=$sig hyprctl "$@"
      return
    fi
  done
  echo "No live Hyprland instance found"
  return 1
}

monitor_on() {
  _hyprctl_live dispatch 'hl.dsp.dpms({ action = "enable" })'
}

monitor_off() {
  _hyprctl_live dispatch 'hl.dsp.dpms({ action = "disable" })'
}

poweroff() {
  XDG_RUNTIME_DIR=/run/user/$(id -u) qs -c noctalia-shell ipc call sessionMenu poweroff
}
