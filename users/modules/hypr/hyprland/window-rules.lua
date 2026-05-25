----------------------
---- WINDOW RULES ----
----------------------

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
	name  = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move  = "20 monitor_h-120",
	float = true,
})

hl.window_rule({
	name = "vivaldi-workspace",
	match = { class = "^(vivaldi-stable)$" },
	no_initial_focus = true,
	workspace = 2,
})

hl.window_rule({
	name = "vesktop-workspace",
	match = { class = "^(vesktop)$" },
	no_initial_focus = true,
	workspace = 4,
})

hl.window_rule({
	name = "steam-workspace",
	match = { class = "^(steam)$" },
	no_initial_focus = true,
	workspace = 5,
})