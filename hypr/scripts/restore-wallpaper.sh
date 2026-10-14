#!/usr/bin/env bash

CACHE_FILE="$HOME/.cache/current_wallpaper"

# Determina o comando correto instalado
if command -v awww-daemon &> /dev/null; then
    DAEMON_CMD="awww-daemon"
    CLI_CMD="awww"
else
    DAEMON_CMD="swww-daemon"
    CLI_CMD="swww"
fi

# Inicia o daemon se não estiver rodando
if ! pgrep -x "$DAEMON_CMD" > /dev/null; then
    $DAEMON_CMD &

    for i in {1..30}; do
        if $CLI_CMD query >/dev/null 2>&1; then
            break
        fi
        sleep 0.1
    done
fi

# Restaura o último wallpaper se o arquivo de cache existir
if [ -f "$CACHE_FILE" ]; then
    LAST_WALL=$(cat "$CACHE_FILE")
    if [ -f "$LAST_WALL" ]; then
        $CLI_CMD img "$LAST_WALL" --transition-type none
    fi
fi
