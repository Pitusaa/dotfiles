#!/bin/bash

# =============================================================================
# SCRIPT DE VERIFICACIÓN DE INSTALACIÓN - VERSIÓN CORREGIDA
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

# Contadores corregidos
total_checks=0
passed_checks=0
warnings=0
errors=0

log() {
    echo -e "${BLUE}[CHECK]${NC} $1"
}

info() {
    echo -e "${BLUE}  ℹ️${NC} $1"
}

# Funciones corregidas - solo incrementan una vez por verificación
pass_check() {
    echo -e "${GREEN}[✅ PASS]${NC} $1"
    passed_checks=$((passed_checks + 1))
}

warn_check() {
    echo -e "${YELLOW}[⚠️ WARN]${NC} $1"
    warnings=$((warnings + 1))
}

fail_check() {
    echo -e "${RED}[❌ FAIL]${NC} $1"
    errors=$((errors + 1))
}

start_check() {
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
start_check
log "Verificando zsh..."
if command -v zsh >/dev/null 2>&1; then
    zsh_version=$(zsh --version | cut -d' ' -f2)
    pass_check "zsh instalado - versión $zsh_version"
else
    fail_check "zsh no está instalado"
fi

# Check 2: Shell por defecto
start_check
log "Verificando shell por defecto..."
if [[ "$SHELL" == *"zsh"* ]]; then
    pass_check "zsh configurado como shell por defecto"
else
    warn_check "Shell por defecto: $SHELL (no es zsh)"
    info "Ejecuta: chsh -s \$(which zsh)"
fi

# Check 3: Git disponible
start_check
log "Verificando git..."
if command -v git >/dev/null 2>&1; then
    git_version=$(git --version | cut -d' ' -f3)
    pass_check "git instalado - versión $git_version"
else
    fail_check "git no está instalado"
fi

echo ""

# =============================================================================
# VERIFICACIONES DE OH MY ZSH
# =============================================================================

echo -e "${CYAN}📦 VERIFICACIONES DE OH MY ZSH${NC}"
echo ""

# Check 4: Oh My Zsh instalado
start_check
log "Verificando Oh My Zsh..."
if [[ -d ~/.oh-my-zsh ]]; then
    pass_check "Oh My Zsh instalado en ~/.oh-my-zsh"
    
    # Información adicional (no cuenta como verificación)
    if [[ -d ~/.oh-my-zsh/plugins ]]; then
        plugin_count=$(ls ~/.oh-my-zsh/plugins | wc -l)
        info "Plugins Oh My Zsh disponibles: $plugin_count"
    fi
else
    fail_check "Oh My Zsh no está instalado"
fi

# Check 5: Powerlevel10k tema
start_check
log "Verificando Powerlevel10k..."
if [[ -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]]; then
    if [[ -f ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme ]]; then
        pass_check "Powerlevel10k instalado correctamente"
    else
        fail_check "Powerlevel10k: directorio presente pero archivo de tema faltante"
    fi
else
    fail_check "Powerlevel10k no está instalado"
    info "Ejecuta: git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k"
fi

echo ""

# =============================================================================
# VERIFICACIONES DE PLUGINS
# =============================================================================

echo -e "${CYAN}🔌 VERIFICACIONES DE PLUGINS${NC}"
echo ""

# Check 6: Plugin zsh-autosuggestions
start_check
log "Verificando zsh-autosuggestions..."
if [[ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
    pass_check "zsh-autosuggestions instalado"
else
    warn_check "zsh-autosuggestions no encontrado"
    info "Se instalará automáticamente en el próximo inicio de zsh"
fi

# Check 7: Plugin zsh-syntax-highlighting
start_check
log "Verificando zsh-syntax-highlighting..."
if [[ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]; then
    pass_check "zsh-syntax-highlighting instalado"
else
    warn_check "zsh-syntax-highlighting no encontrado"
    info "Se instalará automáticamente en el próximo inicio de zsh"
fi

echo ""

# =============================================================================
# VERIFICACIONES DE CONFIGURACIÓN
# =============================================================================

echo -e "${CYAN}⚙️ VERIFICACIONES DE CONFIGURACIÓN${NC}"
echo ""

# Check 8: Archivo .zshrc
start_check
log "Verificando archivo .zshrc..."
if [[ -f ~/.zshrc ]]; then
    # Verificar múltiples aspectos pero solo un resultado por verificación
    zshrc_score=0
    total_zshrc_checks=4
    
    # Sub-verificaciones para información
    if grep -q "oh-my-zsh" ~/.zshrc; then
        zshrc_score=$((zshrc_score + 1))
        info "✓ Configuración Oh My Zsh encontrada"
    else
        info "✗ Configuración Oh My Zsh no encontrada"
    fi
    
    if grep -q 'ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc; then
        zshrc_score=$((zshrc_score + 1))
        info "✓ Tema Powerlevel10k configurado"
    else
        info "✗ Tema Powerlevel10k no configurado"
    fi
    
    if grep -q "plugins=" ~/.zshrc; then
        zshrc_score=$((zshrc_score + 1))
        info "✓ Configuración de plugins encontrada"
    else
        info "✗ Configuración de plugins no encontrada"
    fi
    
    if ! grep -q "~/powerlevel10k/" ~/.zshrc; then
        zshrc_score=$((zshrc_score + 1))
        info "✓ No hay rutas incorrectas de Powerlevel10k"
    else
        info "✗ Encontradas rutas incorrectas de Powerlevel10k"
    fi
    
    # Resultado final de la verificación
    if [[ $zshrc_score -eq $total_zshrc_checks ]]; then
        pass_check "Archivo .zshrc configurado correctamente ($zshrc_score/$total_zshrc_checks)"
    elif [[ $zshrc_score -ge 2 ]]; then
        warn_check "Archivo .zshrc parcialmente correcto ($zshrc_score/$total_zshrc_checks)"
    else
        fail_check "Archivo .zshrc con problemas importantes ($zshrc_score/$total_zshrc_checks)"
    fi
else
    fail_check "Archivo .zshrc no encontrado"
fi

# Check 9: Archivo .p10k.zsh
start_check
log "Verificando archivo .p10k.zsh..."
if [[ -f ~/.p10k.zsh ]]; then
    p10k_size=$(stat -f%z ~/.p10k.zsh 2>/dev/null || stat -c%s ~/.p10k.zsh 2>/dev/null || echo "0")
    if [[ "$p10k_size" -gt 1000 ]]; then
        pass_check "Configuración Powerlevel10k presente ($p10k_size bytes)"
    else
        warn_check "Archivo .p10k.zsh muy pequeño ($p10k_size bytes)"
    fi
else
    warn_check "Archivo .p10k.zsh no encontrado"
    info "Se generará automáticamente al ejecutar 'p10k configure'"
fi

echo ""

# =============================================================================
# VERIFICACIONES DE FUENTES
# =============================================================================

echo -e "${CYAN}🔤 VERIFICACIONES DE FUENTES${NC}"
echo ""

# Check 10: Fuentes Nerd Font
start_check
log "Verificando fuentes MesloLGS NF..."
if command -v fc-list >/dev/null 2>&1; then
    if fc-list | grep -i "meslo.*nf" >/dev/null 2>&1; then
        font_count=$(fc-list | grep -i "meslo.*nf" | wc -l)
        pass_check "Fuentes MesloLGS NF detectadas ($font_count variantes)"
    else
        warn_check "Fuentes MesloLGS NF no detectadas"
        info "Ejecuta: bash ~/dotfiles/terminal/install-fonts.sh"
    fi
else
    warn_check "fc-list no disponible, no se pueden verificar fuentes"
fi

echo ""

# =============================================================================
# VERIFICACIONES DE DOTFILES
# =============================================================================

echo -e "${CYAN}📁 VERIFICACIONES DE DOTFILES${NC}"
echo ""

# Check 11: Directorio dotfiles
start_check
log "Verificando directorio dotfiles..."
if [[ -d ~/dotfiles ]]; then
    # Verificar estructura pero solo un resultado final
    structure_score=0
    total_structure_checks=5
    
    [[ -f ~/dotfiles/install.sh ]] && structure_score=$((structure_score + 1)) && info "✓ install.sh presente"
    [[ -f ~/dotfiles/install-local.sh ]] && structure_score=$((structure_score + 1)) && info "✓ install-local.sh presente"
    [[ -d ~/dotfiles/terminal ]] && structure_score=$((structure_score + 1)) && info "✓ directorio terminal/ presente"
    [[ -d ~/dotfiles/scripts ]] && structure_score=$((structure_score + 1)) && info "✓ directorio scripts/ presente"
    [[ -f ~/dotfiles/README.md ]] && structure_score=$((structure_score + 1)) && info "✓ README.md presente"
    
    if [[ $structure_score -eq $total_structure_checks ]]; then
        pass_check "Estructura de dotfiles completa ($structure_score/$total_structure_checks)"
    elif [[ $structure_score -ge 3 ]]; then
        warn_check "Estructura de dotfiles parcial ($structure_score/$total_structure_checks)"
    else
        fail_check "Estructura de dotfiles incompleta ($structure_score/$total_structure_checks)"
    fi
else
    warn_check "Directorio dotfiles no encontrado en ~/dotfiles"
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

# Verificar que la matemática sea correcta
if [[ $((passed_checks + warnings + errors)) -ne $total_checks ]]; then
    echo -e "${RED}⚠️ ERROR INTERNO: Los contadores no cuadran${NC}"
    echo "Suma: $((passed_checks + warnings + errors)) ≠ Total: $total_checks"
fi

echo ""
if [[ $total_checks -gt 0 ]]; then
    success_rate=$((passed_checks * 100 / total_checks))
    echo -e "${CYAN}📈 Tasa de éxito: ${success_rate}%${NC}"
else
    echo -e "${RED}📈 No se pudieron realizar verificaciones${NC}"
fi

echo ""
if [[ $errors -eq 0 ]] && [[ $warnings -le 2 ]]; then
    echo -e "${GREEN}🎉 ¡INSTALACIÓN EXITOSA!${NC}"
    echo "Tu configuración de dotfiles está funcionando correctamente."
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
echo -e "${CYAN}🔧 COMANDOS DE SOLUCIÓN:${NC}"
echo ""
echo "# Diagnóstico y corrección automática:"
echo "cd ~/dotfiles && ./install-local.sh"
echo ""
echo "# Reconfigurar Powerlevel10k:"
echo "p10k configure"
echo ""
echo "# Reinstalar plugins:"
echo "rm -rf ~/.oh-my-zsh/custom/plugins/zsh-*"
echo "source ~/.zshrc  # Los plugins se instalarán automáticamente"
echo ""
echo "# Reinstalar fuentes:"
echo "cd ~/dotfiles && bash terminal/install-fonts.sh"
echo ""

echo -e "${CYAN}📞 SOPORTE:${NC}"
echo "• GitHub Issues: https://github.com/pitusaa/dotfiles/issues"
echo "• Documentación: https://github.com/pitusaa/dotfiles/blob/main/README.md"
echo ""