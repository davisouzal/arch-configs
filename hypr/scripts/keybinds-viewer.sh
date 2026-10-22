#!/usr/bin/env bash
set -euo pipefail

command -v rofi >/dev/null || { notify-send "Erro" "Rofi não está instalado."; exit 1; }
"$HOME/.config/hypr/scripts/update-theme.sh" >/dev/null 2>&1 || true
[[ -f "$HOME/.config/hypr/theme/colors.env" ]] && source "$HOME/.config/hypr/theme/colors.env"
: "${THEME_ACCENT:=#b4a1ef}" "${THEME_BG:=#171923}" "${THEME_SURFACE:=#202431}" "${THEME_BORDER:=#394052}" "${THEME_FG:=#e6e8ef}" "${THEME_MUTED:=#9299aa}"

# Hyprland Lua bindings expose an internal __lua dispatcher. Describe these
# shortcuts by their actual modifier mask and key instead of showing that ID.
declare -A labels=(
  ["64|RETURN"]="Abrir terminal" ["64|Q"]="Fechar janela ativa"
  ["64|M"]="Sair do Hyprland" ["64|E"]="Abrir gerenciador de arquivos"
  ["64|V"]="Alternar janela flutuante" ["64|SPACE"]="Abrir lançador de aplicativos"
  ["64|P"]="Alternar modo pseudo" ["64|J"]="Alternar divisão do layout"
  ["64|B"]="Abrir Firefox" ["64|W"]="Selecionar wallpaper"
  ["64|L"]="Bloquear tela" ["64|ESCAPE"]="Abrir menu de sessão"
  ["64|SLASH"]="Mostrar atalhos"
  ["64|LEFT"]="Mover foco para a esquerda" ["64|RIGHT"]="Mover foco para a direita"
  ["64|UP"]="Mover foco para cima" ["64|DOWN"]="Mover foco para baixo"
  ["64|S"]="Alternar workspace especial"
  ["65|S"]="Mover janela para workspace especial"
  ["64|MOUSE_DOWN"]="Workspace seguinte" ["64|MOUSE_UP"]="Workspace anterior"
  ["64|MOUSE:272"]="Arrastar janela" ["64|MOUSE:273"]="Redimensionar janela"
  ["0|XF86AUDIORAISEVOLUME"]="Aumentar volume" ["0|XF86AUDIOLOWERVOLUME"]="Diminuir volume"
  ["0|XF86AUDIOMUTE"]="Alternar mudo" ["0|XF86AUDIOMICMUTE"]="Alternar mudo do microfone"
  ["0|XF86MONBRIGHTNESSUP"]="Aumentar brilho" ["0|XF86MONBRIGHTNESSDOWN"]="Diminuir brilho"
  ["0|XF86AUDIONEXT"]="Próxima faixa" ["0|XF86AUDIOPAUSE"]="Reproduzir ou pausar"
  ["0|XF86AUDIOPLAY"]="Reproduzir ou pausar" ["0|XF86AUDIOPREV"]="Faixa anterior"
)
for i in {1..10}; do
  key=$((i % 10))
  labels["64|$key"]="Mudar para workspace $i"
  labels["65|$key"]="Mover janela para workspace $i"
done

key_name() {
  case "${1^^}" in
    RETURN) echo Enter;; ESCAPE) echo Esc;; SPACE) echo Espaço;; SLASH) echo /;;
    MOUSE_DOWN) echo "Roda para baixo";; MOUSE_UP) echo "Roda para cima";;
    XF86*) echo "${1#XF86}" | sed -E 's/([A-Z])([A-Z][a-z])|([a-z])([A-Z])/\1\3 \2\4/g';;
    *) echo "$1";;
  esac
}
mods() {
  local n=$1 out=""
  (( n & 64 )) && out="SUPER"
  (( n & 8 )) && out="${out:+$out + }ALT"
  (( n & 4 )) && out="${out:+$out + }CTRL"
  (( n & 1 )) && out="${out:+$out + }SHIFT"
  (( n & 2 )) && out="${out:+$out + }CAPS"
  echo "$out"
}

rows=$(hyprctl binds -j | jq -r '.[] | select(.dispatcher != "") | [.modmask, (.key // ""), .dispatcher, (.arg // "")] | @tsv')
while IFS=$'\t' read -r mask key dispatcher arg; do
  [[ -n "$key" ]] || continue
  key=${key^^}
  combo="$(mods "$mask")${mask:+ + }$(key_name "$key")"
  [[ "$mask" == 0 ]] && combo=$(key_name "$key")
  label=${labels["$mask|$key"]-}
  if [[ -z "$label" ]]; then
    case "$dispatcher $arg" in
      exec*__lua*) label="Ação personalizada";;
      exec*) label=${arg%% *};;
      *) label="$dispatcher ${arg}"; label=${label% };;
    esac
  fi
  printf '%-34s  %s\n' "$combo" "$label"
done <<< "$rows" | sort -u | rofi -dmenu -i -p "󰌌 Atalhos" -theme-str "
* { background-color: transparent; text-color: $THEME_FG; font: \"JetBrainsMono Nerd Font 10\"; }
window { background-color: $THEME_BG; border: 2px; border-color: $THEME_ACCENT; border-radius: 14px; width: 55%; padding: 18px; }
mainbox { children: [ inputbar, listview ]; spacing: 12px; }
inputbar { background-color: $THEME_SURFACE; border-radius: 9px; padding: 9px 13px; children: [ prompt, entry ]; }
prompt { text-color: $THEME_ACCENT; margin: 0px 8px 0px 0px; }
entry { text-color: $THEME_FG; placeholder: \"Pesquisar atalhos...\"; placeholder-color: $THEME_MUTED; }
listview { columns: 1; lines: 14; spacing: 6px; cycle: true; dynamic: true; }
element { background-color: $THEME_SURFACE; text-color: $THEME_FG; border-radius: 8px; padding: 8px 12px; border: 1px; border-color: $THEME_BORDER; }
element selected { background-color: $THEME_BORDER; border-color: $THEME_ACCENT; text-color: $THEME_ACCENT; }
element-text { text-color: inherit; vertical-align: 0.5; }
"
