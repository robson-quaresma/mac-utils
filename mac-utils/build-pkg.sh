#!/bin/bash
# =============================================================================
# SCRIPT PARA CRIAR INSTALADOR .PKG (Mac OS X Installer Package)
# =============================================================================
# Este script cria um instalador clicável .pkg para distribuição
# O usuário final só precisa clicar duas vezes no arquivo .pkg
# =============================================================================

set -e

# Configurações
APP_NAME="MacbookUtilitarios"
VERSION="4.0.0"
IDENTIFIER="com.github.mac-utils.macbookutilitarios"

# Diretórios
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/build"
PKG_ROOT="$BUILD_DIR/pkgroot"
RESOURCES_DIR="$BUILD_DIR/resources"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}     🛠️  Criando Instalador .pkg para Macbook Utilitários     ${BLUE}║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verifica se está no macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ Erro:${NC} Este script só funciona no macOS."
    exit 1
fi

# Verifica se tem os comandos necessários
if ! command -v pkgbuild &> /dev/null; then
    echo -e "${RED}❌ Erro:${NC} pkgbuild não encontrado."
    echo "Você precisa do Xcode Command Line Tools instalado."
    echo "Execute: xcode-select --install"
    exit 1
fi

# Limpa e cria diretórios
echo "📁 Preparando estrutura..."
rm -rf "$BUILD_DIR"
mkdir -p "$PKG_ROOT"
mkdir -p "$RESOURCES_DIR"

# Cria a estrutura que será instalada
# ~/.mac-utils/macbook/
INSTALL_DIR="$PKG_ROOT/Users/Shared/mac-utils/macbook"
mkdir -p "$INSTALL_DIR"

# Copia os arquivos
echo "📄 Copiando arquivos..."
cp "$SCRIPT_DIR/macbook-utilitarios.sh" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/install.sh" "$SCRIPT_DIR/uninstall.sh" "$SCRIPT_DIR/"*.md "$SCRIPT_DIR/LICENSE" "$INSTALL_DIR/" 2>/dev/null || true

# Cria script de pós-instalação (postinstall)
mkdir -p "$PKG_ROOT/Scripts"
cat > "$PKG_ROOT/Scripts/postinstall" << 'EOF'
#!/bin/bash

# Script executado após a instalação do .pkg
# Configura o ambiente para o usuário atual

# Cria diretório no home do usuário
mkdir -p "$HOME/.mac-utils/macbook"

# Copia o script principal
if [[ -d "/Users/Shared/mac-utils/macbook" ]]; then
    cp "/Users/Shared/mac-utils/macbook/macbook-utilitarios.sh" "$HOME/.mac-utils/macbook/"
    chmod +x "$HOME/.mac-utils/macbook/macbook-utilitarios.sh"
fi

# Adiciona ao .zshrc se ainda não estiver lá
if ! grep -q "macbook-utilitarios.sh" "$HOME/.zshrc" 2>/dev/null; then
    echo "" >> "$HOME/.zshrc"
    echo "# Macbook Utilitários v4.0" >> "$HOME/.zshrc"
    echo "source ~/.mac-utils/macbook/macbook-utilitarios.sh" >> "$HOME/.zshrc"
fi

# Mostra mensagem de sucesso para o usuário
osascript -e 'display dialog "Macbook Utilitários foi instalado com sucesso!\n\nPara começar:\n1. Abra um novo terminal\n2. Digite: mac_help\n\nObrigado por usar!" buttons {"OK"} default button "OK" with icon note'

exit 0
EOF

chmod +x "$PKG_ROOT/Scripts/postinstall"

# Cria o arquivo Distribution.xml (interface do instalador)
cat > "$BUILD_DIR/Distribution.xml" << EOF
<?xml version="1.0" encoding="utf-8"?>
<installer-gui-script minSpecVersion="1">
    <title>Macbook Utilitários v${VERSION}</title>
    <organization>${IDENTIFIER}</organization>
    <domains enable_anywhere="true"/>
    <options customize="never" require-scripts="true" rootVolumeOnly="false" />
    
    <welcome file="welcome.txt"/>
    <conclusion file="conclusion.txt"/>
    
    <pkg-ref id="${IDENTIFIER}">
        <pkg-ref id="${IDENTIFIER}.app"/>
    </pkg-ref>
    
    <choices-outline>
        <line choice="default">
            <pkg-ref id="${IDENTIFIER}"/>
        </line>
    </choices-outline>
    
    <choice id="default" title="Macbook Utilitários" description="Kit de utilitários para macOS">
        <pkg-ref id="${IDENTIFIER}"/>
    </choice>
    
    <pkg-ref id="${IDENTIFIER}" version="${VERSION}" auth="root">${APP_NAME}.pkg</pkg-ref>
</installer-gui-script>
EOF

# Cria arquivo de boas-vindas
cat > "$RESOURCES_DIR/welcome.txt" << 'EOF'
Bem-vindo ao instalador do Macbook Utilitários!

Este instalador vai configurar ferramentas úteis para gerenciar seu Mac:

✓ Desinstalar apps completamente (incluindo arquivos escondidos)
✓ Limpar caches e liberar espaço
✓ Liberar portas em uso
✓ Monitorar uso de disco e memória

Tudo via linha de comando, de forma simples e segura!

Clique em "Continuar" para instalar.
EOF

# Cria arquivo de conclusão
cat > "$RESOURCES_DIR/conclusion.txt" << 'EOF'
Instalação Concluída!

O Macbook Utilitários foi instalado com sucesso.

Próximos passos:
1. Feche este instalador
2. Abra o Terminal (ou iTerm)
3. Digite: mac_help

Isso vai mostrar todos os comandos disponíveis!

Dica: Use 'desinstalar' (sem argumentos) para modo interativo e selecionar múltiplos apps.

Aproveite! 🎉
EOF

# Cria o pacote componente
echo "📦 Criando pacote..."
pkgbuild \
    --root "$PKG_ROOT" \
    --identifier "$IDENTIFIER" \
    --version "$VERSION" \
    --scripts "$PKG_ROOT/Scripts" \
    --install-location "/" \
    "$BUILD_DIR/${APP_NAME}.pkg"

# Cria o instalador final (productbuild)
echo "🎁 Criando instalador final..."
productbuild \
    --distribution "$BUILD_DIR/Distribution.xml" \
    --resources "$RESOURCES_DIR" \
    --package-path "$BUILD_DIR" \
    "$SCRIPT_DIR/${APP_NAME}-${VERSION}.pkg"

# Limpa arquivos temporários
echo "🧹 Limpando..."
rm -rf "$BUILD_DIR"

echo ""
echo -e "${GREEN}✅ Instalador criado com sucesso!${NC}"
echo ""
echo "📄 Arquivo: ${APP_NAME}-${VERSION}.pkg"
echo "📍 Local: $SCRIPT_DIR/"
echo ""
echo "Este arquivo pode ser distribuído para usuários."
echo "Eles só precisam clicar duas vezes para instalar!"
echo ""
