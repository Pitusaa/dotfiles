#!/bin/bash

# =============================================================================
# SCRIPT DE VERIFICACIÓN DE INSTALACIÓN
# Diagnóstica y soluciona problemas comunes después de la instalación
# =============================================================================

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Contadores
total_checks=0
passed_checks=0
warnings=0
errors=0

log() {
    echo -e "${BLUE}[CHECK]${NC} $1"
}

success() {
    echo -e "${GREEN}[✅ PASS]${NC} $1"
    passed_checks=$((passed_checks + 1))
}

warning() {
    echo -e "${YELLOW}[⚠️ WARN]${NC} $1"
    warnings=$((warnings + 1))
}

error() {
    echo -e "${RED}[❌ FAIL]${NC} $1"
    errors=$((errors + 1))
}

check() {
    total_checks=$((total_checks + 1))
}

# Banner
echo -e "${PURPLE}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                    VERIFICACIÓN DE INSTALACIÓN                ║
║                     Diagnóstico de dotfiles                   ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo ""
log "Iniciando verificación completa del sistema..."
echo ""

# =============================================================================
# VERIFICACIONES BÁSICAS DEL SISTEMA
# =============================================================================

echo -e "${CYAN}🔍 VERIFICACIONES BÁSICAS DEL SISTEMA${NC}"
echo ""

# Check 1: Zsh instalado
check
log "Verificando zsh..."
if command -v zsh >/dev/null 2>&1; then
    local zsh_version=$(zsh --version | cut -d' ' -f2)
    success "zsh instalado - versión $zsh_version"
else
    error "zsh no está instalado"
fi

# Check 2: Shell por defecto
check
log "Verificando shell por defecto..."
if [[ "$SHELL" == *"zsh"* ]]; then
    success "zsh configurado como shell por defecto"
else
    warning "Shell por defecto: $SHELL (no es zsh)"
    echo "  💡 Ejecuta: chsh -s \$(which zsh)"
fi

# Check 3: Git disponible
check
log "Verificando git..."
if command -v git >/dev/null 2>&1; then
    local git_version=$(git --version | cut -d' ' -f3)
    success "git instalado - versión $git_version"
else
    error "git no está instalado"
fi

echo ""

# =============================================================================
# VERIFICACIONES DE OH MY ZSH
# =============================================================================

echo -e "${CYAN}📦 VERIFICACIONES DE OH MY ZSH${NC}"
echo ""

# Check 4: Oh My Zsh instalado
check
log "Verificando Oh My Zsh..."
if [[ -d ~/.oh-my-zsh ]]; then
    success "Oh My Zsh instalado en ~/.oh-my-zsh"
    
    # Verificar directorio de plugins
    if [[ -d ~/.oh-my-zsh/plugins ]]; then
        local plugin_count=$(ls ~/.oh-my-zsh/plugins | wc -l)
        log "Plugins Oh My Zsh disponibles: $plugin_count"
    fi
else
    error "Oh My Zsh no está instalado"
fi

# Check 5: Powerlevel10k tema
check
log "Verificando Powerlevel10k..."
if [[ -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]]; then
    success "Powerlevel10k instalado correctamente"
    
    if [[ -f ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme ]]; then
        success "Archivo de tema P10k presente"
    else
        error "Archivo de tema P10k faltante"
    fi
else
    error "Powerlevel10k no está instalado"
    echo "  💡 Ejecuta: git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k"
fi

echo ""

# =============================================================================
# VERIFICACIONES DE PLUGINS
# =============================================================================

echo -e "${CYAN}🔌 VERIFICACIONES DE PLUGINS${NC}"
echo ""

# Check 6: Plugin zsh-autosuggestions
check
log "Verificando zsh-autosuggestions..."
if [[ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
    success "zsh-autosuggestions instalado"
else
    warning "zsh-autosuggestions no encontrado"
    echo "  💡 Se instalará automáticamente en el próximo inicio de zsh"
fi

# Check 7: Plugin zsh-syntax-highlighting
check
log "Verificando zsh-syntax-highlighting..."
if [[ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]; then
    success "zsh-syntax-highlighting instalado"
else
    warning "zsh-syntax-highlighting no encontrado"
    echo "  💡 Se instalará automáticamente en el próximo inicio de zsh"
fi

echo ""

# =============================================================================
# VERIFICACIONES DE CONFIGURACIÓN
# =============================================================================

echo -e "${CYAN}⚙️ VERIFICACIONES DE CONFIGURACIÓN${NC}"
echo ""

# Check 8: Archivo .zshrc
check
log "Verificando archivo .zshrc..."
if [[ -f ~/.zshrc ]]; then
    success "Archivo .zshrc presente"
    
    # Verificar contenido del .zshrc
    log "Analizando contenido de .zshrc..."
    
    check
    if grep -q "oh-my-zsh" ~/.zshrc; then
        success "Configuración Oh My Zsh encontrada"
    else
        error ".zshrc no contiene configuración de Oh My Zsh"
    fi
    
    check
    if grep -q 'ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc; then
        success "Tema Powerlevel10k configurado correctamente"
    else
        error "Tema Powerlevel10k no configurado correctamente"
    fi
    
    check
    if grep -q "plugins=" ~/.zshrc; then
        success "Configuración de plugins encontrada"
        local plugins_line=$(grep "plugins=" ~/.zshrc | head -1)
        log "Plugins configurados: ${plugins_line#*=}"
    else
        warning "No se encontró configuración de plugins"
    fi
    
    check
    if grep -q "~/powerlevel10k/" ~/.zshrc; then
        error "Encontradas rutas incorrectas de Powerlevel10k (instalación manual antigua)"
        echo "  💡 Esto causará errores. Considera regenerar .zshrc"
    else
        success "No se encontraron rutas incorrectas de Powerlevel10k"
    fi
    
else
    error "Archivo .zshrc no encontrado"
fi

# Check 9: Archivo .p10k.zsh
check
log "Verificando archivo .p10k.zsh..."
if [[ -f ~/.p10k.zsh ]]; then
    success "Configuración Powerlevel10k presente"
    local p10k_size=$(stat -f%z ~/.p10k.zsh 2>/dev/null || stat -c%s ~/.p10k.zsh 2>/dev/null || echo "unknown")
    log "Tamaño del archivo: $p10k_size bytes"
else
    warning "Archivo .p10k.zsh no encontrado"
    echo "  💡 Se generará automáticamente al ejecutar 'p10k configure'"
fi

echo ""

# =============================================================================
# VERIFICACIONES DE FUENTES
# =============================================================================

echo -e "${CYAN}🔤 VERIFICACIONES DE FUENTES${NC}"
echo ""

# Check 10: Fuentes Nerd Font
check
log "Verificando fuentes MesloLGS NF..."
if command -v fc-list >/dev/null 2>&1; then
    if fc-list | grep -i "meslo.*nf" >/dev/null 2>&1; then
        success "Fuentes MesloLGS NF detectadas"
        local font_count=$(fc-list | grep -i "meslo.*nf" | wc -l)
        log "Variantes de fuente encontradas: $font_count"
    else
        warning "Fuentes MesloLGS NF no detectadas"
        echo "  💡 Ejecuta: bash ~/dotfiles/terminal/install-fonts.sh"
    fi
else
    warning "fc-list no disponible, no se pueden verificar fuentes"
fi

echo ""

# =============================================================================
# VERIFICACIONES DE DOTFILES
# =============================================================================

echo -e "${CYAN}📁 VERIFICACIONES DE DOTFILES${NC}"
echo ""

# Check 11: Directorio dotfiles
check
log "Verificando directorio dotfiles..."
if [[ -d ~/dotfiles ]]; then
    success "Directorio dotfiles presente en ~/dotfiles"
    
    # Verificar estructura
    local structure_ok=true
    
    if [[ -f ~/dotfiles/install.sh ]]; then
        log "✓ install.sh presente"
    else
        warning "install.sh faltante"
        structure_ok=false
    fi
    
    if [[ -f ~/dotfiles/install-local.sh ]]; then
        log "✓ install-local.sh presente"
    else
        warning "install-local.sh faltante"
        structure_ok=false
    fi
    
    if [[ -d ~/dotfiles/terminal ]]; then
        log "✓ directorio terminal/ presente"
    else
        warning "directorio terminal/ faltante"
        structure_ok=false
    fi
    
    if [[ -d ~/dotfiles/scripts ]]; then
        log "✓ directorio scripts/ presente"
    else
        warning "directorio scripts/ faltante"
        structure_ok=false
    fi
    
    if $structure_ok; then
        success "Estructura de dotfiles correcta"
    fi
else
    warning "Directorio dotfiles no encontrado en ~/dotfiles"
fi

echo ""

# =============================================================================
# RESUMEN FINAL
# =============================================================================

echo -e "${PURPLE}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                        RESUMEN FINAL                          ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo ""
echo -e "${CYAN}📊 ESTADÍSTICAS:${NC}"
echo "• Total de verificaciones: $total_checks"
echo "• Verificaciones exitosas: $passed_checks"
echo "• Advertencias: $warnings"
echo "• Errores: $errors"

echo ""
local success_rate=$((passed_checks * 100 / total_checks))
echo -e "${CYAN}📈 Tasa de éxito: ${success_rate}%${NC}"

echo ""
if [[ $errors -eq 0 ]] && [[ $warnings -le 2 ]]; then
    echo -e "${GREEN}🎉 ¡INSTALACIÓN EXITOSA!${NC}"
    echo "Tu configuración de dotfiles está funcionando correctamente."
    echo ""
    echo -e "${CYAN}✨ Próximos pasos:${NC}"
    echo "1. Reinicia tu terminal"
    echo "2. Cambia la fuente a 'MesloLGS NF'"
    echo "3. Ejecuta: source ~/.zshrc"
elif [[ $errors -eq 0 ]]; then
    echo -e "${YELLOW}⚠️ INSTALACIÓN CON ADVERTENCIAS${NC}"
    echo "Tu configuración debería funcionar, pero hay algunas mejoras posibles."
elif [[ $errors -le 2 ]]; then
    echo -e "${YELLOW}🔧 INSTALACIÓN CON PROBLEMAS MENORES${NC}"
    echo "Hay algunos problemas que deberían solucionarse."
else
    echo -e "${RED}❌ INSTALACIÓN CON PROBLEMAS IMPORTANTES${NC}"
    echo "Se detectaron múltiples problemas que requieren atención."
fi

echo ""
echo -e "${CYAN}🔧 COMANDOS DE SOLUCIÓN RÁPIDA:${NC}"
echo ""
echo "# Reinstalar Oh My Zsh:"
echo "rm -rf ~/.oh-my-zsh && curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh"
echo ""
echo "# Reinstalar Powerlevel10k:"
echo "rm -rf ~/.oh-my-zsh/custom/themes/powerlevel10k"
echo "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k"
echo ""
echo "# Reconfigurar completamente:"
echo "cd ~/dotfiles && ./install-local.sh"
echo ""
echo "# Configurar Powerlevel10k:"
echo "p10k configure"
echo ""

echo -e "${CYAN}📞 SOPORTE:${NC}"
echo "Si necesitas ayuda adicional:"
echo "• GitHub Issues: https://github.com/pitusaa/dotfiles/issues"
echo "• Documentación: https://github.com/pitusaa/dotfiles/blob/main/README.md"
echo ""