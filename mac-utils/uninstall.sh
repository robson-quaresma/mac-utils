#!/bin/bash
# =============================================================================
# DESINSTALADOR DO MACBOOK UTILITÁRIOS
# =============================================================================
# Remove completamente o Macbook Utilitários do sistema
# =============================================================================

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

UTILS_DIR="$HOME/.mac-utils"
ZSHRC="$HOME/.zshrc"

echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}     ${BOLD}🗑️  Desinstalador Macbook Utilitários${NC}                ${BLUE}║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verifica se está instalado
if [[ ! -d "$UTILS_DIR" ]] && ! grep -q "macbook-utilitarios" "$ZSHRC" 2>/dev/null; then
    echo -e "${YELLOW}⚠️${NC}  Macbook Utilitários não parece estar instalado."
    echo ""
    echo "Diretório não encontrado: $UTILS_DIR"
    echo "Referência no .zshrc não encontrada."
    echo ""
    read -p "Deseja continuar mesmo assim? (s/N): " confirm
    if [[ ! "$confirm" =~ ^[Ss]$ ]]; then
        exit 0
    fi
fi

echo -e "${YELLOW}⚠️${NC}  ${BOLD}Atenção:${NC} Esta ação irá:"
echo "   • Remover a linha de configuração do ~/.zshrc"
echo "   • Deletar o diretório ~/.mac-utils/"
echo "   • Fazer backup do ~/.zshrc atual antes de modificar"
echo ""
echo -e "${GREEN}✓${NC} Seus arquivos na lixeira permanecem seguros"
echo ""

read -p "Tem certeza que deseja desinstalar? (s/N): " confirm
if [[ ! "$confirm" =~ ^[Ss]$ ]]; then
    echo -e "${YELLOW}🚫${NC} Desinstalação cancelada."
    exit 0
fi

echo ""
echo -e "${BLUE}🗑️${NC} ${BOLD}Desinstalando...${NC}"
echo ""

# Backup do .zshrc atual
echo -e "${CYAN}1.${NC} Criando backup do .zshrc atual..."
cp "$ZSHRC" "$ZSHRC.pre-uninstall.$(date +%Y%m%d_%H%M%S)"
echo -e "   ${GREEN}✓${NC} Backup criado"

# Remove linha do .zshrc
echo ""
echo -e "${CYAN}2.${NC} Removendo configuração do ~/.zshrc..."
if grep -q "macbook-utilitarios" "$ZSHRC" 2>/dev/null; then
    grep -v "macbook-utilitarios" "$ZSHRC" > "$ZSHRC.tmp" && mv "$ZSHRC.tmp" "$ZSHRC"
    echo -e "   ${GREEN}✓${NC} Linha removida do ~/.zshrc"
else
    echo -e "   ${YELLOW}⚠${NC}  Configuração não encontrada no ~/.zshrc"
fi

# Remove diretório
echo ""
echo -e "${CYAN}3.${NC} Removendo arquivos..."
if [[ -d "$UTILS_DIR" ]]; then
    rm -rf "$UTILS_DIR"
    echo -e "   ${GREEN}✓${NC} Diretório ~/.mac-utils/ removido"
else
    echo -e "   ${YELLOW}⚠${NC}  Diretório não encontrado"
fi

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}          ${BOLD}✅ Desinstalação concluída com sucesso!${NC}           ${GREEN}║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📝${NC} ${BOLD}Próximos passos:${NC}"
echo ""
echo "   ${CYAN}1.${NC} Feche e abra um novo terminal"
echo "   ${CYAN}2.${NC} Os comandos não estarão mais disponíveis"
echo ""
echo -e "${BLUE}💾${NC} ${BOLD}Backups criados:${NC}"
echo "   • ~/.zshrc.pre-uninstall.$(date +%Y%m%d_%H%M%S)"
echo ""
echo -e "${CYAN}────────────────────────────────────────────────────────────${NC}"
echo ""
echo -e "${YELLOW}🔄${NC} ${BOLD}Mudou de ideia?${NC}"
echo "   Para reinstalar, execute:"
echo "   curl -fsSL https://raw.githubusercontent.com/[seu-usuario]/macbook-utilitarios/main/install.sh | bash"
echo ""
echo -e "${GREEN}✨${NC} Obrigado por usar o Macbook Utilitários!"
echo ""
