local function rule(name, match, effects)
    effects.name = name
    effects.match = match
    hl.window_rule(effects)
end

rule("windowrule-1", {
    class = ".*"
}, {
    suppress_event = "maximize"
})
rule("windowrule-2", {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false
}, {
    no_focus = true
})
rule("windowrule-3", {
    title = "(NFS Underground 2)"
}, {
    fullscreen = true
})
rule("windowrule-5", {
    class = "(gcr-prompter)"
}, {
    pin = true,
    stay_focused = true,
    float = true
})

for _, title in ipairs({"Authentication Required", "Password Required", "Enter password", "Sign in", "Log in", "Login",
                        "Authentication"}) do
    rule("float-" .. title, {
        title = "(" .. title .. ")"
    }, {
        float = true
    })
end
for _, class in ipairs({"polkit-gnome-authentication-agent-1", "polkit-kde-authentication-agent-1",
                        "org.kde.polkit-kde.authentication-agent-1", "pinentry-gtk-2", "pinentry-qt",
                        "nm-connection-editor", "pavucontrol", "blueman-manager", "xdg-desktop-portal-gtk"}) do
    rule("float-" .. class, {
        class = "(" .. class .. ")"
    }, {
        float = true
    })
end

rule("windowrule-17", {
    class = "(chromium)",
    title = "(Sign in to Chrome)"
}, {
    float = true
})
rule("windowrule-20", {
    title = "(OpenSSH Authentication Agent)"
}, {
    float = true
})
rule("windowrule-24", {
    class = "^proton-pass$"
}, {
    float = true,
    pin = true,
    size = {300, "auto"},
    center = true,
    no_initial_focus = false,
    keep_aspect_ratio = true,
    animation = "slide bottom"
})
rule("windowrule-25", {
    title = "(Picture in picture)"
}, {
    float = true,
    no_initial_focus = true,
    keep_aspect_ratio = true,
    size = {"monitor_w*0.2", "monitor_w*0.2*9/16"},
    opacity = "1.0 0.70",
    pin = true,
    animation = "slide right"
})
rule("pip-position", {
    title = "(Picture in picture)"
}, {
    move = {"monitor_w-(monitor_w*0.2)-10", 40}
})
rule("windowrule-26", {
    class = "steam"
}, {
    float = true,
    opacity = "1 1",
    idle_inhibit = "fullscreen"
})
rule("windowrule-27", {
    class = "steam",
    title = "Steam"
}, {
    center = true,
    size = {1100, 700}
})
rule("windowrule-28", {
    class = "steam",
    title = "Friends List"
}, {
    size = {460, 800}
})
rule("nautilus-floating", {
    class = "org.gnome.Nautilus"
}, {
    float = true,
    center = true,
    size = {1200, 800},
    animation = "popin"
})
rule("cachy-os", {
    title = "^CachyOS.*"
}, {
    float = true,
    center = true
})
rule("chrome-save-file", {
    class = "google-chrome",
    title = "Save File"
}, {
    float = true,
    center = true
})
rule("whatsapp-web", {
    class = "^chrome-hnpfjngllnobngcgfapefoaidbinmjnm-Default$"
}, {
    workspace = "special:magic"
})
rule("telegram", {
    class = "^org\\.telegram\\.desktop$"
}, {
    workspace = "special:magic"
})
rule("open-file-float", {
    title = "^Open File$"
}, {
    float = true,
    center = true,
    size = {800, 500}
})
