set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[BACKUP]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Función principal de backup
create_backup() {
    local backup_dir="${1:-$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)}"
    
    log "Creando backup en: $backup_dir"
    mkdir -p "$backup_dir"
    
    # Archivos a respaldar
    local files_to_backup=(
        "$HOME/.zshrc"
        "$HOME/.p10k.zsh"
        "$HOME/.gitconfig"
        "$HOME/.vimrc"
        "$HOME/.tmux.conf"
    )
    
    # Directorios a respaldar
    local dirs_to_backup=(
        "$HOME/.config/nvim"
        "$HOME/.config/kitty"
        "$HOME/.config/alacritty"
    )
    
    # Respaldar archivos
    for file in "${files_to_backup[@]}"; do
        if [[ -f "$file" ]]; then
            cp "$file" "$backup_dir/"
            log "Respaldado: $(basename "$file")"
        fi
    done
    
    # Respaldar directorios
    for dir in "${dirs_to_backup[@]}"; do
        if [[ -d "$dir" ]]; then
            cp -r "$dir" "$backup_dir/"
            log "Respaldado: $(basename "$dir")"
        fi
    done
    
    # Crear archivo de información
    cat > "$backup_dir/backup-info.txt" << EOF
Backup creado: $(date)
Sistema: $(uname -a)
Usuario: $(whoami)
Directorio: $backup_dir

Archivos respaldados:
$(ls -la "$backup_dir")
EOF
    
    success "Backup completo guardado en: $backup_dir"
    echo "Para restaurar: bash scripts/restore.sh $backup_dir"
}

# Ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    create_backup "$@"
fi

