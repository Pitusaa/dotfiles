# 🚀 Dotfiles - Configuración Personalizada de Terminal

Configuración completa y automatizada para un terminal de desarrollo moderno con **zsh**, **Oh My Zsh**, **Powerlevel10k** y configuraciones optimizadas para desarrollo en **Java**, **C#**, **JavaScript**, **Python** y **Docker**.

![Terminal Preview](https://via.placeholder.com/800x400/1a1a1a/ffffff?text=Terminal+Preview)

## ✨ Características

- **🎨 Terminal moderno**: Prompt de dos líneas con información contextual
- **⚡ Rendimiento optimizado**: Solo muestra información relevante según el proyecto
- **🔧 Desarrollo-friendly**: Configurado para Java, C#, Node.js, Python y Docker
- **🌈 Colores y iconos**: Interfaz visual atractiva con Nerd Fonts
- **📦 Instalación automática**: Un comando y todo funciona
- **🔄 Sincronización**: Misma configuración en todos tus ordenadores

## 🛠️ Stack Incluido

| Herramienta | Propósito | Estado |
|-------------|-----------|--------|
| **zsh** | Shell moderno | ✅ |
| **Oh My Zsh** | Framework de zsh | ✅ |
| **Powerlevel10k** | Tema del prompt | ✅ |
| **MesloLGS NF** | Fuente con iconos | ✅ |
| **Git integration** | Estado de repositorios | ✅ |
| **Language versions** | Java, Node, Python, C# | ✅ |
| **Docker context** | Kubernetes/Docker info | ✅ |

## 🚀 Instalación

### 💡 Método 1: Una sola línea (recomendado)
```bash
curl -fsSL https://raw.githubusercontent.com/pitusaa/dotfiles/main/install.sh | bash
```
> **¿Qué hace?** Clona automáticamente el repositorio en `~/dotfiles` y ejecuta la instalación completa.

### 🔧 Método 2: Clonar manualmente
```bash
git clone https://github.com/pitusaa/dotfiles.git
cd dotfiles
chmod +x install-local.sh
./install-local.sh
```
> **¿Cuándo usar?** Si prefieres revisar el código antes o personalizar algo.

### ⚡ Método 3: Solo actualizar configuración
```bash
# Si ya tienes el repo clonado
cd ~/dotfiles
git pull origin main
./install-local.sh
```

## 📋 Requisitos Previos

- **Sistema operativo**: Linux (Ubuntu/Debian, Fedora, Arch) o macOS
- **Internet**: Para descargar dependencias
- **Permisos sudo**: Para instalar paquetes del sistema

## 🎯 Lo que incluye la instalación

1. **Dependencias del sistema**: `zsh`, `git`, `curl`, `wget`, `fontconfig`
2. **Oh My Zsh**: Framework principal
3. **Powerlevel10k**: Tema avanzado del prompt
4. **Fuentes Nerd Font**: Para iconos y símbolos
5. **Configuraciones personalizadas**: Archivos `.zshrc` y `.p10k.zsh`
6. **Backup automático**: De tus configuraciones existentes

## 📁 Estructura del Proyecto

```
dotfiles/
├── install.sh              # 🚀 Script principal (auto-clona repo)
├── install-local.sh        # 🔧 Script para ejecución local
├── README.md               # 📖 Esta documentación
├── terminal/
│   ├── .p10k.zsh          # ⚙️ Configuración de Powerlevel10k
│   ├── .zshrc             # 🐚 Configuración de zsh
│   └── install-fonts.sh   # 🔤 Instalador de fuentes
├── scripts/
│   ├── backup.sh          # 💾 Crear backups
│   └── restore.sh         # 🔄 Restaurar backups
└── docs/
    ├── terminal-setup.md  # 📘 Guía detallada
    └── troubleshooting.md # 🔧 Solución de problemas
```

## 🎨 Vista Previa del Terminal

### Proyecto Java
```bash
╭─ 🐧 ~/mi-proyecto-java ☕ main ✓        ☕17  ✓ 14:35
╰─❯ 
```

### Proyecto Web (Node.js)
```bash
╭─ 🐧 ~/mi-web-app 📦 main ✓           📦16  mi-app@1.0.0  ✓ 14:35
╰─❯ 
```

### Proyecto Python
```bash
╭─ 🐧 ~/mi-python-app 🐍 main ✓              🐍venv  ✓ 14:35
╰─❯ 
```

## ⚙️ Configuración Post-Instalación

### 1. Cambiar fuente del terminal
Configura tu terminal para usar la fuente **"MesloLGS NF"**:

- **GNOME Terminal**: Preferencias → Perfiles → Fuente personalizada
- **Kitty**: Añadir `font_family MesloLGS NF` a `~/.config/kitty/kitty.conf`
- **Alacritty**: Añadir en `~/.config/alacritty/alacritty.yml`:
  ```yaml
  font:
    normal:
      family: MesloLGS NF
  ```

### 2. Aplicar configuración
```bash
source ~/.zshrc
```

### 3. Reconfigurar si es necesario
```bash
p10k configure
```

## 🔧 Personalización

### Cambiar elementos del prompt
Edita `~/.p10k.zsh` y modifica estas secciones:

```bash
# Prompt izquierdo
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon
  dir
  vcs
  newline
  prompt_char
)

# Prompt derecho - añade/quita elementos
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status
  command_execution_time
  java_version
  node_version
  virtualenv
  time
)
```

### Cambiar colores
```bash
# Directorio
typeset -g POWERLEVEL9K_DIR_FOREGROUND=31

# Git
typeset -g POWERLEVEL9K_VCS_FOREGROUND=76

# Prompt char
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=76
```

## 🔄 Sincronización Entre Ordenadores

### Actualizar configuración
```bash
cd ~/dotfiles
git pull origin main
./install.sh
```

### Subir cambios propios
```bash
# Copiar configuraciones actuales al repo
cp ~/.p10k.zsh terminal/
cp ~/.zshrc terminal/

# Commit y push
git add .
git commit -m "Actualizar configuración"
git push origin main
```

## 🆘 Solución de Problemas

### Error: "Por favor ejecuta este script desde el directorio dotfiles"
**Causa**: Estás usando `install-local.sh` en lugar de `install.sh`
**Solución**: 
```bash
# Para instalación automática, usa:
curl -fsSL https://raw.githubusercontent.com/pitusaa/dotfiles/main/install.sh | bash

# O clona manualmente:
git clone https://github.com/pitusaa/dotfiles.git
cd dotfiles
./install-local.sh
```

### Error de permisos con curl
**Causa**: Algunos sistemas requieren permisos específicos
**Solución**:
```bash
# Descargar y ejecutar manualmente
wget https://raw.githubusercontent.com/pitusaa/dotfiles/main/install.sh
chmod +x install.sh
./install.sh
```

### Git no está instalado
**Solución**:
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install git

# Fedora  
sudo dnf install git

# macOS
xcode-select --install
```

### Iconos no se ven correctamente
1. Verificar que MesloLGS NF está instalada:
   ```bash
   fc-list | grep -i meslo
   ```
2. Cambiar fuente del terminal a "MesloLGS NF"
3. Reiniciar terminal

### Prompt no funciona
1. Verificar instalación de Powerlevel10k:
   ```bash
   ls ~/.oh-my-zsh/custom/themes/powerlevel10k
   ```
2. Reconfigurar:
   ```bash
   p10k configure
   ```

### Versiones de lenguajes no aparecen
Las versiones solo aparecen en proyectos relevantes:
- **Java**: Carpetas con archivos `.java` o `pom.xml`
- **Node.js**: Carpetas con `package.json`
- **Python**: Con virtual environment activado

### Restaurar configuración anterior
```bash
bash ~/dotfiles/scripts/restore.sh ~/.dotfiles-backup-FECHA
```

## 🤝 Contribuir

1. Fork del repositorio
2. Crear rama: `git checkout -b feature/mi-mejora`
3. Commit: `git commit -am 'Añadir nueva funcionalidad'`
4. Push: `git push origin feature/mi-mejora`
5. Pull Request

## 📜 Licencia

MIT License - Ver [LICENSE](LICENSE) para más detalles.

## 🙏 Agradecimientos

- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) por el increíble tema
- [Oh My Zsh](https://ohmyz.sh/) por el framework
- [Nerd Fonts](https://www.nerdfonts.com/) por las fuentes con iconos

---

⭐ **¿Te gusta este setup?** ¡Dale una estrella al repositorio!

📧 **¿Problemas o sugerencias?** Abre un [issue](https://github.com/pitusaa/dotfiles/issues)