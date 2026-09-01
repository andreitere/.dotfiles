-- Hyprland 0.55+ configuration.
-- See https://wiki.hypr.land/Configuring/Start/
-- Layout switch: "dwindle" or "scrolling". All layout-specific options and
-- keybinds are selected from this variable.
-- Global so that binds.lua can read it.
LAYOUT = "dwindle"
-- Global so that binds.lua can read it.
lock_cmd = "qs -c noctalia-shell ipc call lockScreen lock"

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
hl.env("GDK_SCALE", 2)
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
        dim_inactive = true,
        dim_strength = 0.3,
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
        -- kb_variant = "intl",
        follow_mouse = 1,
        sensitivity = -1,
        -- F1-F12 vs media-key behavior is NOT an xkb option. This keyboard spoofs an
        -- Apple Aluminium keyboard (05ac:024f), so the kernel hid_apple driver handles it.
        -- See /etc/modprobe.d/hid_apple.conf (fnmode=2 -> F-keys primary, Fn+Fx = media).
        kb_options = "ctrl:nocaps,altwin:swap_alt_win",
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

require("binds")
require("monitors")
require("window_rules")
