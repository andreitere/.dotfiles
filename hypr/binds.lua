-- Keybindings.
-- LAYOUT and lock_cmd are defined in hyprland.lua and shared with this file.
local browser = "helium-browser"
local browser_class = "helium" -- window class differs from the launch command
local launch_or_focus = "/home/andreiterecoasa/.local/bin/launch-or-focus"
local file_manager = "uwsm app -- nautilus ~/Downloads"
local noctalia_ipc = "qs -c noctalia-shell ipc call"

local function exec(command)
    return hl.dsp.exec_cmd(command)
end

local function bind(key, dispatcher, flags)
    hl.bind(key, dispatcher, flags)
end

bind("SUPER + code:36", exec("uwsm app -- " .. launch_or_focus .. " ghostty"))
bind("SUPER + SHIFT + code:36", exec("uwsm app -- ghostty"))
bind("SUPER + Q", hl.dsp.window.close())
bind("SUPER + F", hl.dsp.window.fullscreen({
    action = "toggle"
}))
bind("SUPER + L", exec(lock_cmd))
bind("SUPER + SHIFT + E", exec(file_manager))
bind("SUPER + SHIFT + W", hl.dsp.window.float({
    action = "toggle"
}))

bind("SUPER + B", exec("uwsm app -- " .. launch_or_focus .. " " .. browser_class .. " 'uwsm app -- " .. browser .. "'"))
bind("SUPER + SHIFT + B", exec("uwsm app -- " .. browser))
bind("SUPER + SPACE", exec(noctalia_ipc .. " launcher toggle"))
bind("SUPER + P", hl.dsp.window.pseudo({
    action = "toggle"
}))
-- Layout-specific binds
if LAYOUT == "scrolling" then
    bind("SUPER + J", hl.dsp.layout("move +col")) -- scroll layout right one column
    bind("SUPER + K", hl.dsp.layout("move -col")) -- scroll layout left one column
    bind("SUPER + COMMA", hl.dsp.layout("colresize -0.2")) -- shrink active column
    bind("SUPER + PERIOD", hl.dsp.layout("colresize +0.2")) -- widen active column
    bind("SUPER + SHIFT + J", hl.dsp.layout("promote")) -- move window to its own column
    bind("SUPER + SHIFT + K", hl.dsp.layout("fit active")) -- center/fit active column into view
    bind("SUPER + ALT + J", hl.dsp.layout("consume_or_expel prev")) -- merge into previous column / expel
    bind("SUPER + ALT + K", hl.dsp.layout("swapcol r")) -- swap column with the next one
else
    bind("SUPER + J", hl.dsp.layout("togglesplit")) -- dwindle-only
end
bind("ALT + SHIFT + SUPER + B", exec(noctalia_ipc .. " launcher emoji"))
bind("ALT + SHIFT + C", exec(noctalia_ipc .. " launcher clipboard"))
bind("SUPER + ALT + SHIFT + W", exec(
    'xfreerdp3 /u:"tere" /p:"isg2025" /v:127.0.0.1:3389 -grab-keyboard /sound /microphone /cert:ignore /title:"Windows VM" /dynamic-resolution /gfx:AVC444 /floatbar:sticky:off,default:visible,show:fullscreen'))
bind("SUPER + slash", exec("uwsm app -- proton-pass"))
bind("F8", exec("hyprshot -m region --clipboard-only"))
bind("code:99", exec("hyprshot -m region --clipboard-only"))

for _, direction in ipairs({"left", "right", "up", "down"}) do
    bind("ALT + TAB + " .. direction, hl.dsp.focus({
        direction = direction
    }))
    bind("SUPER + SHIFT + " .. direction, hl.dsp.window.move({
        direction = direction
    }))
end

local shortcuts = {{"C", "CTRL", "Insert"}, {"V", "SHIFT", "Insert"}, {"Z", "CTRL", "Z"},
                   {"SHIFT + Z", "CTRL SHIFT", "Z"}, {"A", "CTRL", "A"}, {"LEFT", "", "HOME"}, {"RIGHT", "", "END"},
                   {"SHIFT + LEFT", "SHIFT", "HOME"}, {"SHIFT + RIGHT", "SHIFT", "END"}}
for _, shortcut in ipairs(shortcuts) do
    bind("SUPER + " .. shortcut[1], hl.dsp.send_shortcut({
        mods = shortcut[2],
        key = shortcut[3]
    }))
end
bind("CTRL + UP", hl.dsp.send_shortcut({
    mods = "",
    key = "Prior"
}))
bind("CTRL + DOWN", hl.dsp.send_shortcut({
    mods = "",
    key = "Next"
}))
bind("CTRL + SHIFT + UP", hl.dsp.send_shortcut({
    mods = "SHIFT",
    key = "Prior"
}))
bind("CTRL + SHIFT + DOWN", hl.dsp.send_shortcut({
    mods = "SHIFT",
    key = "Next"
}))

for i = 1, 10 do
    local key = i == 10 and "0" or tostring(i)
    bind("SUPER + " .. key, hl.dsp.focus({
        workspace = tostring(i)
    }))
    bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({
        workspace = tostring(i)
    }))
end
bind("SUPER + ALT + PERIOD", hl.dsp.focus({
    workspace = "+1"
}))
bind("SUPER + ALT + COMMA", hl.dsp.focus({
    workspace = "-1"
}))
bind("SUPER + TAB", hl.dsp.workspace.toggle_special("magic"))
bind("SUPER + SHIFT + TAB", hl.dsp.window.move({
    workspace = "special:magic"
}))
-- Wheel binds are consuming by default: the scroll event is handled by
-- Hyprland and NOT forwarded to the focused window.
-- SUPER + wheel: scroll columns (scrolling) / switch workspaces (dwindle).
if LAYOUT == "scrolling" then
    bind("SUPER + mouse_down", hl.dsp.layout("move +col"))
    bind("SUPER + mouse_up", hl.dsp.layout("move -col"))
else
    bind("SUPER + mouse_down", hl.dsp.focus({
        workspace = "e+1"
    }))
    bind("SUPER + mouse_up", hl.dsp.focus({
        workspace = "e-1"
    }))
end
-- SUPER + ALT + wheel always switches workspaces, regardless of layout.
bind("SUPER + ALT + mouse_down", hl.dsp.focus({
    workspace = "e+1"
}))
bind("SUPER + ALT + mouse_up", hl.dsp.focus({
    workspace = "e-1"
}))
bind("SUPER + mouse:272", hl.dsp.window.drag(), {
    mouse = true
})
bind("SUPER + mouse:273", hl.dsp.window.resize(), {
    mouse = true
})

bind("XF86AudioRaiseVolume", exec(noctalia_ipc .. " volume increase"), {
    repeating = true,
    locked = true
})
bind("XF86AudioLowerVolume", exec(noctalia_ipc .. " volume decrease"), {
    repeating = true,
    locked = true
})
bind("XF86AudioMute", exec(noctalia_ipc .. " volume muteOutput"), {
    locked = true
})
bind("XF86AudioNext", exec("playerctl next"), {
    locked = true
})
bind("XF86AudioPause", exec("playerctl play-pause"), {
    locked = true
})
bind("XF86AudioPlay", exec("playerctl play-pause"), {
    locked = true
})
bind("XF86AudioPrev", exec("playerctl previous"), {
    locked = true
})
bind("Caps_Lock", exec("swayosd-client --caps-lock"), {
    release = true
})
