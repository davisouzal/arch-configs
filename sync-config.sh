#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${HOME}/.config"
CONFIGS=(hypr waybar waypaper wlogout)

if ! command -v rsync >/dev/null 2>&1; then
    printf 'Erro: o comando rsync não está instalado.\n' >&2
    exit 1
fi

# Validate every source before changing any repository files.
for name in "${CONFIGS[@]}"; do
    if [[ ! -d "${CONFIG_DIR}/${name}" ]]; then
        printf 'Erro: diretório de origem não encontrado: %s\n' "${CONFIG_DIR}/${name}" >&2
        exit 1
    fi
done

printf 'Estas pastas do repositório serão espelhadas a partir de %s:\n\n' "${CONFIG_DIR}"
for name in "${CONFIGS[@]}"; do
    printf '%s\n' "--- ${name}/ ---"
    rsync --archive --delete --dry-run --itemize-changes \
        "${CONFIG_DIR}/${name}/" "${REPO_DIR}/${name}/"
done

printf '\nA opção --delete remove do repositório arquivos que não existam na origem.\n'
read -r -p 'Deseja continuar? [s/N] ' answer
case "${answer}" in
    s|S|sim|SIM|Sim) ;;
    *) printf 'Sincronização cancelada.\n'; exit 0 ;;
esac

for name in "${CONFIGS[@]}"; do
    rsync --archive --delete "${CONFIG_DIR}/${name}/" "${REPO_DIR}/${name}/"
    printf 'Atualizado: %s/\n' "${name}"
done
