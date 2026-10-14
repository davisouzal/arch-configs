nano # 🏛️ Arch Configs

Meu repositório pessoal de dotfiles para o **Arch Linux**. Este repositório gerencia as configurações do meu ambiente gráfico baseado em Wayland.

## 🛠️ Componentes Principais

* **Hyprland (`hypr/`)**: Window manager dinâmico baseado em Wayland, com foco em animações fluidas e efeitos visuais.
* **Waybar (`waybar/`)**: Barra de status altamente customizável para compositores Wayland.
* **Waypaper (`waypaper/`)**: Frontend GUI para gerenciamento e troca de papéis de parede.

## 🚀 Como Instalar

> ⚠️ **Aviso:** Antes de copiar, faça um backup das suas configurações atuais para evitar perda de dados.

1. **Clone o repositório:**
```bash
git clone https://github.com/davisouzal/arch-configs
cd arch-configs
```

2. **Copie as configurações para o seu diretório `~/.config/`:**
```bash
# Criar pastas caso não existam e copiar os arquivos
cp -r hypr/ waybar/ waypaper/ ~/.config/
```

## 📦 Dependências Necessárias

Para que tudo funcione corretamente, garanta que os seguintes pacotes estejam instalados no seu Arch Linux:

```bash
sudo pacman -S hyprland waybar waypaper
```
*(Nota: Certifique-se de instalar também os seletores de wallpaper compatíveis com o waypaper, como `swww` ou `mpvpaper`, se necessário).*
