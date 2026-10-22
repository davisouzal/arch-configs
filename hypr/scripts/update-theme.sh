#!/usr/bin/env bash
# Build a compact dark palette whose accent follows the current wallpaper.
set -euo pipefail

wallpaper=${1:-}
[[ -n "$wallpaper" && -f "$wallpaper" ]] || wallpaper=$(cat "$HOME/.cache/current_wallpaper" 2>/dev/null || true)
[[ -n "$wallpaper" && -f "$wallpaper" ]] || exit 0

mkdir -p "$HOME/.config/hypr/theme"
write_if_changed() {
    local target=$1 content tmp
    content=$(cat)
    [[ -f "$target" && "$(cat "$target")" == "$content" ]] && return 0
    tmp=$(mktemp "$HOME/.config/hypr/theme/.colors.tmp.XXXXXX")
    printf '%s\n' "$content" > "$tmp"
    mv -f "$tmp" "$target"
}
read -r accent bg surface border foreground muted < <(python3 - "$wallpaper" <<'PY'
import colorsys, re, subprocess, sys
hist = subprocess.check_output(['magick', sys.argv[1], '-auto-orient', '-thumbnail', '64x64', '-colors', '12', '-format', '%c', 'histogram:info:-'], text=True, stderr=subprocess.DEVNULL)
colors=[]
for line in hist.splitlines():
    m=re.search(r'\s*(\d+):.*?#([0-9A-Fa-f]{6})', line)
    if m:
        n=int(m.group(1)); rgb=tuple(int(m.group(2)[i:i+2],16) for i in (0,2,4))
        h,s,v=colorsys.rgb_to_hsv(*(x/255 for x in rgb))
        colors.append((n,s,v,h))
if colors:
    _,s,v,h=max(colors, key=lambda c: (c[0] * (0.35 + c[1]), c[1], c[2]))
else:
    h,s,v=0.72,0.4,0.8
# Keep the UI readable while carrying the wallpaper's hue into its accent.
accent=colorsys.hsv_to_rgb(h, max(.48,min(.82,s)), max(.78,min(1,v)))
def hexrgb(rgb): return '#%02x%02x%02x' % tuple(round(x*255) for x in rgb)
print(hexrgb(accent), '#171923', '#202431', '#394052', '#e6e8ef', '#9299aa')
PY
)

write_if_changed "$HOME/.config/hypr/theme/colors.env" <<EOF
THEME_ACCENT='$accent'
THEME_BG='$bg'
THEME_SURFACE='$surface'
THEME_BORDER='$border'
THEME_FG='$foreground'
THEME_MUTED='$muted'
EOF
write_if_changed "$HOME/.config/hypr/theme/colors.css" <<EOF
@define-color theme_accent $accent;
@define-color theme_bg $bg;
@define-color theme_surface $surface;
@define-color theme_border $border;
@define-color theme_fg $foreground;
@define-color theme_muted $muted;
EOF
