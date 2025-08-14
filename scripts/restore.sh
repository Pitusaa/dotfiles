#!/bin/bash

restore_backup() {
    local backup_dir="$1"
    
    if [[ -z "$backup_dir" ]]; then
        echo "Uso: $0 <directorio-de-backup>"
        echo "Ejemplo: $0 ~/.dotfiles-backup-20231215-143022"
        exit 1
    fi
    
    if [[ ! -d "$backup_dir" ]]; then
        echo "Error: Directorio de backup no existe: $backup_dir"
        exit 1
    fi
    
    log "Restaurando desde: $backup_dir"
    
    # Crear backup de configuración actual antes de restaurar
    local current_backup="$HOME/.dotfiles-current-backup-$(date +%Y%m%d-%H%M%S)"
    log "Creando backup de configuración actual en: $current_backup"
    bash "$(dirname "$0")/backup.sh" "$current_backup"
    
    # Restaurar archivos
    local files_to_restore=(
        ".zshrc"
        ".p10k.zsh"
        ".gitconfig"
        ".vimrc"
        ".tmux.conf"
    )
    
    for file in "${files_to_restore[@]}"; do
        if [[ -f "$backup_dir/$file" ]]; then
            cp "$backup_dir/$file" "$HOME/"
            log "Restaurado: $file"
        fi
    done
    
    # Restaurar directorios
    local dirs_to_restore=(
        "nvim"
        "kitty"
        "alacritty"
    )
    
    for dir in "${dirs_to_restore[@]}"; do
        if [[ -d "$backup_dir/$dir" ]]; then
            mkdir -p "$HOME/.config"
            cp -r "$backup_dir/$dir" "$HOME/.config/"
            log "Restaurado: .config/$dir"
        fi
    done
    
    success "Restauración completa"
    log "Tu configuración anterior está guardada en: $current_backup"
    log "Reinicia tu terminal para aplicar los cambios"
}

# Ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    restore_backup "$@"
fi
