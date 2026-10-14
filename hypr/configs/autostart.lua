-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function ()
    -- Utiliza sh -c para garantir a expansão correta do caminho com $HOME
    hl.exec_cmd("sh -c '$HOME/.config/waybar/launch.sh'")
    hl.exec_cmd("sh -c '$HOME/.config/hypr/scripts/restore-wallpaper.sh'")
end)
