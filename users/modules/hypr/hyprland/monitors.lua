------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})

local samsung = "desc:Samsung Electric Company Odyssey G81SF HNBYA00610"
hl.monitor({
    output   = samsung,
    mode     = "3840x2160@240",
    position = "auto",
    scale    = "1.2",
    bitdepth = 10,
})

local lg = "desc:LG Electronics LG FULL HD 0x01010101"
hl.monitor({
    output   = lg,
    mode     = "1920x1080@74.97",
    position = "auto",
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