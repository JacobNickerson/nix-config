------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})

-------------------------
---- WORKSPACE RULES ----
-------------------------
for i = 1, 5 do
  hl.workspace_rule({
    workspace = tostring(i),
    monitor = "eDP-1",
    default = (i == 1),
  })
end
