#!/bin/bash
# =============================================================================
# INSTALADOR UNIVERSAL DO MACBOOK UTILITÁRIOS v4.0
# =============================================================================
# Este script instala o Macbook Utilitários em qualquer Mac
# Autor: Comunidade Open Source
# Repositório: https://github.com/[seu-usuario]/macbook-utilitarios
# =============================================================================

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

# Configurações
UTILS_DIR="$HOME/.mac-utils"
MACBOOK_DIR="$UTILS_DIR/macbook"
SCRIPT_NAME="macbook-utilitarios.sh"
ZSHRC="$HOME/.zshrc"

echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}     ${BOLD}🛠️  Instalador Macbook Utilitários v4.0${NC}              ${BLUE}║${NC}"
echo -e "${BLUE}║${NC}     ${CYAN}Kit de Utilitários para macOS${NC}                        ${BLUE}║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verifica se é Mac
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${YELLOW}⚠️${NC}  Aviso: Este script foi projetado para macOS."
    echo "    Detectado: $OSTYPE"
    read -p "Continuar mesmo assim? (s/N): " confirm
    if [[ ! "$confirm" =~ ^[Ss]$ ]]; then
        exit 1
    fi
fi

# Verifica se é zsh
if [[ -z "$ZSH_VERSION" ]]; then
    echo -e "${YELLOW}⚠️${NC}  Aviso: Este script foi projetado para ZSH (shell padrão do macOS)."
    echo "    Shell atual: $SHELL"
    echo ""
    echo "Para mudar para ZSH, execute: chsh -s /bin/zsh"
    echo ""
    read -p "Continuar mesmo assim? (s/N): " confirm
    if [[ ! "$confirm" =~ ^[Ss]$ ]]; then
        exit 1
    fi
fi

echo -e "${BLUE}📋${NC} ${BOLD}O que será instalado:${NC}"
echo "   • Script de utilitários em ~/.mac-utils/macbook/"
echo "   • Aliases e funções no ~/.zshrc"
echo "   • Backup automático do seu .zshrc original"
echo ""

# Procura o script fonte
SCRIPT_SOURCE=""

# Opção 1: Mesmo diretório do instalador
if [[ -f "$(dirname "$0")/macbook-utilitarios.sh" ]]; then
    SCRIPT_SOURCE="$(dirname "$0")/macbook-utilitarios.sh"
# Opção 2: Diretório atual
elif [[ -f "./macbook-utilitarios.sh" ]]; then
    SCRIPT_SOURCE="./macbook-utilitarios.sh"
# Opção 3: Pergunta ao usuário
else
    echo -e "${YELLOW}⚠️${NC}  Script fonte não encontrado automaticamente."
    echo ""
    echo "Por favor, informe o caminho completo do arquivo macbook-utilitarios.sh"
    echo "Exemplos:"
    echo "  • ~/Downloads/macbook-utilitarios.sh"
    echo "  • ./macbook-utilitarios.sh"
    echo "  • /Users/seuusuario/Documents/macbook-utilitarios.sh"
    echo ""
    read -e -p "Caminho do script: " SCRIPT_SOURCE
    
    # Expande ~ se usado
    SCRIPT_SOURCE="${SCRIPT_SOURCE/#\~/$HOME}"
    
    if [[ ! -f "$SCRIPT_SOURCE" ]]; then
        echo -e "${RED}❌${NC} Arquivo não encontrado: $SCRIPT_SOURCE"
        echo ""
        echo -e "${CYAN}💡${NC} Certifique-se de que:"
        echo "   1. Você baixou o arquivo macbook-utilitarios.sh"
        echo "   2. O caminho está correto"
        echo "   3. Você tem permissão para acessar o arquivo"
        exit 1
    fi
fi

echo -e "${BLUE}📄${NC} Script fonte: ${CYAN}$SCRIPT_SOURCE${NC}"
echo ""

read -p "Deseja continuar com a instalação? (S/n): " confirm
if [[ ! "$confirm" =~ ^[Ss]?$ ]]; then
    echo -e "${YELLOW}🚫${NC} Instalação cancelada."
    exit 0
fi

echo ""
echo -e "${BLUE}📦${NC} ${BOLD}Instalando...${NC}"
echo ""

# Cria estrutura de diretórios
echo -e "${CYAN}1.${NC} Criando estrutura de diretórios..."
mkdir -p "$MACBOOK_DIR" 2>/dev/null
mkdir -p "$UTILS_DIR/scripts" 2>/dev/null
if [[ $? -eq 0 ]]; then
    echo -e "   ${GREEN}✓${NC} ~/.mac-utils/"
    echo -e "   ${GREEN}✓${NC} ~/.mac-utils/macbook/"
    echo -e "   ${GREEN}✓${NC} ~/.mac-utils/scripts/"
else
    echo -e "   ${RED}✗${NC} Erro ao criar diretórios"
    exit 1
fi

# Backup do .zshrc
echo ""
echo -e "${CYAN}2.${NC} Criando backup do .zshrc..."
if [[ -f "$ZSHRC" ]]; then
    local backup_name="$ZSHRC.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$ZSHRC" "$backup_name"
    if [[ $? -eq 0 ]]; then
        echo -e "   ${GREEN}✓${NC} Backup criado: $backup_name"
    else
        echo -e "   ${YELLOW}⚠${NC}  Não foi possível criar backup"
    fi
else
    echo -e "   ${YELLOW}⚠${NC}  .zshrc não existe, será criado novo"
fi

# Copia o script
echo ""
echo -e "${CYAN}3.${NC} Copiando script..."
cp "$SCRIPT_SOURCE" "$MACBOOK_DIR/$SCRIPT_NAME"
if [[ $? -eq 0 ]]; then
    chmod +x "$MACBOOK_DIR/$SCRIPT_NAME"
    echo -e "   ${GREEN}✓${NC} Script instalado em ~/.mac-utils/macbook/"
else
    echo -e "   ${RED}✗${NC} Erro ao copiar script"
    exit 1
fi

# Atualiza o .zshrc
echo ""
echo -e "${CYAN}4.${NC} Configurando ~/.zshrc..."

# Remove referências antigas do macbook-utilitarios (se existirem)
if [[ -f "$ZSHRC" ]] && grep -q "macbook-utilitarios" "$ZSHRC" 2>/dev/null; then
    # Cria backup antes de modificar
    cp "$ZSHRC" "$ZSHRC.pre-update.$(date +%Y%m%d_%H%M%S)"
    
    # Remove linhas antigas (que contenham macbook-utilitarios)
    grep -v "macbook-utilitarios" "$ZSHRC" > "$ZSHRC.tmp" && mv "$ZSHRC.tmp" "$ZSHRC"
    echo -e "   ${GREEN}✓${NC} Referências antigas removidas"
fi

# Adiciona nova referência
echo "" >> "$ZSHRC"
echo "# ==========================================================" >> "$ZSHRC"
echo "# Macbook Utilitários v4.0 - Carregamento automático" >> "$ZSHRC"
echo "# Repositório: https://github.com/[seu-usuario]/macbook-utilitarios" >> "$ZSHRC"
echo "# ==========================================================" >> "$ZSHRC"
echo "source ~/.mac-utils/macbook/macbook-utilitarios.sh" >> "$ZSHRC"
echo "   ${GREEN}✓${NC} Configuração adicionada ao ~/.zshrc"

# Mensagem final
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}           ${BOLD}✨ Instalação concluída com sucesso!${NC}             ${GREEN}║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📁${NC} ${BOLD}Estrutura criada:${NC}"
echo "   ~/.mac-utils/"
echo "   ├── macbook/"
echo "   │   └── macbook-utilitarios.sh"
echo "   └── scripts/  (adicione seus próprios scripts aqui!)"
echo ""
echo -e "${BLUE}📝${NC} ${BOLD}Próximos passos:${NC}"
echo ""
echo "   ${CYAN}1.${NC} Recarregue o terminal:"
echo "      source ~/.zshrc"
echo ""
echo "   ${CYAN}2.${NC} Ou feche e abra um novo terminal"
echo ""
echo "   ${CYAN}3.${NC} Teste a instalação:"
echo "      mac_help"
echo ""
echo -e "${BLUE}💡${NC} ${BOLD}Comandos principais:${NC}"
echo ""
echo "   desinstalar              → Modo interativo (seleciona múltiplos apps)"
echo "   desinstalar NomeDoApp    → Remove app específico + arquivos residuais"
echo "   desinstalar-preview App  → Preview (mostra o que será removido)"
echo "   listar-apps              → Lista todos os apps instalados"
echo "   limpar                   → Menu de limpeza do sistema"
echo "   limpar-tudo              → Limpeza completa guiada"
echo "   matar-porta 3000         → Libera porta 3000"
echo "   listar-portas            → Lista portas em uso"
echo ""
echo -e "${CYAN}────────────────────────────────────────────────────────────${NC}"
echo ""
echo -e "${YELLOW}🎉${NC} ${BOLD}Dica:${NC} Use 'desinstalar' (sem argumentos) para modo interativo!"
echo ""
echo -e "${GREEN}✨${NC} Obrigado por usar Macbook Utilitários!"
echo ""
