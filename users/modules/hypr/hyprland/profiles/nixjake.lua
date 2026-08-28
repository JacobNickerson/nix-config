------------------
---- MONITORS ----
------------------

local samsung = "desc:Samsung Electric Company Odyssey G81SF HNBYA00610"
hl.monitor({
    output   = samsung,
    mode     = "3840x2160@240",
    position = "0x0",
    scale    = "1.2",
    bitdepth = 10,
})

local lg = "desc:LG Electronics LG FULL HD 0x01010101"
hl.monitor({
    output   = lg,
    mode     = "1920x1080@74.97",
    position = "auto-right",
    scale    = "1",
    bitdepth = 10,
})

hl.monitor({
    output   = "VIRTUAL",
    mode     = "1920x1080@60",
    position = "auto",
    scale    = "1",
    disabled = true,
})

------------------
---- KEYBINDS ----
------------------

local is_virt_enabled = false
local VIRT_MONITOR = "VIRTUAL"
local mainMod = "SUPER"
hl.bind(mainMod .. " + SHIFT + slash", function ()
    is_virt_enabled = not is_virt_enabled
    if is_virt_enabled then
        hl.exec_cmd(string.format("hyprctl output create headless %s",VIRT_MONITOR))
    else
        hl.exec_cmd(string.format("hyprctl output destroy %s",VIRT_MONITOR))
    end
    hl.monitor({
        output = VIRT_MONITOR,
        disabled = not is_virt_enabled,
    })

    hl.monitor({
        output   = samsung,
        disabled = is_virt_enabled,
    })
    hl.monitor({
        output   = lg,
        disabled = is_virt_enabled,
    })
end)

-------------------------
---- WORKSPACE RULES ----
-------------------------
for i = 1, 5 do
  hl.workspace_rule({
    workspace = tostring(i),
    monitor = samsung,
    default = (i == 1),
  })
  hl.workspace_rule({
    workspace = tostring(i+5),
    monitor = lg,
    default = (i == 1),
  })
end
