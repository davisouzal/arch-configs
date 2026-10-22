#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_FILE="$HOME/.cache/current_wallpaper"
"$HOME/.config/hypr/scripts/update-theme.sh" >/dev/null 2>&1 || true
[[ -f "$HOME/.config/hypr/theme/colors.env" ]] && source "$HOME/.config/hypr/theme/colors.env"
: "${THEME_ACCENT:=#b4a1ef}" "${THEME_BG:=#171923}" "${THEME_SURFACE:=#202431}" "${THEME_BORDER:=#394052}" "${THEME_FG:=#e6e8ef}" "${THEME_MUTED:=#9299aa}"

if ! command -v rofi &> /dev/null; then
    notify-send "Erro" "Rofi não está instalado."
    exit 1
fi

ROFI_STYLE="
* { background-color: transparent; text-color: $THEME_FG; font: \"JetBrainsMono Nerd Font 10\"; }
window { background-color: $THEME_BG; border: 1px; border-color: $THEME_BORDER; border-radius: 18px; width: 82%; height: 76%; padding: 16px; }
mainbox { orientation: vertical; children: [ icon-current-entry, listview ]; spacing: 12px; }
inputbar { enabled: false; }
icon-current-entry { enabled: true; size: 380px; horizontal-align: 0.5; vertical-align: 0.5; background-color: transparent; }
listview { flow: horizontal; columns: 5; lines: 1; fixed-columns: true; fixed-height: false; spacing: 8px; cycle: true; dynamic: false; scrollbar: false; horizontal-align: 0.5; }
element { expand: false; width: 110px; background-color: transparent; orientation: horizontal; border-radius: 10px; padding: 2px; border: 0px; children: [ element-icon ]; }
element normal.normal, element alternate.normal { expand: false; width: 110px; background-color: transparent; border: 0px; }
element selected, element selected.normal { expand: false; width: 110px; background-color: transparent; border: 2px; border-color: $THEME_ACCENT; }
element-icon { enabled: true; size: 104px; background-color: transparent; text-color: inherit; vertical-align: 0.5; horizontal-align: 0.5; }
"

SELECTED=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | sort | while read -r img; do
    filename=$(basename "$img")
    echo -en "${filename}\0icon\x1f${img}\n"
done | rofi -dmenu -i -show-icons -theme-str "$ROFI_STYLE")

if [ -n "$SELECTED" ]; then
    FULL_PATH="$WALLPAPER_DIR/$SELECTED"

    # Salva o caminho no cache
    echo "$FULL_PATH" > "$CACHE_FILE"
    "$HOME/.config/hypr/scripts/update-theme.sh" "$FULL_PATH"

    # Aplica o wallpaper
    if command -v awww &> /dev/null; then
        awww img "$FULL_PATH" --transition-type outer --transition-pos 0.8,0.9 --transition-step 90
    else
        swww img "$FULL_PATH" --transition-type outer --transition-pos 0.8,0.9 --transition-step 90
    fi
    waypaper --wallpaper "$FULL_PATH" >/dev/null 2>&1 &
fi
