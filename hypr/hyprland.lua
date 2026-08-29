-- Hyprland 0.55+ configuration.
-- See https://wiki.hypr.land/Configuring/Start/
-- Layout switch: "dwindle" or "scrolling". All layout-specific options and
-- keybinds below are selected from this variable.
local LAYOUT = "scrolling"
local file_manager = "uwsm app -- nautilus ~/Downloads"
local lock_cmd = "qs -c noctalia-shell ipc call lockScreen lock"
local noctalia_ipc = "qs -c noctalia-shell ipc call"

local function exec(command)
    return hl.dsp.exec_cmd(command)
end

-- Environment
hl.env("WAYLAND_DISPLAY", "wayland-1")
hl.env("WLR_DRM_DEVICES", "/dev/dri/by-path/pci-0000:01:00.0-card:/dev/dri/by-path/pci-0000:10:00.0-card")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XCURSOR_SIZE", "22")
hl.env("HYPRCURSOR_SIZE", "22")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("GDK_SCALE", "2")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
-- GTK_THEME env var overrides gsettings/settings.ini, so don't set it globally.
-- Let apps follow the theme from gsettings (currently Yaru-blue / Yaru-blue-dark).

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        ["col.active_border"] = {
            colors = {"rgba(d35400ff)", "rgba(d35400ff)"},
            angle = 45
        },
        ["col.inactive_border"] = "rgba(595959aa)",
        resize_on_border = true,
        allow_tearing = false,
        layout = LAYOUT
    },
    decoration = {
        rounding = 2,
        rounding_power = 2,
        dim_inactive = false,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)"
        },
        blur = {
            enabled = false,
            size = 3,
            passes = 2,
            vibrancy = 0.1696
        }
    },
    -- Layout-specific options. Hyprland only reads the section matching
    -- general.layout, so it's fine to keep them all here.
    -- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
    scrolling = {
        fullscreen_on_one_column = true, -- single column spans the whole screen
        column_width = 0.4, -- default width of a new column [0.1 - 1.0]
        focus_fit_method = 1, -- 0 = center column on focus, 1 = fit into view
        follow_focus = true, -- scroll the layout when focus moves
        follow_min_visible = 0.4, -- fraction of a window that must be visible for focus to follow
        explicit_column_widths = "0.333, 0.5, 0.667, 1.0", -- widths cycled by colresize +conf/-conf
        wrap_focus = true, -- focus l/r wraps around at the ends
        wrap_swapcol = true, -- swapcol l/r wraps around at the ends
        direction = "right" -- where new windows appear: left/right/down/up
    },
    dwindle = {
        preserve_split = true
    },
    master = {
        new_status = "master"
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true
    },
    render = {
        direct_scanout = false
    },
    input = {
        kb_layout = "us",
        kb_variant = "mac",
        follow_mouse = 1,
        sensitivity = -1,
        kb_options = "ctrl:nocaps,#altwin:swap_alt_win",
        accel_profile = "adaptive"
    },
    xwayland = {
        force_zero_scaling = true
    }
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

hl.device({
    name = "logitech-wireless-mouse-mx-master-3-1",
    sensitivity = -0.3
})

local curves = {{"easeOutQuint", 0.23, 1, 0.32, 1}, {"easeInOutCubic", 0.65, 0.05, 0.36, 1}, {"linear", 0, 0, 1, 1},
                {"almostLinear", 0.5, 0.5, 0.75, 1}, {"quick", 0.15, 0, 0.1, 1}}
for _, curve in ipairs(curves) do
    hl.curve(curve[1], {
        type = "bezier",
        points = {{curve[2], curve[3]}, {curve[4], curve[5]}}
    })
end

local animations = {{"global", 3, "default"}, {"border", 5.39, "easeOutQuint"}, {"windows", 4.79, "easeOutQuint"},
                    {"windowsIn", 4.1, "easeOutQuint", "popin 87%"}, {"windowsOut", 1.49, "linear", "popin 87%"},
                    {"fadeIn", 1.73, "almostLinear"}, {"fadeOut", 1.46, "almostLinear"}, {"fade", 3.03, "quick"},
                    {"layers", 3.81, "easeOutQuint"}, {"layersIn", 4, "easeOutQuint", "fade"},
                    {"layersOut", 1.5, "linear", "fade"}, {"fadeLayersIn", 1.79, "almostLinear"},
                    {"fadeLayersOut", 1.39, "almostLinear"}, {"workspaces", 1.94, "easeInOutCubic", "slide"},
                    {"workspacesIn", 1.21, "easeInOutCubic", "slide"},
                    {"workspacesOut", 1.94, "easeInOutCubic", "slide"}, {"zoomFactor", 4, "quick"}}
for _, animation in ipairs(animations) do
    hl.animation({
        leaf = animation[1],
        enabled = true,
        speed = animation[2],
        bezier = animation[3],
        style = animation[4]
    })
end

-- Start services after Hyprland has initialized.
hl.on("hyprland.start", function()
    hl.exec_cmd("echo balance_performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference")
    hl.exec_cmd("while true; do qs -c noctalia-shell; sleep 2; done")
    hl.exec_cmd("$HOME/.local/bin/import_env tmux")
    hl.exec_cmd("$HOME/.local/bin/import_env system")
    hl.exec_cmd("(sleep 2; " .. lock_cmd .. ")")
    hl.exec_cmd("uwsm app -- hypridle")
    hl.exec_cmd("wl-clip-persist --clipboard regular")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("uwsm app -- udiskie")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)

-- Keybindings
local function bind(key, dispatcher, flags)
    hl.bind(key, dispatcher, flags)
end

bind("SUPER + code:36", exec("uwsm app -- /home/andreiterecoasa/.local/bin/launch-or-focus ghostty"))
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

require("monitors")
require("window_rules")
