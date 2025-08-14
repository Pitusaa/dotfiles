#!/bin/bash

# =============================================================================
# INSTALADOR DE FUENTES MESLO LGS NF
# Instala las fuentes necesarias para Powerlevel10k
# =============================================================================

set -e

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[FONTS]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Detectar sistema operativo
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Instalar fuentes en Linux
install_fonts_linux() {
    log "Instalando fuentes MesloLGS NF para Linux..."
    
    # Crear directorio de fuentes del usuario
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"
    
    # Array de fuentes a descargar
    fonts=(
        "MesloLGS%20NF%20Regular.ttf"
        "MesloLGS%20NF%20Bold.ttf"
        "MesloLGS%20NF%20Italic.ttf"
        "MesloLGS%20NF%20Bold%20Italic.ttf"
    )
    
    # URL base de las fuentes
    BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"
    
    # Descargar cada fuente
    cd "$FONT_DIR"
    for font in "${fonts[@]}"; do
        local font_file="${font//%20/ }"  # Reemplazar %20 con espacios
        
        if [[ -f "$font_file" ]]; then
            log "Fuente ya existe: $font_file"
        else
            log "Descargando: $font_file"
            if curl -fsSL -o "$font_file" "$BASE_URL/$font"; then
                success "Descargada: $font_file"
            else
                warning "Error descargando: $font_file"
            fi
        fi
    done
    
    # Actualizar cache de fuentes
    log "Actualizando cache de fuentes..."
    fc-cache -f -v > /dev/null 2>&1
    success "Cache de fuentes actualizado"
}

# Instalar fuentes en macOS
install_fonts_macos() {
    log "Instalando fuentes MesloLGS NF para macOS..."
    
    # Directorio de fuentes del usuario en macOS
    FONT_DIR="$HOME/Library/Fonts"
    mkdir -p "$FONT_DIR"
    
    # Array de fuentes a descargar
    fonts=(
        "MesloLGS%20NF%20Regular.ttf"
        "MesloLGS%20NF%20Bold.ttf"
        "MesloLGS%20NF%20Italic.ttf"
        "MesloLGS%20NF%20Bold%20Italic.ttf"
    )
    
    # URL base de las fuentes
    BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"
    
    # Descargar cada fuente
    cd "$FONT_DIR"
    for font in "${fonts[@]}"; do
        local font_file="${font//%20/ }"  # Reemplazar %20 con espacios
        
        if [[ -f "$font_file" ]]; then
            log "Fuente ya existe: $font_file"
        else
            log "Descargando: $font_file"
            if curl -fsSL -o "$font_file" "$BASE_URL/$font"; then
                success "Descargada: $font_file"
            else
                warning "Error descargando: $font_file"
            fi
        fi
    done
    
    success "Fuentes instaladas en macOS"
    log "Reinicia las aplicaciones para que detecten las nuevas fuentes"
}

# Verificar instalación
verify_installation() {
    log "Verificando instalación de fuentes..."
    
    if command -v fc-list >/dev/null 2>&1; then
        if fc-list | grep -i "meslo.*nf" >/dev/null 2>&1; then
            success "✅ Fuentes MesloLGS NF detectadas correctamente"
            
            # Mostrar fuentes encontradas
            log "Fuentes MesloLGS NF instaladas:"
            fc-list | grep -i "meslo.*nf" | cut -d: -f2 | sort | uniq | sed 's/^/  - /'
        else
            warning "⚠️  Las fuentes no se detectan. Puede que necesites reiniciar el terminal"
        fi
    else
        log "No se puede verificar con fc-list (normal en algunos sistemas)"
    fi
}

# Función principal
main() {
    local os=$(detect_os)
    
    log "Sistema operativo detectado: $os"
    
    case $os in
        linux)
            install_fonts_linux
            verify_installation
            ;;
        macos)
            install_fonts_macos
            ;;
        *)
            warning "Sistema operativo no soportado: $os"
            log "Descarga las fuentes manualmente desde:"
            log "https://github.com/romkatv/powerlevel10k-media"
            exit 1
            ;;
    esac
    
    echo ""
    success "¡Instalación de fuentes completada!"
    echo ""
    log "📝 Próximos pasos:"
    echo "1. Configura tu terminal para usar la fuente 'MesloLGS NF'"
    echo "2. Reinicia tu terminal"
    echo "3. Las fuentes deberían aparecer correctamente"
    echo ""
    log "🔧 Configuración de fuentes por terminal:"
    echo "• GNOME Terminal: Preferencias → Perfiles → Fuente personalizada"
    echo "• Kitty: font_family MesloLGS NF en ~/.config/kitty/kitty.conf"  
    echo "• Alacritty: family: MesloLGS NF en ~/.config/alacritty/alacritty.yml"
    echo "• VS Code: 'MesloLGS NF' en terminal.integrated.fontFamily"
}

# Ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
