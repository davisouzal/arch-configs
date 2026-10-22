#!/usr/bin/env bash
set -euo pipefail

THEME_DIR="$HOME/.config/hypr/theme"
"$HOME/.config/hypr/scripts/update-theme.sh" >/dev/null 2>&1 || true
if [[ -f "$THEME_DIR/colors.env" ]]; then
    # shellcheck disable=SC1091
    source "$THEME_DIR/colors.env"
fi
: "${THEME_ACCENT:=#b4a1ef}" "${THEME_BG:=#171923}" "${THEME_SURFACE:=#202431}" "${THEME_BORDER:=#394052}" "${THEME_FG:=#e6e8ef}" "${THEME_MUTED:=#9299aa}"

exec rofi -show drun -show-icons -theme-str "
* { font: \"JetBrainsMono Nerd Font 10\"; background-color: transparent; text-color: $THEME_FG; }
window { location: center; anchor: center; width: 56%; height: 62%; background-color: $THEME_BG; border: 1px; border-color: $THEME_BORDER; border-radius: 18px; padding: 18px; }
mainbox { orientation: vertical; children: [ inputbar, listview ]; spacing: 14px; }
inputbar { orientation: horizontal; children: [ prompt, entry ]; background-color: $THEME_SURFACE; border-radius: 10px; padding: 10px 14px; }
prompt { text-color: $THEME_ACCENT; margin: 0px 10px 0px 0px; }
entry { placeholder: \"Buscar aplicativos...\"; placeholder-color: $THEME_MUTED; text-color: $THEME_FG; }
listview { flow: horizontal; columns: 5; lines: 4; fixed-columns: true; fixed-height: false; dynamic: true; cycle: true; scrollbar: false; spacing: 8px; }
element { orientation: vertical; children: [ element-icon, element-text ]; spacing: 6px; padding: 8px 5px; border: 1px; border-color: transparent; border-radius: 12px; background-color: transparent; text-color: $THEME_FG; }
element normal.normal, element alternate.normal { background-color: transparent; border-color: transparent; text-color: $THEME_FG; }
element selected, element selected.normal { background-color: $THEME_SURFACE; border-color: $THEME_ACCENT; text-color: $THEME_ACCENT; }
element-icon { size: 48px; horizontal-align: 0.5; vertical-align: 0.5; background-color: transparent; }
element-text { horizontal-align: 0.5; vertical-align: 0.5; text-color: inherit; }
"
