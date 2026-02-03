#!/bin/zsh
# =============================================================================
# MACBOOK UTILITÁRIOS - Kit de Limpeza e Gerenciamento (ZSH)
# Versão: 4.0 (Genérico - Compartilhável)
# Autor: Comunidade Open Source
# Repositório: https://github.com/[seu-usuario]/macbook-utilitarios
# Descrição: Script seguro e genérico para desinstalar apps, limpar sistema 
#            e utilitários dev em qualquer Mac
# =============================================================================

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# =============================================================================
# FUNÇÃO AUXILIAR: Mover para lixeira via linha de comando (sem GUI)
# =============================================================================
_macutils_mover_para_lixeira() {
    local arquivo="$1"
    if [[ -e "$arquivo" ]]; then
        # Gera nome único para evitar conflitos na lixeira
        local basename=$(basename "$arquivo")
        local timestamp=$(date +%Y%m%d_%H%M%S)
        local destino="$HOME/.Trash/${basename}_${timestamp}"
        
        # Tenta mover com mv primeiro
        if mv "$arquivo" "$destino" 2>/dev/null; then
            echo -e "${GREEN}✓${NC} Movido para lixeira: $basename"
            return 0
        fi
        
        # Se falhou, tenta com sudo
        echo -e "${YELLOW}⚠${NC}  Tentando com privilégios elevados..."
        if sudo mv "$arquivo" "$destino" 2>/dev/null; then
            echo -e "${GREEN}✓${NC} Movido para lixeira: $basename (com sudo)"
            return 0
        fi
        
        # Se ainda falhou, tenta com rm -rf como último recurso (com confirmação)
        echo -e "${RED}✗${NC} Não foi possível mover para lixeira: $basename"
        echo -ne "${YELLOW}⚠${NC}  Deseja tentar remover permanentemente? ${RED}(CUIDADO!)${NC} (s/N): "
        read -r resposta
        if [[ "$resposta" =~ ^[Ss]$ ]]; then
            if sudo rm -rf "$arquivo" 2>/dev/null; then
                echo -e "${GREEN}✓${NC} Removido permanentemente: $basename"
                return 0
            else
                echo -e "${RED}✗${NC} Falha ao remover: $basename"
                return 1
            fi
        fi
        
        echo -e "${YELLOW}🚫${NC} Arquivo mantido em: $arquivo"
        return 1
    fi
}

# =============================================================================
# FUNÇÃO AUXILIAR: Calcular tamanho do arquivo/pasta
# =============================================================================
_macutils_calcular_tamanho() {
    local arquivo="$1"
    if [[ -e "$arquivo" ]]; then
        du -sh "$arquivo" 2>/dev/null | cut -f1
    else
        echo "0B"
    fi
}

# =============================================================================
# FUNÇÃO AUXILIAR: Verificar se arquivo pertence ao app (heurística segura)
# =============================================================================
_macutils_verificar_arquivo_app() {
    local arquivo="$1"
    local app_name="$2"
    
    # Verifica se o nome do app está no caminho ou no nome do arquivo
    local basename_lower=$(basename "$arquivo" | tr '[:upper:]' '[:lower:]')
    local app_name_lower=$(echo "$app_name" | tr '[:upper:]' '[:lower:]')
    
    # Evita arquivos de sistema ou muito genéricos
    if [[ "$arquivo" =~ (^/System|^/usr|^/bin|^/sbin|^/Library/Fonts|^/Library/Frameworks) ]]; then
        return 1
    fi
    
    # Verifica se o nome do app está presente
    if [[ "$basename_lower" =~ "$app_name_lower" ]] || [[ "$arquivo" =~ "$app_name_lower" ]]; then
        return 0
    fi
    
    return 1
}

# =============================================================================
# FUNÇÃO AUXILIAR: Coletar todos os apps instalados
# =============================================================================
_macutils_coletar_apps_instalados() {
    local apps=()
    
    # Apps em /Applications (só processa se existir algum)
    if [[ -n $(ls /Applications/*.app 2>/dev/null) ]]; then
        for app in /Applications/*.app; do
            if [[ -d "$app" ]]; then
                apps+=($(basename "$app" .app))
            fi
        done
    fi
    
    # Apps em ~/Applications (só processa se existir algum)
    if [[ -d "$HOME/Applications" ]] && [[ -n $(ls "$HOME"/Applications/*.app 2>/dev/null) ]]; then
        for app in "$HOME"/Applications/*.app; do
            if [[ -d "$app" ]]; then
                apps+=($(basename "$app" .app))
            fi
        done
    fi
    
    # Remove duplicados e ordena
    apps=(${(u)apps})
    apps=(${(on)apps})
    
    echo "${apps[@]}"
}

# =============================================================================
# FUNÇÃO AUXILIAR: Desinstalar um único app
# =============================================================================
_macutils_uninstall_single() {
    local app_name="$1"
    local silent="${2:-false}"
    local dry_run="${3:-false}"
    
    # Array para armazenar arquivos encontrados
    local arquivos_encontrados=()
    
    # 1. Busca o .app em /Applications
    if [[ -d "/Applications/$app_name.app" ]]; then
        arquivos_encontrados+=("/Applications/$app_name.app")
    fi
    
    # 2. Busca em ~/Applications (apps do usuário)
    if [[ -d "$HOME/Applications/$app_name.app" ]]; then
        arquivos_encontrados+=("$HOME/Applications/$app_name.app")
    fi
    
    # 3. Busca arquivos relacionados em locais comuns (de forma segura)
    local locais_comuns=(
        "$HOME/Library/Application Support"
        "$HOME/Library/Preferences"
        "$HOME/Library/Caches"
        "$HOME/Library/Logs"
        "$HOME/Library/Saved Application State"
        "$HOME/Library/WebKit"
        "$HOME/Library/Containers"
        "$HOME/Library/Group Containers"
        "/Library/Application Support"
        "/Library/Preferences"
        "/Library/Caches"
        "/Library/Logs"
        "/Library/PrivilegedHelperTools"
    )
    
    # Busca em cada local
    for local in "${locais_comuns[@]}"; do
        if [[ -d "$local" ]]; then
            while IFS= read -r -d '' arquivo; do
                if _macutils_verificar_arquivo_app "$arquivo" "$app_name"; then
                    arquivos_encontrados+=("$arquivo")
                fi
            done < <(find "$local" -maxdepth 3 -name "*${app_name}*" -print0 2>/dev/null)
        fi
    done
    
    # Remove duplicados
    arquivos_encontrados=(${(u)arquivos_encontrados})
    
    # Verifica se encontrou algo
    if [[ ${#arquivos_encontrados[@]} -eq 0 ]]; then
        [[ "$silent" == false ]] && echo -e "${YELLOW}⚠️${NC} Nenhum arquivo encontrado para '$app_name'."
        return 1
    fi
    
    # Se for dry-run, só mostra
    if [[ "$dry_run" == true ]]; then
        echo -e "${CYAN}Arquivos que serão removidos:${NC}"
        for arquivo in "${arquivos_encontrados[@]}"; do
            local tamanho=$(_macutils_calcular_tamanho "$arquivo")
            echo "  • $arquivo (${YELLOW}$tamanho${NC})"
        done
        return 0
    fi
    
    # Move arquivos para lixeira
    local removidos=0
    for arquivo in "${arquivos_encontrados[@]}"; do
        if _macutils_mover_para_lixeira "$arquivo"; then
            ((removidos++))
        fi
    done
    
    if [[ "$silent" == false ]]; then
        echo -e "${GREEN}✅${NC} $removidos arquivo(s) movido(s) para lixeira."
    fi
    
    return 0
}

# =============================================================================
# FUNÇÃO AUXILIAR: Modo interativo de desinstalação múltipla
# =============================================================================
_macutils_uninstall_interativo() {
    echo -e "${BLUE}📱${NC} ${BOLD}Modo Interativo de Desinstalação${NC}"
    echo -e "${CYAN}────────────────────────────────────────────────────────────────${NC}"
    echo ""
    
    # Coleta todos os apps
    local apps=($(_macutils_coletar_apps_instalados))
    
    if [[ ${#apps[@]} -eq 0 ]]; then
        echo -e "${YELLOW}⚠️${NC} Nenhum aplicativo encontrado."
        return 1
    fi
    
    # Mostra lista numerada
    echo -e "${CYAN}Aplicativos instalados:${NC}"
    local i=1
    for app in "${apps[@]}"; do
        printf "${CYAN}%3d.${NC} %-40s\n" $i "$app"
        ((i++))
    done
    
    echo ""
    echo -e "${CYAN}────────────────────────────────────────────────────────────────${NC}"
    echo ""
    echo -e "${YELLOW}💡${NC} Digite os números dos apps que deseja desinstalar"
    echo -e "   Separe por vírgula (ex: 1,3,5) ou use hífen para intervalo (ex: 1-3)"
    echo -e "   Digite ${BOLD}0${NC} ou pressione Enter para cancelar"
    echo ""
    echo -ne "${CYAN}Apps para desinstalar:${NC} "
    read -r selecao
    
    # Se não selecionou nada ou 0, cancela
    if [[ -z "$selecao" ]] || [[ "$selecao" == "0" ]]; then
        echo -e "${YELLOW}🚫${NC} Operação cancelada."
        return 0
    fi
    
    # Parse da seleção (suporta: 1,3,5 ou 1-3 ou 1,2,4-6)
    local indices_selecionados=()
    local parts=(${(s:,:)selecao})
    
    for part in "${parts[@]}"; do
        part=$(echo "$part" | tr -d ' ')  # Remove espaços
        
        if [[ "$part" =~ ^[0-9]+-[0-9]+$ ]]; then
            # Intervalo (ex: 1-3)
            local start=$(echo "$part" | cut -d'-' -f1)
            local end=$(echo "$part" | cut -d'-' -f2)
            for ((j=start; j<=end; j++)); do
                if [[ $j -le ${#apps[@]} ]]; then
                    indices_selecionados+=($j)
                fi
            done
        elif [[ "$part" =~ ^[0-9]+$ ]]; then
            # Número único
            if [[ $part -le ${#apps[@]} ]]; then
                indices_selecionados+=($part)
            fi
        fi
    done
    
    # Remove duplicados
    indices_selecionados=(${(u)indices_selecionados})
    
    if [[ ${#indices_selecionados[@]} -eq 0 ]]; then
        echo -e "${YELLOW}⚠️${NC} Nenhum app válido selecionado."
        return 1
    fi
    
    # Mostra preview do que será removido
    echo ""
    echo -e "${YELLOW}⚠️${NC} ${BOLD}Apps selecionados para desinstalação:${NC}"
    echo -e "${CYAN}────────────────────────────────────────────────────────────────${NC}"
    
    for idx in "${indices_selecionados[@]}"; do
        local app_name="${apps[$idx]}"
        local tamanho_app=""
        
        # Calcula tamanho se possível
        if [[ -d "/Applications/$app_name.app" ]]; then
            tamanho_app=$(_macutils_calcular_tamanho "/Applications/$app_name.app")
        elif [[ -d "$HOME/Applications/$app_name.app" ]]; then
            tamanho_app=$(_macutils_calcular_tamanho "$HOME/Applications/$app_name.app")
        fi
        
        printf "${CYAN}  •${NC} %-40s ${YELLOW}%8s${NC}\n" "$app_name" "$tamanho_app"
    done
    
    echo -e "${CYAN}────────────────────────────────────────────────────────────────${NC}"
    echo ""
    echo -ne "${RED}🧨${NC} Tem certeza que deseja desinstalar ${BOLD}${#indices_selecionados[@]} app(s)${NC}? (s/N): "
    read -r confirmacao
    
    if [[ ! "$confirmacao" =~ ^[Ss]$ ]]; then
        echo -e "${YELLOW}🚫${NC} Operação cancelada."
        return 0
    fi
    
    # Desinstala cada app
    echo ""
    echo -e "${BLUE}🗑️${NC} Iniciando desinstalação..."
    echo ""
    
    local total_removidos=0
    for idx in "${indices_selecionados[@]}"; do
        local app_name="${apps[$idx]}"
        echo -e "${CYAN}▶${NC} Desinstalando: ${BOLD}$app_name${NC}"
        _macutils_uninstall_single "$app_name" false
        if [[ $? -eq 0 ]]; then
            ((total_removidos++))
        fi
        echo ""
    done
    
    echo -e "${GREEN}✨${NC} Concluído! $total_removidos app(s) desinstalado(s)."
    echo -e "${YELLOW}💡${NC} Verifique a lixeira se precisar recuperar algo."
}

# =============================================================================
# 1. DESINSTALAÇÃO SEGURA DE APLICATIVOS (Função Pública)
# =============================================================================
mac_uninstall() {
    local app_name="$1"
    local dry_run=false
    
    # Verifica flag de dry-run
    if [[ "$app_name" == "--preview" ]] || [[ "$app_name" == "-p" ]]; then
        dry_run=true
        app_name="$2"
    fi
    
    # Se não passou nome, entra no modo interativo
    if [[ -z "$app_name" ]]; then
        _macutils_uninstall_interativo
        return $?
    fi
    
    echo -e "${BLUE}🔍${NC} Buscando arquivos relacionados a '${BOLD}$app_name${NC}'..."
    echo ""
    
    # Executa desinstalação de um único app
    _macutils_uninstall_single "$app_name" false "$dry_run"
    local result=$?
    
    if [[ $result -eq 0 ]]; then
        if [[ "$dry_run" == true ]]; then
            echo ""
            echo -e "${GREEN}✅${NC} Preview concluído. Execute sem --preview para desinstalar."
        else
            echo ""
            echo -e "${GREEN}✨${NC} Limpeza concluída para '$app_name'."
            echo -e "${YELLOW}💡${NC} Verifique a lixeira se precisar recuperar algo."
        fi
    fi
    
    return $result
}

# =============================================================================
# 2. LISTAR APLICATIVOS INSTALADOS (Função Pública)
# =============================================================================
mac_list_apps() {
    local show_size=false
    local filter=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --size|-s)
                show_size=true
                shift
                ;;
            --filter|-f)
                filter="$2"
                shift 2
                ;;
            *)
                filter="$1"
                shift
                ;;
        esac
    done
    
    echo -e "${BLUE}📱${NC} Aplicativos instalados:"
    echo -e "${CYAN}────────────────────────────────────────────────────────────────${NC}"
    
    # Lista apps de /Applications
    echo -e "\n${BOLD}${CYAN}Aplicativos do Sistema (/Applications):${NC}"
    local apps=()
    for app in /Applications/*.app; do
        if [[ -d "$app" ]]; then
            local name=$(basename "$app" .app)
            if [[ -z "$filter" ]] || [[ "$name" =~ $filter ]]; then
                if [[ "$show_size" == true ]]; then
                    local size=$(_macutils_calcular_tamanho "$app")
                    printf "  %-40s ${YELLOW}%8s${NC}\n" "$name" "$size"
                else
                    echo "  $name"
                fi
            fi
        fi
    done
    
    # Lista apps de ~/Applications
    echo -e "\n${BOLD}${CYAN}Aplicativos do Usuário (~/Applications):${NC}"
    if [[ -d "$HOME/Applications" ]]; then
        local user_apps=()
        for app in "$HOME"/Applications/*.app; do
            if [[ -d "$app" ]]; then
                local name=$(basename "$app" .app)
                if [[ -z "$filter" ]] || [[ "$name" =~ $filter ]]; then
                    if [[ "$show_size" == true ]]; then
                        local size=$(_macutils_calcular_tamanho "$app")
                        printf "  %-40s ${YELLOW}%8s${NC}\n" "$name" "$size"
                    else
                        echo "  $name"
                    fi
                fi
            fi
        done
    fi
    
    echo -e "${CYAN}────────────────────────────────────────────────────────────────${NC}"
    echo ""
    echo -e "${CYAN}Dicas:${NC}"
    echo "  mac_list_apps --size           # Mostra tamanhos"
    echo "  mac_list_apps Chrome           # Filtra por nome"
    echo "  mac_uninstall                  # Modo interativo"
}

# =============================================================================
# 3. LIMPEZA SELETIVA DO SISTEMA (Funções Privadas)
# =============================================================================
_macutils_clean_caches() {
    echo -e "${BLUE}🗄️${NC} Analisando caches..."
    
    local cache_dir="$HOME/Library/Caches"
    local total_size=$(du -sh "$cache_dir" 2>/dev/null | cut -f1)
    
    echo -e "Tamanho total dos caches: ${YELLOW}$total_size${NC}"
    echo ""
    echo -e "${CYAN}Caches por aplicativo:${NC}"
    
    # Lista caches com tamanho
    local caches=()
    local i=1
    for dir in "$cache_dir"/*; do
        if [[ -d "$dir" ]]; then
            local name=$(basename "$dir")
            local size=$(_macutils_calcular_tamanho "$dir")
            printf "${CYAN}%2d.${NC} %-30s ${YELLOW}%8s${NC}\n" $i "$name" "$size"
            caches+=("$dir")
            ((i++))
        fi
    done
    
    echo ""
    echo -ne "${YELLOW}⚠️${NC} Deseja limpar algum cache específico? Digite o número (0 para cancelar): "
    read -r choice
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && [[ $choice -gt 0 ]] && [[ $choice -le ${#caches[@]} ]]; then
        local selected="${caches[$choice]}"
        echo -e "\n${YELLOW}🗑️${NC} Movendo $(basename "$selected") para lixeira..."
        _macutils_mover_para_lixeira "$selected"
    else
        echo -e "${YELLOW}🚫${NC} Nenhum cache removido."
    fi
}

_macutils_clean_logs() {
    echo -e "${BLUE}📝${NC} Buscando logs antigos (>30 dias)..."
    
    local log_dirs=("$HOME/Library/Logs" "/Library/Logs")
    local found=false
    
    for log_dir in "${log_dirs[@]}"; do
        if [[ -d "$log_dir" ]]; then
            local old_logs=$(find "$log_dir" -type f -mtime +30 2>/dev/null)
            if [[ -n "$old_logs" ]]; then
                found=true
                echo -e "\n${CYAN}Logs antigos em $log_dir:${NC}"
                echo "$old_logs" | while read -r log; do
                    local size=$(_macutils_calcular_tamanho "$log")
                    echo "  $log ${YELLOW}($size)${NC}"
                done
            fi
        fi
    done
    
    if [[ "$found" == false ]]; then
        echo -e "${GREEN}✅${NC} Nenhum log antigo encontrado."
        return 0
    fi
    
    echo ""
    echo -ne "${YELLOW}⚠️${NC} Deseja mover esses logs para a lixeira? (s/N): "
    read -r confirmation
    
    if [[ "$confirmation" =~ ^[Ss]$ ]]; then
        for log_dir in "${log_dirs[@]}"; do
            if [[ -d "$log_dir" ]]; then
                find "$log_dir" -type f -mtime +30 -exec bash -c '_macutils_mover_para_lixeira "$@"' bash {} \; 2>/dev/null
            fi
        done
        echo -e "${GREEN}✅${NC} Logs antigos removidos."
    fi
}

_macutils_clean_trash() {
    echo -e "${BLUE}🗑️${NC} Verificando lixeira..."
    
    local trash_size=$(du -sh ~/.Trash 2>/dev/null | cut -f1)
    echo -e "Tamanho da lixeira: ${YELLOW}$trash_size${NC}"
    
    echo ""
    echo -ne "${RED}🧨${NC} Deseja esvaziar a lixeira permanentemente? (s/N): "
    read -r confirmation
    
    if [[ "$confirmation" =~ ^[Ss]$ ]]; then
        osascript -e 'tell application "Finder" to empty trash' 2>/dev/null
        if [[ $? -eq 0 ]]; then
            echo -e "${GREEN}✅${NC} Lixeira esvaziada."
        else
            # Fallback
            rm -rf ~/.Trash/* 2>/dev/null
            echo -e "${GREEN}✅${NC} Lixeira esvaziada."
        fi
    else
        echo -e "${YELLOW}🚫${NC} Lixeira mantida."
    fi
}

_macutils_clean_downloads() {
    echo -e "${BLUE}📥${NC} Buscando arquivos antigos em Downloads..."
    
    local downloads_dir="$HOME/Downloads"
    local old_files=$(find "$downloads_dir" -type f -mtime +30 2>/dev/null | head -20)
    
    if [[ -z "$old_files" ]]; then
        echo -e "${GREEN}✅${NC} Nenhum arquivo antigo encontrado."
        return 0
    fi
    
    echo -e "${CYAN}Arquivos com mais de 30 dias:${NC}"
    echo "$old_files" | while read -r file; do
        local size=$(_macutils_calcular_tamanho "$file")
        echo "  $file ${YELLOW}($size)${NC}"
    done
    
    echo ""
    echo -ne "${YELLOW}⚠️${NC} Deseja mover esses arquivos para a lixeira? (s/N): "
    read -r confirmation
    
    if [[ "$confirmation" =~ ^[Ss]$ ]]; then
        find "$downloads_dir" -type f -mtime +30 -exec bash -c '_macutils_mover_para_lixeira "$@"' bash {} \; 2>/dev/null
        echo -e "${GREEN}✅${NC} Arquivos antigos removidos."
    fi
}

_macutils_clean_brew() {
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}⚠️${NC} Homebrew não está instalado."
        return 1
    fi
    
    echo -e "${BLUE}🍺${NC} Limpando Homebrew..."
    echo ""
    
    echo -e "${CYAN}1. Removendo downloads antigos...${NC}"
    brew cleanup -s
    
    echo ""
    echo -e "${CYAN}2. Removendo dependências não utilizadas...${NC}"
    brew autoremove
    
    echo ""
    echo -e "${CYAN}3. Verificando problemas...${NC}"
    brew doctor 2>&1 | head -20
    
    echo ""
    echo -e "${GREEN}✅${NC} Limpeza do Homebrew concluída."
}

_macutils_clean_memory() {
    echo -e "${BLUE}🧠${NC} Liberando memória RAM inativa..."
    echo ""
    
    # Mostra uso de memória antes
    echo -e "${CYAN}Memória antes:${NC}"
    vm_stat | head -6
    
    echo ""
    echo -e "${YELLOW}⚠️${NC} Será necessária senha de administrador..."
    sudo purge
    
    echo ""
    echo -e "${CYAN}Memória depois:${NC}"
    vm_stat | head -6
    
    echo ""
    echo -e "${GREEN}✅${NC} Memória liberada."
}

_macutils_clean_all() {
    echo -e "${BLUE}🧹${NC} ${BOLD}Limpeza Completa Guiada${NC}"
    echo ""
    echo "Este modo irá guiar você por cada tipo de limpeza."
    echo ""
    
    # Homebrew
    if command -v brew &> /dev/null; then
        echo -ne "${CYAN}1.${NC} Executar limpeza do Homebrew? (S/n): "
        read -r r
        [[ "$r" =~ ^[Ss]?$ ]] && _macutils_clean_brew
        echo ""
    fi
    
    # Caches
    echo -ne "${CYAN}2.${NC} Limpar caches seletivamente? (S/n): "
        read -r r
        [[ "$r" =~ ^[Ss]?$ ]] && _macutils_clean_caches
        echo ""
    
    # Logs
    echo -ne "${CYAN}3.${NC} Limpar logs antigos? (S/n): "
    read -r r
    [[ "$r" =~ ^[Ss]?$ ]] && _macutils_clean_logs
    echo ""
    
    # Downloads
    echo -ne "${CYAN}4.${NC} Limpar downloads antigos? (S/n): "
    read -r r
    [[ "$r" =~ ^[Ss]?$ ]] && _macutils_clean_downloads
    echo ""
    
    # Memory
    echo -ne "${CYAN}5.${NC} Liberar memória RAM? (S/n): "
    read -r r
    [[ "$r" =~ ^[Ss]?$ ]] && _macutils_clean_memory
    echo ""
    
    # Trash
    echo -ne "${CYAN}6.${NC} Esvaziar lixeira? (s/N): "
    read -r r
    [[ "$r" =~ ^[Ss]$ ]] && _macutils_clean_trash
    
    echo ""
    echo -e "${GREEN}✨${NC} Limpeza concluída!"
}

# Função Pública de Limpeza
mac_clean() {
    local target="$1"
    
    if [[ -z "$target" ]]; then
        echo -e "${BLUE}🧹${NC} ${BOLD}Kit de Limpeza Mac${NC}"
        echo ""
        echo -e "${CYAN}Uso:${NC} mac_clean <opção>"
        echo ""
        echo -e "${CYAN}Opções disponíveis:${NC}"
        echo "  ${BOLD}caches${NC}      - Limpa caches do usuário (com seleção)"
        echo "  ${BOLD}logs${NC}        - Limpa logs antigos (>30 dias)"
        echo "  ${BOLD}trash${NC}       - Esvazia a lixeira"
        echo "  ${BOLD}downloads${NC}   - Limpa downloads antigos (>30 dias)"
        echo "  ${BOLD}brew${NC}        - Limpa Homebrew (se instalado)"
        echo "  ${BOLD}memory${NC}      - Libera memória RAM inativa"
        echo "  ${BOLD}all${NC}         - Executa limpeza completa guiada"
        echo ""
        echo -e "${CYAN}Exemplos:${NC}"
        echo "  mac_clean caches"
        echo "  mac_clean all"
        return 0
    fi
    
    case "$target" in
        caches)
            _macutils_clean_caches
            ;;
        logs)
            _macutils_clean_logs
            ;;
        trash)
            _macutils_clean_trash
            ;;
        downloads)
            _macutils_clean_downloads
            ;;
        brew)
            _macutils_clean_brew
            ;;
        memory)
            _macutils_clean_memory
            ;;
        all)
            _macutils_clean_all
            ;;
        *)
            echo -e "${RED}❌${NC} Opção inválida: $target"
            echo "Use 'mac_clean' para ver opções disponíveis."
            return 1
            ;;
    esac
}

# =============================================================================
# 4. UTILITÁRIOS PARA DESENVOLVEDORES (Funções Públicas)
# =============================================================================
mac_kill_port() {
    local port="$1"
    
    if [[ -z "$port" ]]; then
        echo -e "${RED}❌${NC} Por favor, informe o número da porta."
        echo ""
        echo -e "${CYAN}Uso:${NC} mac_kill_port <número_da_porta>"
        echo ""
        echo -e "${CYAN}Exemplos:${NC}"
        echo "  mac_kill_port 3000"
        echo "  mac_kill_port 8080"
        echo "  mac_kill_port 5000"
        return 1
    fi
    
    echo -e "${BLUE}🔍${NC} Buscando processo na porta ${BOLD}$port${NC}..."
    
    # Encontra o processo
    local pid=$(lsof -ti :$port 2>/dev/null)
    
    if [[ -z "$pid" ]]; then
        echo -e "${YELLOW}⚠️${NC} Nenhum processo encontrado na porta $port."
        
        # Mostra portas em uso
        echo ""
        echo -e "${CYAN}Principais portas em uso:${NC}"
        lsof -PiTCP -sTCP:LISTEN 2>/dev/null | head -10
        return 0
    fi
    
    # Mostra detalhes do processo
    local process_info=$(ps -p $pid -o comm= 2>/dev/null)
    echo -e "${YELLOW}⚠️${NC} Processo encontrado:"
    echo "  PID: $pid"
    echo "  Comando: $process_info"
    echo "  Porta: $port"
    
    echo ""
    echo -ne "${RED}💀${NC} Deseja matar este processo? (s/N): "
    read -r confirmation
    
    if [[ "$confirmation" =~ ^[Ss]$ ]]; then
        kill -9 $pid 2>/dev/null
        if [[ $? -eq 0 ]]; then
            echo -e "${GREEN}✅${NC} Processo $pid morto com sucesso. Porta $port liberada."
        else
            echo -e "${RED}❌${NC} Erro ao matar processo. Tentando com sudo..."
            sudo kill -9 $pid
            if [[ $? -eq 0 ]]; then
                echo -e "${GREEN}✅${NC} Processo morto com sucesso. Porta $port liberada."
            else
                echo -e "${RED}❌${NC} Não foi possível matar o processo."
            fi
        fi
    else
        echo -e "${YELLOW}🚫${NC} Operação cancelada."
    fi
}

mac_list_ports() {
    echo -e "${BLUE}🔌${NC} Portas TCP em uso:"
    echo -e "${CYAN}────────────────────────────────────────────────────────────────${NC}"
    
    lsof -PiTCP -sTCP:LISTEN 2>/dev/null | awk 'NR==1 || $8 ~ /LISTEN/ {printf "%-12s %-8s %-12s %-20s\n", $1, $2, $8, $9}'
    
    echo -e "${CYAN}────────────────────────────────────────────────────────────────${NC}"
    echo ""
    echo -e "${CYAN}Uso:${NC} mac_kill_port <número> para matar um processo"
}

mac_disk_usage() {
    echo -e "${BLUE}💾${NC} Uso de disco:"
    echo ""
    
    # Uso geral
    df -h / | awk 'NR==2 {printf "Sistema: %s usado de %s (%s disponível)\n", $3, $2, $4}'
    
    echo ""
    echo -e "${CYAN}Top 10 maiores pastas do usuário:${NC}"
    du -sh ~/{Applications,Documents,Downloads,Desktop,Library,Movies,Music,Pictures} 2>/dev/null | sort -hr | head -10
    
    echo ""
    echo -e "${CYAN}Caches:${NC}"
    du -sh ~/Library/Caches 2>/dev/null
    
    echo ""
    echo -e "${CYAN}Lixeira:${NC}"
    du -sh ~/.Trash 2>/dev/null
}

mac_memory() {
    echo -e "${BLUE}🧠${NC} Uso de memória:"
    echo ""
    vm_stat | head -10
    
    echo ""
    echo -e "${CYAN}Top 5 processos por memória:${NC}"
    ps aux | sort -nr -k 4 | head -5 | awk '{printf "%-20s %5s%% %8s\n", $11, $4, $6}'
}

# =============================================================================
# 5. ALIASES FÁCEIS DE USAR (em português)
# =============================================================================
alias desinstalar='mac_uninstall'
alias desinstalar-preview='mac_uninstall --preview'
alias listar-apps='mac_list_apps'
alias limpar='mac_clean'
alias limpar-tudo='mac_clean all'
alias limpar-caches='mac_clean caches'
alias limpar-logs='mac_clean logs'
alias limpar-lixeira='mac_clean trash'
alias limpar-brew='mac_clean brew'
alias matar-porta='mac_kill_port'
alias listar-portas='mac_list_ports'
alias espaco-disco='mac_disk_usage'
alias uso-memoria='mac_memory'

# =============================================================================
# 6. AJUDA E DOCUMENTAÇÃO
# =============================================================================
mac_help() {
    echo -e "${BLUE}🛠️${NC}  ${BOLD}Macbook Utilitários - Guia de Uso${NC}"
    echo ""
    echo -e "${CYAN}┌──────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC}  ${BOLD}GERENCIAMENTO DE APLICATIVOS${NC}                            ${CYAN}│${NC}"
    echo -e "${CYAN}├──────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC}  ${YELLOW}desinstalar <app>${NC}         - Desinstala app + arquivos    ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}  ${YELLOW}desinstalar${NC}               - Modo interativo (seleciona  ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}  ${NC}                            múltiplos apps)                ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}  ${YELLOW}desinstalar-preview <app>${NC} - Preview do que será removido ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}  ${YELLOW}listar-apps${NC}               - Lista apps instalados        ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}  ${YELLOW}listar-apps --size${NC}        - Lista com tamanhos           ${CYAN}│${NC}"
    echo -e "${CYAN}├──────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC}  ${BOLD}LIMPEZA DO SISTEMA${NC}                                        ${CYAN}│${NC}"
    echo -e "${CYAN}├──────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC}  ${YELLOW}limpar${NC}                    - Mostra opções de limpeza       ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}  ${YELLOW}limpar-tudo${NC}               - Limpeza completa guiada      ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}  ${YELLOW}limpar-caches${NC}             - Limpa caches (seletivo)      ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}  ${YELLOW}limpar-logs${NC}               - Limpa logs antigos           ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}  ${YELLOW}limpar-lixeira${NC}            - Esvazia lixeira              ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}  ${YELLOW}limpar-brew${NC}               - Limpa Homebrew             ${CYAN}│${NC}"
    echo -e "${CYAN}├──────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC}  ${BOLD}UTILITÁRIOS DEV${NC}                                           ${CYAN}│${NC}"
    echo -e "${CYAN}├──────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC}  ${YELLOW}matar-porta <número>${NC}      - Libera porta em uso          ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}  ${YELLOW}listar-portas${NC}             - Lista portas em uso          ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}  ${YELLOW}espaco-disco${NC}              - Mostra uso de disco          ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}  ${YELLOW}uso-memoria${NC}               - Mostra uso de memória        ${CYAN}│${NC}"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "${GREEN}✨${NC} Dica: Use TAB para autocomplete dos comandos"
    echo -e "${GREEN}✨${NC} Todos os comandos têm confirmação antes de deletar"
    echo -e "${GREEN}✨${NC} Arquivos vão para a lixeira (podem ser recuperados)"
}

# =============================================================================
# MENSAGEM DE BOAS-VINDAS (apenas na primeira vez por sessão)
# =============================================================================
if [[ -z "$MAC_UTILS_LOADED" ]]; then
    echo ""
    echo -e "${GREEN}✅${NC} Macbook Utilitários carregados!"
    echo -e "   Digite ${CYAN}mac_help${NC} para ver os comandos disponíveis"
    echo ""
    export MAC_UTILS_LOADED=true
fi
