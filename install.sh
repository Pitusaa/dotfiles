#!/bin/bash

# =============================================================================
# DOTFILES INSTALLER
# Configuración automática de terminal personalizada
# =============================================================================

set -e  # Salir si cualquier comando falla

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Función para logging
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Banner
echo -e "${PURPLE}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                        DOTFILES INSTALLER                     ║
║              Configuración personalizada de terminal          ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Variables
DOTFILES_REPO="https://github.com/pitusaa/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Función para clonar el repositorio si no existe
setup_dotfiles_repo() {
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        log "Clonando repositorio dotfiles..."
        if command -v git >/dev/null 2>&1; then
            git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
            success "Repositorio clonado en $DOTFILES_DIR"
        else
            error "Git no está instalado. Instalando git primero..."
            install_dependencies
            git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
        fi
    else
        log "Repositorio dotfiles ya existe en $DOTFILES_DIR"
        log "Actualizando repositorio..."
        cd "$DOTFILES_DIR"
        git pull origin main || warning "No se pudo actualizar el repositorio"
    fi
    
    # Cambiar al directorio dotfiles
    cd "$DOTFILES_DIR"
    
    # Verificar que tenemos los archivos necesarios
    if [[ ! -f "install.sh" ]]; then
        error "El repositorio no contiene el archivo install.sh"
        exit 1
    fi
}

# Función para crear backup
create_backup() {
    log "Creando backup de configuraciones existentes..."
    mkdir -p "$BACKUP_DIR"
    
    # Backup de archivos existentes
    files_to_backup=(
        "$HOME/.zshrc"
        "$HOME/.p10k.zsh"
    )
    
    for file in "${files_to_backup[@]}"; do
        if [[ -f "$file" ]]; then
            cp "$file" "$BACKUP_DIR/"
            log "Backup creado: $(basename "$file")"
        fi
    done
    
    success "Backup guardado en: $BACKUP_DIR"
}

# Función para detectar sistema operativo
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get >/dev/null 2>&1; then
            echo "ubuntu"
        elif command -v dnf >/dev/null 2>&1; then
            echo "fedora"
        elif command -v pacman >/dev/null 2>&1; then
            echo "arch"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Función para instalar dependencias
install_dependencies() {
    local os=$(detect_os)
    log "Detectado sistema operativo: $os"
    
    case $os in
        ubuntu)
            log "Instalando dependencias para Ubuntu/Debian..."
            sudo apt update
            sudo apt install -y zsh git curl wget fontconfig
            ;;
        fedora)
            log "Instalando dependencias para Fedora..."
            sudo dnf install -y zsh git curl wget fontconfig
            ;;
        arch)
            log "Instalando dependencias para Arch Linux..."
            sudo pacman -S --noconfirm zsh git curl wget fontconfig
            ;;
        macos)
            log "Instalando dependencias para macOS..."
            if ! command -v brew >/dev/null 2>&1; then
                log "Instalando Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install zsh git curl wget
            ;;
        *)
            warning "Sistema operativo no reconocido. Instala manualmente: zsh git curl wget"
            ;;
    esac
}

# Función para instalar Oh My Zsh
install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log "Instalando Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        success "Oh My Zsh instalado"
    else
        log "Oh My Zsh ya está instalado"
    fi
}

# Función para instalar Powerlevel10k
install_powerlevel10k() {
    local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    
    if [[ ! -d "$p10k_dir" ]]; then
        log "Instalando Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
        success "Powerlevel10k instalado"
    else
        log "Powerlevel10k ya está instalado"
    fi
}

# Función para instalar fuentes
install_fonts() {
    log "Instalando fuentes MesloLGS NF..."
    bash "$DOTFILES_DIR/terminal/install-fonts.sh"
}

# Función para copiar configuraciones
copy_configs() {
    log "Copiando configuraciones..."
    
    # Copiar .zshrc
    if [[ -f "$DOTFILES_DIR/terminal/.zshrc" ]]; then
        cp "$DOTFILES_DIR/terminal/.zshrc" "$HOME/.zshrc"
        success "Configuración .zshrc copiada"
        
        # Verificar que el .zshrc se copió correctamente
        verify_zshrc_config
    else
        warning "No se encontró $DOTFILES_DIR/terminal/.zshrc"
        log "Creando configuración .zshrc básica..."
        create_basic_zshrc
    fi
    
    # Copiar .p10k.zsh
    if [[ -f "$DOTFILES_DIR/terminal/.p10k.zsh" ]]; then
        cp "$DOTFILES_DIR/terminal/.p10k.zsh" "$HOME/.p10k.zsh"
        success "Configuración .p10k.zsh copiada"
    else
        warning "No se encontró $DOTFILES_DIR/terminal/.p10k.zsh"
        log "Se configurará Powerlevel10k en el primer inicio"
    fi
}

# Función para verificar que .zshrc es correcto
verify_zshrc_config() {
    log "Verificando configuración .zshrc..."
    
    # Verificaciones de configuración correcta
    local checks_passed=0
    local total_checks=4
    
    # Check 1: Contiene referencia a Oh My Zsh
    if grep -q "oh-my-zsh" ~/.zshrc; then
        checks_passed=$((checks_passed + 1))
    else
        warning "❌ .zshrc no contiene configuración de Oh My Zsh"
    fi
    
    # Check 2: Tema de Powerlevel10k correcto
    if grep -q 'ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc; then
        checks_passed=$((checks_passed + 1))
    else
        warning "❌ .zshrc no tiene el tema de Powerlevel10k correcto"
    fi
    
    # Check 3: No contiene rutas incorrectas de P10k
    if ! grep -q "~/powerlevel10k/" ~/.zshrc; then
        checks_passed=$((checks_passed + 1))
    else
        warning "❌ .zshrc contiene rutas incorrectas de Powerlevel10k"
    fi
    
    # Check 4: Plugins básicos presentes
    if grep -q "plugins=" ~/.zshrc; then
        checks_passed=$((checks_passed + 1))
    else
        warning "❌ .zshrc no contiene configuración de plugins"
    fi
    
    # Evaluar resultados
    if [[ $checks_passed -eq $total_checks ]]; then
        success "✅ Configuración .zshrc verificada correctamente ($checks_passed/$total_checks)"
    elif [[ $checks_passed -ge 2 ]]; then
        warning "⚠️ Configuración .zshrc parcialmente correcta ($checks_passed/$total_checks)"
        log "El sistema debería funcionar, pero pueden aparecer algunas advertencias"
    else
        error "❌ Configuración .zshrc incorrecta ($checks_passed/$total_checks)"
        log "Aplicando configuración de respaldo..."
        create_basic_zshrc
    fi
}

# Función para crear .zshrc básico como respaldo
create_basic_zshrc() {
    log "Creando configuración .zshrc básica de respaldo..."
    
    # Hacer backup del .zshrc problemático
    if [[ -f ~/.zshrc ]]; then
        cp ~/.zshrc ~/.zshrc.backup-problematico-$(date +%Y%m%d-%H%M%S)
        log "Backup del .zshrc problemático creado"
    fi
    
    # Crear .zshrc limpio y funcional
    cat << 'EOF' > ~/.zshrc
# =============================================================================
# ZSHRC BÁSICO GENERADO AUTOMÁTICAMENTE
# Configuración mínima funcional para Oh My Zsh + Powerlevel10k
# =============================================================================

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

# Which plugins would you like to load?
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    docker
    docker-compose
    npm
    node
    python
    sudo
    history
    common-aliases
    colored-man-pages
    command-not-found
    extract
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR='nvim'

# Basic aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'

# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'

# Load Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Auto-install missing plugins if they don't exist
if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2>/dev/null || true
fi

if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 2>/dev/null || true
fi
EOF
    
    success "✅ Configuración .zshrc básica creada"
    log "Esta configuración incluye auto-instalación de plugins faltantes"
}

# Función para configurar zsh como shell por defecto
setup_zsh_default() {
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        log "Configurando zsh como shell por defecto..."
        if command -v chsh >/dev/null 2>&1; then
            chsh -s "$(which zsh)"
            success "zsh configurado como shell por defecto"
        else
            warning "No se pudo cambiar el shell por defecto. Hazlo manualmente con: chsh -s \$(which zsh)"
        fi
    else
        log "zsh ya es el shell por defecto"
    fi
}

# Función principal
main() {
    echo ""
    log "Iniciando instalación de dotfiles..."
    echo ""
    
    # Verificar si el usuario quiere continuar
    read -p "¿Continuar con la instalación? (y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "Instalación cancelada"
        exit 0
    fi
    
    # Configurar repositorio dotfiles (clonar si es necesario)
    setup_dotfiles_repo
    
    # Crear backup
    create_backup
    
    # Instalar dependencias
    install_dependencies
    
    # Instalar Oh My Zsh
    install_oh_my_zsh
    
    # Instalar Powerlevel10k
    install_powerlevel10k
    
    # Instalar fuentes
    install_fonts
    
    # Copiar configuraciones
    copy_configs
    
    # Configurar zsh por defecto
    setup_zsh_default
    
    echo ""
    echo -e "${GREEN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                    ¡INSTALACIÓN COMPLETA!                     ║
╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo -e "${CYAN}📋 Próximos pasos:${NC}"
    echo "1. Cambiar la fuente de tu terminal a 'MesloLGS NF'"
    echo "2. Reiniciar tu terminal o ejecutar: source ~/.zshrc"
    echo "3. Si hay problemas, ejecutar: p10k configure"
    echo ""
    echo -e "${CYAN}🔍 Verificación rápida:${NC}"
    echo "• Ejecutar: source ~/.zshrc"
    echo "• Si ves advertencias sobre instant prompt, es normal en la primera carga"
    echo "• Si faltan plugins, se instalarán automáticamente"
    echo ""
    echo -e "${CYAN}📁 Archivos importantes:${NC}"
    echo "• Backup: $BACKUP_DIR"
    echo "• Dotfiles: $DOTFILES_DIR"
    echo "• Configuración: ~/.zshrc y ~/.p10k.zsh"
    echo ""
    echo -e "${CYAN}🔧 En caso de problemas:${NC}"
    echo "• Restaurar backup: bash $DOTFILES_DIR/scripts/restore.sh $BACKUP_DIR"
    echo "• Reconfigurar P10k: p10k configure"
    echo "• Verificar plugins: ls ~/.oh-my-zsh/custom/plugins/"
    echo ""
}

# Ejecutar función principal
main "$@"