------------------
---- MONITORS ----
------------------

-- Monitor Primário: Lenovo
hl.monitor({
    output   = "HDMI-A-3",
    mode     = "1920x1080@74,97",
    position = "0x0",
    scale    = "1",
})

-- Monitor Secundário: Dell
hl.monitor({
    output   = "DP-2",
    mode     = "1920x1080@60.00",
    position = "1920x0",
    scale    = "1",
})
