#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_FILE="$HOME/.cache/current_wallpaper"

if ! command -v rofi &> /dev/null; then
    notify-send "Erro" "Rofi não está instalado."
    exit 1
fi

ROFI_STYLE='
* { background-color: transparent; text-color: #cdd6f4; font: "JetBrainsMono Nerd Font 10"; }
window { background-color: #1e1e2e; border: 2px; border-color: #cba6f7; border-radius: 12px; width: 65%; padding: 16px; }
mainbox { children: [ inputbar, listview ]; spacing: 12px; }
inputbar { background-color: #181825; border-radius: 8px; padding: 8px 12px; children: [ prompt, entry ]; }
prompt { text-color: #cba6f7; margin: 0px 8px 0px 0px; }
entry { text-color: #cdd6f4; placeholder: "Buscar wallpaper..."; placeholder-color: #6c7086; }
listview { columns: 2; lines: 4; spacing: 8px; cycle: true; dynamic: true; }
element { background-color: #181825; text-color: #cdd6f4; orientation: horizontal; border-radius: 8px; padding: 6px 10px; border: 1px; border-color: #313244; children: [ element-icon, element-text ]; spacing: 10px; }
element selected { background-color: #313244; border-color: #cba6f7; text-color: #cba6f7; }
element-icon { size: 42px; vertical-align: 0.5; }
element-text { text-color: inherit; vertical-align: 0.5; horizontal-align: 0.0; }
'

SELECTED=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | sort | while read -r img; do
    filename=$(basename "$img")
    echo -en "${filename}\0icon\x1f${img}\n"
done | rofi -dmenu -i -show-icons -p "󰸉 Wallpaper" -theme-str "$ROFI_STYLE")

if [ -n "$SELECTED" ]; then
    FULL_PATH="$WALLPAPER_DIR/$SELECTED"

    # Salva o caminho no cache
    echo "$FULL_PATH" > "$CACHE_FILE"

    # Aplica o wallpaper
    if command -v awww &> /dev/null; then
        awww img "$FULL_PATH" --transition-type outer --transition-pos 0.8,0.9 --transition-step 90
    else
        swww img "$FULL_PATH" --transition-type outer --transition-pos 0.8,0.9 --transition-step 90
    fi
    waypaper --wallpaper "$FULL_PATH" >/dev/null 2>&1 &
fi
