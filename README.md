# 🚀 Dotfiles - Terminal de Desarrollo Profesional

> Configuración completa y automatizada para un terminal moderno con **zsh**, **Oh My Zsh**, **Powerlevel10k** optimizado para desarrollo en **Java**, **C#**, **JavaScript**, **Python** y **Docker**.

![GitHub stars](https://img.shields.io/github/stars/pitusaa/dotfiles?style=social)
![GitHub last commit](https://img.shields.io/github/last-commit/pitusaa/dotfiles)
![GitHub](https://img.shields.io/github/license/pitusaa/dotfiles)

## 🎯 Vista Previa

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

## ✨ Características Principales

- **🎨 Prompt de dos líneas** - Más espacio para comandos largos
- **⚡ Información contextual** - Solo muestra lo relevante según el proyecto
- **🔧 Stack de desarrollo** - Java, C#, Node.js, Python, Docker/K8s
- **🌈 Iconos y colores** - Interfaz visual moderna con Nerd Fonts
- **📦 Instalación con un comando** - Setup automático completo
- **🔄 Sincronización** - Misma configuración en todos tus ordenadores
- **✅ Auto-verificación** - Diagnóstico y corrección automática de problemas
- **💾 Backup automático** - Protege tu configuración actual

## 🛠️ Stack Incluido

| Componente | Descripción | Versión |
|------------|-------------|---------|
| **zsh** | Shell moderno y potente | Latest |
| **Oh My Zsh** | Framework con plugins | Latest |
| **Powerlevel10k** | Tema avanzado del prompt | Latest |
| **MesloLGS NF** | Fuente con iconos Nerd Font | v3.0+ |
| **Git integration** | Estado de repositorios en tiempo real | - |
| **Plugins** | autosuggestions, syntax-highlighting, docker, etc. | - |

## 🚀 Instalación

### ⚡ Método 1: Una línea (Recomendado)
```bash
curl -fsSL https://raw.githubusercontent.com/pitusaa/dotfiles/main/install.sh | bash
```
> **¿Qué hace?** Clona automáticamente el repositorio en `~/dotfiles` y ejecuta la instalación completa.

### 🔧 Método 2: Instalación manual
```bash
git clone https://github.com/pitusaa/dotfiles.git
cd dotfiles
chmod +x install-local.sh
./install-local.sh
```
> **¿Cuándo usar?** Si prefieres revisar el código antes o personalizar algo.

### 🔄 Método 3: Solo actualizar
```bash
# Si ya tienes el repo clonado
cd ~/dotfiles
git pull origin main
./install-local.sh
```

## 📋 Requisitos del Sistema

- **SO**: Linux (Ubuntu/Debian, Fedora, Arch) o macOS
- **Conexión a internet** para descargar dependencias
- **Permisos sudo** para instalar paquetes del sistema
- **Git** (se instala automáticamente si no está presente)

## ✅ Verificar Instalación

### 🔍 Diagnóstico Automático
```bash
# Verificar que todo funciona correctamente
cd ~/dotfiles
bash scripts/verify-install.sh
```

**El script verifica:**
- ✅ zsh instalado y configurado como shell por defecto
- ✅ Oh My Zsh y Powerlevel10k instalados correctamente
- ✅ Plugins necesarios (autosuggestions, syntax-highlighting)
- ✅ Archivos de configuración (.zshrc, .p10k.zsh)
- ✅ Fuentes MesloLGS NF instaladas
- ✅ Estructura de dotfiles completa

### 📊 Interpretación de Resultados
- **🎉 Éxito (>90%)** → Todo funciona perfectamente
- **⚠️ Advertencias (80-90%)** → Funcional con mejoras menores
- **🔧 Problemas menores (<80%)** → Requiere atención
- **❌ Errores críticos** → Necesita reinstalación

## 📁 Estructura del Proyecto

```
dotfiles/
├── install.sh              # 🚀 Instalador principal (auto-clona repo)
├── install-local.sh        # 🔧 Instalador para ejecución local
├── README.md               # 📖 Esta documentación
├── LICENSE                 # 📜 Licencia MIT
├── terminal/
│   ├── .p10k.zsh          # ⚙️ Configuración personalizada de Powerlevel10k
│   ├── .zshrc             # 🐚 Configuración de zsh con aliases y plugins
│   └── install-fonts.sh   # 🔤 Instalador automático de fuentes
├── scripts/
│   ├── backup.sh          # 💾 Crear backups de configuraciones
│   ├── restore.sh         # 🔄 Restaurar backups anteriores
│   └── verify-install.sh  # ✅ Verificar y diagnosticar instalación
└── docs/
    ├── terminal-setup.md  # 📘 Guía detallada del setup
    └── troubleshooting.md # 🔧 Solución de problemas avanzados
```

## ⚙️ Configuración Post-Instalación

### 1. 🔤 Configurar Fuente del Terminal
Cambiar la fuente de tu terminal a **"MesloLGS NF"**:

**GNOME Terminal:**
```bash
# Abrir preferencias
gnome-terminal --preferences
# Ir a: Perfiles → [tu perfil] → Fuente personalizada → MesloLGS NF
```

**Kitty:**
```bash
echo 'font_family MesloLGS NF' >> ~/.config/kitty/kitty.conf
```

**Alacritty:**
```yaml
# Añadir a ~/.config/alacritty/alacritty.yml
font:
  normal:
    family: MesloLGS NF
```

**VS Code:**
```json
// settings.json
{
  "terminal.integrated.fontFamily": "MesloLGS NF"
}
```

### 2. 🔄 Aplicar Configuración
```bash
# Recargar configuración
source ~/.zshrc

# Si aparecen advertencias, es normal en la primera carga
# Los plugins faltantes se instalarán automáticamente
```

### 3. 🎨 Personalizar (Opcional)
```bash
# Reconfigurar Powerlevel10k con asistente interactivo
p10k configure
```

## 🎯 Información Contextual por Proyecto

El prompt muestra información relevante automáticamente:

### ☕ Proyectos Java
- **Detecta**: archivos `.java`, `pom.xml`, `build.gradle`
- **Muestra**: versión de Java (☕17)
- **Herramientas**: Maven, Gradle completions

### 🔷 Proyectos .NET/C#
- **Detecta**: archivos `.cs`, `.csproj`, `.sln`
- **Muestra**: versión de .NET (🔷6.0)
- **Herramientas**: dotnet CLI completions

### 📦 Proyectos Web (Node.js)
- **Detecta**: `package.json`
- **Muestra**: versión de Node (📦18) + package name@version
- **Herramientas**: npm, yarn completions

### 🐍 Proyectos Python
- **Detecta**: virtual environment activo
- **Muestra**: nombre del venv (🐍myproject)
- **Herramientas**: pip, poetry completions

### 🐳 Docker/Kubernetes
- **Detecta**: comandos docker, kubectl, k9s
- **Muestra**: contexto de K8s (⚙️production)
- **Herramientas**: docker-compose, helm completions

## 🔧 Personalización Avanzada

### Modificar Elementos del Prompt
Editar `~/.p10k.zsh`:

```bash
# Prompt izquierdo (línea superior)
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon                 # Logo del OS
  dir                     # Directorio actual
  vcs                     # Estado de Git
  newline                 # Nueva línea
  prompt_char            # Cursor (❯)
)

# Prompt derecho (línea superior)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status                  # ✓/✗ éxito del comando
  command_execution_time  # Tiempo de ejecución
  java_version           # ☕ Java
  dotnet_version         # 🔷 .NET
  node_version           # 📦 Node.js
  package                # 📄 info package.json
  virtualenv             # 🐍 Python venv
  kubecontext            # ⚙️ Kubernetes
  time                   # 🕐 Hora
)
```

### Cambiar Colores
```bash
# Directorio
typeset -g POWERLEVEL9K_DIR_FOREGROUND=31

# Git
typeset -g POWERLEVEL9K_VCS_FOREGROUND=76

# Prompt char
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=76
```

### Añadir Aliases Personalizados
Editar `~/.zshrc` y añadir al final:

```bash
# Mis aliases personalizados
alias deploydev='kubectl apply -f k8s/dev/'
alias logs='docker-compose logs -f'
alias gitundo='git reset --soft HEAD~1'
```

## 🔄 Sincronización Entre Ordenadores

### Subir Cambios Propios
```bash
# Guardar configuraciones actuales en el repo
cd ~/dotfiles
cp ~/.p10k.zsh terminal/
cp ~/.zshrc terminal/

# Subir a GitHub
git add .
git commit -m "⚙️ Actualizar configuración personal"
git push origin main
```

### Aplicar Cambios en Otro Ordenador
```bash
# Descargar última versión
cd ~/dotfiles
git pull origin main

# Aplicar cambios
./install-local.sh
```

## 🆘 Solución de Problemas

### ❌ Error: "Por favor ejecuta este script desde el directorio dotfiles"
**Causa**: Estás usando el método incorrecto de instalación.

**Solución**:
```bash
# Para instalación automática, usa:
curl -fsSL https://raw.githubusercontent.com/pitusaa/dotfiles/main/install.sh | bash

# Para instalación manual:
git clone https://github.com/pitusaa/dotfiles.git
cd dotfiles
./install-local.sh
```

### ⚠️ Advertencias sobre "instant prompt"
**Causa**: Es normal en la primera carga o cuando se instalan plugins.

**Solución**:
```bash
# Es normal, pero si molesta:
echo 'typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet' >> ~/.zshrc
source ~/.zshrc
```

### 🔤 Iconos se ven como cuadrados o símbolos raros
**Causa**: Fuente MesloLGS NF no está configurada.

**Solución**:
```bash
# 1. Verificar que está instalada
fc-list | grep -i meslo

# 2. Si no aparece, reinstalar fuentes
cd ~/dotfiles
bash terminal/install-fonts.sh

# 3. Cambiar fuente del terminal a "MesloLGS NF"
# 4. Reiniciar terminal
```

### 🔌 Plugins no funcionan
**Causa**: Plugins no están instalados o hay error en .zshrc.

**Solución**:
```bash
# Diagnóstico automático
cd ~/dotfiles
bash scripts/verify-install.sh

# Si detecta problemas:
./install-local.sh  # Reinstalar

# Manual:
rm -rf ~/.oh-my-zsh/custom/plugins/zsh-*
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
```

### 🐍 Versiones de lenguajes no aparecen
**Causa**: Las versiones solo aparecen en proyectos relevantes.

**Para que aparezcan**:
- **Java**: Estar en carpeta con `.java`, `pom.xml` o `build.gradle`
- **Node.js**: Estar en carpeta con `package.json`
- **Python**: Tener virtual environment activado
- **.NET**: Estar en carpeta con archivos `.cs` o `.csproj`

### 💾 Restaurar Configuración Anterior
```bash
# Buscar backups disponibles
ls -la ~/.dotfiles-backup-*

# Restaurar específico
bash ~/dotfiles/scripts/restore.sh ~/.dotfiles-backup-20241215-143022
```

### 🔄 Reinstalación Completa
```bash
# Limpiar todo
rm -rf ~/.oh-my-zsh ~/.p10k.zsh ~/.zshrc

# Reinstalar desde cero
curl -fsSL https://raw.githubusercontent.com/pitusaa/dotfiles/main/install.sh | bash
```

## 🤝 Contribuir

1. **Fork** del repositorio
2. **Crear rama**: `git checkout -b feature/mi-mejora`
3. **Commit**: `git commit -am 'Añadir nueva funcionalidad'`
4. **Push**: `git push origin feature/mi-mejora`
5. **Pull Request**

### Ideas para contribuir:
- 🎨 Nuevos temas de colores
- 🔧 Soporte para más herramientas de desarrollo
- 📖 Mejoras en documentación
- 🐛 Corrección de bugs
- ✨ Nuevas funcionalidades

## 📜 Licencia

Este proyecto está bajo la [Licencia MIT](LICENSE). Eres libre de usar, modificar y distribuir este código.

## 🙏 Agradecimientos

- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Por el increíble tema
- [Oh My Zsh](https://ohmyz.sh/) - Por el framework base
- [Nerd Fonts](https://www.nerdfonts.com/) - Por las fuentes con iconos
- [Comunidad de desarrolladores](https://github.com/pitusaa/dotfiles/contributors) - Por las contribuciones

## 📞 Soporte

- **🐛 Reportar bugs**: [Issues en GitHub](https://github.com/pitusaa/dotfiles/issues)
- **💡 Sugerir mejoras**: [Discussions en GitHub](https://github.com/pitusaa/dotfiles/discussions)
- **📖 Documentación**: [Wiki del proyecto](https://github.com/pitusaa/dotfiles/wiki)

---

⭐ **¿Te gusta este setup?** ¡Dale una estrella al repositorio!

🚀 **¿Quieres estar al día?** Activa las notificaciones del repo para recibir actualizaciones.