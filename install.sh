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
║                        DOTFILES INSTALLER                    ║
║              Configuración personalizada de terminal         ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Verificar que estamos en el directorio correcto
if [[ ! -f "install.sh" ]]; then
    error "Por favor ejecuta este script desde el directorio dotfiles"
    exit 1
fi

# Variables
DOTFILES_DIR="$PWD"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

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
    fi
    
    # Copiar .p10k.zsh
    if [[ -f "$DOTFILES_DIR/terminal/.p10k.zsh" ]]; then
        cp "$DOTFILES_DIR/terminal/.p10k.zsh" "$HOME/.p10k.zsh"
        success "Configuración .p10k.zsh copiada"
    fi
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
║                    ¡INSTALACIÓN COMPLETA!                    ║
╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo -e "${CYAN}📋 Próximos pasos:${NC}"
    echo "1. Cambiar la fuente de tu terminal a 'MesloLGS NF'"
    echo "2. Reiniciar tu terminal o ejecutar: source ~/.zshrc"
    echo "3. Si hay problemas, ejecutar: p10k configure"
    echo ""
    echo -e "${CYAN}📁 Backup guardado en:${NC} $BACKUP_DIR"
    echo -e "${CYAN}🔧 Para restaurar backup:${NC} bash scripts/restore.sh $BACKUP_DIR"
    echo ""
}

# Ejecutar función principal
main "$@"
