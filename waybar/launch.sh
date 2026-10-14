#!/bin/bash

# Define o caminho para a pasta de configurações da Waybar
CONFIG_DIR="$HOME/.config/waybar"

# Função para iniciar a Waybar
launch_waybar() {
    # Mata qualquer instância antiga se ainda existir
    killall -q waybar

    # Aguarda os processos serem encerrados
    while pgrep -u $UID -x waybar >/dev/null; do sleep 0.5; done

    # Inicia a Waybar em segundo plano
    waybar &
}

# Inicializa a Waybar pela primeira vez
launch_waybar

# Monitora continuamente a pasta por eventos de modificação, criação ou deleção
while inotifywait -e modify,create,delete,move -r "$CONFIG_DIR"; do
    echo "Configuração da Waybar alterada. Reiniciando..."
    launch_waybar
done
