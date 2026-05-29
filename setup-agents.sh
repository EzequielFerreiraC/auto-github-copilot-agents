#!/bin/bash

# =============================================================================
# GitHub Copilot Custom Agents Setup Script
# =============================================================================
# Instala os agentes customizados para uso no GitHub Copilot Chat do VS Code.
#
# Locais de instalação (conforme documentação oficial):
#   --project   .github/agents/          (visível no workspace)
#   --global    ~/.claude/agents/         (visível em todos os projetos)
#
# Ref: https://code.visualstudio.com/docs/copilot/customization/custom-agents
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLED=0

print_header() { echo -e "\n${BLUE}=== $1 ===${NC}\n"; }
print_ok()     { echo -e "  ${GREEN}+${NC} $1"; }
print_warn()   { echo -e "  ${YELLOW}!${NC} $1"; }
print_err()    { echo -e "  ${RED}x${NC} $1"; }
print_info()   { echo -e "  ${BLUE}i${NC} $1"; }

# =============================================================================
# Coleta todos os agentes numa array indexada
# =============================================================================

declare -a AGENT_FILES=()
declare -a AGENT_NAMES=()

load_agents() {
    local i=1
    for dir in "$SCRIPT_DIR"/a_frontend "$SCRIPT_DIR"/b_backend "$SCRIPT_DIR"/c_data "$SCRIPT_DIR"/d_automation "$SCRIPT_DIR"/e_documentation "$SCRIPT_DIR"/f_reviewer "$SCRIPT_DIR"/g_ai "$SCRIPT_DIR"/h_mobile "$SCRIPT_DIR"/i_architecture; do
        if [ -d "$dir" ]; then
            for file in "$dir"/*.md; do
                if [ -f "$file" ]; then
                    AGENT_FILES+=("$file")
                    local name
                    name=$(grep -m1 '^name:' "$file" | sed 's/^name: *//')
                    AGENT_NAMES+=("$name")
                    i=$((i + 1))
                fi
            done
        fi
    done
}

# =============================================================================
# Mostra lista numerada de agentes para seleção
# =============================================================================

show_numbered_list() {
    print_header "Agentes Disponíveis"

    local i=1
    local current_dir=""
    for file in "${AGENT_FILES[@]}"; do
        local dir_name
        dir_name="$(basename "$(dirname "$file")")"
        if [ "$dir_name" != "$current_dir" ]; then
            current_dir="$dir_name"
            echo -e "\n  ${GREEN}[$current_dir]${NC}"
        fi
        local name="${AGENT_NAMES[$((i-1))]}"
        printf "    ${YELLOW}%2d${NC}) %s\n" "$i" "$name"
        i=$((i + 1))
    done
    echo ""
}

# =============================================================================
# Parseia a seleção do usuário (ex: "1-19", "2-3", "1,5,7", "1-3,7,10-12")
# =============================================================================

parse_selection() {
    local input="$1"
    local total="${#AGENT_FILES[@]}"
    SELECTED_INDICES=()

    # Remove espaços
    input="${input// /}"

    # Divide por vírgula
    IFS=',' read -ra parts <<< "$input"
    for part in "${parts[@]}"; do
        if [[ "$part" =~ ^([0-9]+)-([0-9]+)$ ]]; then
            local start="${BASH_REMATCH[1]}"
            local end="${BASH_REMATCH[2]}"
            if [ "$start" -ge 1 ] && [ "$end" -le "$total" ] && [ "$start" -le "$end" ]; then
                for ((j=start; j<=end; j++)); do
                    SELECTED_INDICES+=("$j")
                done
            else
                print_err "Range inválido: $part (total: $total agentes)"
                return 1
            fi
        elif [[ "$part" =~ ^[0-9]+$ ]]; then
            if [ "$part" -ge 1 ] && [ "$part" -le "$total" ]; then
                SELECTED_INDICES+=("$part")
            else
                print_err "Número inválido: $part (total: $total agentes)"
                return 1
            fi
        else
            print_err "Formato inválido: $part"
            return 1
        fi
    done
    return 0
}

# =============================================================================
# Instala apenas os agentes selecionados
# =============================================================================

install_selected_agents() {
    local dest="$1"
    local mode="$2"

    mkdir -p "$dest"

    print_header "Instalando agentes selecionados em: $dest"

    for idx in "${SELECTED_INDICES[@]}"; do
        local file="${AGENT_FILES[$((idx-1))]}"
        local name="${AGENT_NAMES[$((idx-1))]}"
        local basename
        basename="$(basename "$file" .md)"

        cp "$file" "$dest/${basename}.md"
        print_ok "$name (${basename}.md)"
        INSTALLED=$((INSTALLED + 1))
    done

    echo ""
    print_ok "Total: $INSTALLED agentes instalados"
}

# =============================================================================
# Reload automático do VS Code
# =============================================================================

reload_vscode() {
    echo ""
    print_info "Agentes instalados com sucesso."
    print_warn "ACAO NECESSARIA: Recarregue o VS Code para ativar os agentes."
    echo ""
    echo "  Pressione ENTER para recarregar a janela do VS Code agora,"
    echo "  ou Ctrl+C para fazer manualmente depois."
    echo ""
    print_info "  (Ctrl+Shift+P > Developer: Reload Window)"
    echo ""
    read -rp "  Pressione ENTER para recarregar..."

    local root
    root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
    if command -v code &> /dev/null; then
        code --reuse-window "$root" 2>/dev/null
        sleep 1
        print_ok "Comando de reload enviado ao VS Code."
        print_info "Se a janela nao recarregou, faca manualmente: Ctrl+Shift+P > Developer: Reload Window"
    else
        print_warn "CLI do VS Code nao encontrado."
        print_info "Faca manualmente: Ctrl+Shift+P > Developer: Reload Window"
    fi
}

# =============================================================================
# Instalação no Projeto (.github/agents/)
# =============================================================================

install_project() {
    local root
    root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
    local dest="$root/.github/agents"
    install_selected_agents "$dest" "project"
}

# =============================================================================
# Instalação Global (~/.copilot/agents/)
# =============================================================================

install_global() {
    local dest="$HOME/.claude/agents"
    install_selected_agents "$dest" "global"
}


# =============================================================================
# Desinstala agentes de um diretório
# =============================================================================

uninstall_agents() {
    local dest="$1"
    local label="$2"
    local removed=0

    if [ ! -d "$dest" ]; then
        print_warn "Diretório não encontrado: $dest"
        print_info "Nenhum agente instalado em $label."
        return
    fi

    local files=("$dest"/*.md)
    if [ ! -f "${files[0]}" ]; then
        print_info "Nenhum agente encontrado em $dest"
        return
    fi

    print_header "Agentes instalados em $label ($dest)"

    local i=1
    local installed_files=()
    local installed_names=()
    for f in "$dest"/*.md; do
        if [ -f "$f" ]; then
            local fname
            fname="$(basename "$f")"
            local aname
            aname=$(grep -m1 '^name:' "$f" 2>/dev/null | sed 's/^name: *//' || echo "$fname")
            installed_files+=("$f")
            installed_names+=("$aname")
            printf "    ${YELLOW}%2d${NC}) %s\n" "$i" "$aname"
            i=$((i + 1))
        fi
    done

    local total=${#installed_files[@]}
    if [ "$total" -eq 0 ]; then
        print_info "Nenhum agente encontrado."
        return
    fi

    echo ""
    echo "  Selecione os agentes para remover."
    echo "  Formatos: 1-${total} (todos), 2-3, 1,5,7"
    echo "  Deixe vazio para remover todos."
    echo ""
    read -rp "  Agentes [1-${total}]: " selection

    if [ -z "$selection" ]; then
        selection="1-${total}"
    fi

    # Parse selection locally
    local indices=()
    selection="${selection// /}"
    IFS=',' read -ra parts <<< "$selection"
    for part in "${parts[@]}"; do
        if [[ "$part" =~ ^([0-9]+)-([0-9]+)$ ]]; then
            local start="${BASH_REMATCH[1]}"
            local end="${BASH_REMATCH[2]}"
            if [ "$start" -ge 1 ] && [ "$end" -le "$total" ] && [ "$start" -le "$end" ]; then
                for ((j=start; j<=end; j++)); do
                    indices+=("$j")
                done
            fi
        elif [[ "$part" =~ ^[0-9]+$ ]]; then
            if [ "$part" -ge 1 ] && [ "$part" -le "$total" ]; then
                indices+=("$part")
            fi
        fi
    done

    if [ ${#indices[@]} -eq 0 ]; then
        print_err "Seleção inválida."
        return
    fi

    echo ""
    print_warn "Removendo ${#indices[@]} agente(s) de $dest"
    read -rp "  Confirmar remoção? (s/n): " confirm
    if [[ ! "$confirm" =~ ^[SsYy]$ ]]; then
        print_info "Cancelado."
        return
    fi

    for idx in "${indices[@]}"; do
        local f="${installed_files[$((idx-1))]}"
        local n="${installed_names[$((idx-1))]}"
        rm -f "$f"
        print_ok "Removido: $n"
        removed=$((removed + 1))
    done

    echo ""
    print_ok "Total: $removed agentes removidos"

    # Remove diretório se vazio
    if [ -d "$dest" ] && [ -z "$(ls -A "$dest" 2>/dev/null)" ]; then
        rmdir "$dest" 2>/dev/null
        print_info "Diretório vazio removido: $dest"
    fi
}

uninstall_project() {
    local root
    root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
    local dest="$root/.github/agents"
    uninstall_agents "$dest" "Projeto"
}

uninstall_global() {
    local dest="$HOME/.claude/agents"
    uninstall_agents "$dest" "Global"
}

# =============================================================================
# Fluxo de seleção de agentes
# =============================================================================

select_agents() {
    show_numbered_list

    local total="${#AGENT_FILES[@]}"
    echo "  Selecione os agentes para instalar."
    echo "  Formatos aceitos:"
    echo "    1-${total}     (todos)"
    echo "    2-3       (agentes 2 e 3)"
    echo "    1,3,5-7   (agentes 1, 3, 5, 6 e 7)"
    echo ""
    read -rp "  Agentes [1-${total}]: " selection

    if [ -z "$selection" ]; then
        selection="1-${total}"
    fi

    if ! parse_selection "$selection"; then
        print_err "Seleção inválida. Tente novamente."
        select_agents
        return
    fi

    echo ""
    print_info "Agentes selecionados: ${#SELECTED_INDICES[@]}"
}

# =============================================================================
# Menu
# =============================================================================

show_menu() {
    print_header "GitHub Copilot Custom Agents Setup"

    echo "  1) Instalar no Projeto Atual  (.github/agents/)"
    echo "  2) Instalar Globalmente       (~/.claude/agents/)"
    echo "  3) Remover do Projeto Atual   (.github/agents/)"
    echo "  4) Remover Globalmente        (~/.claude/agents/)"
    echo "  5) Listar Agentes Disponíveis"
    echo "  6) Sair"
    echo ""
    read -rp "  Opção [1-6]: " choice

    case $choice in
        1)
            select_agents
            echo ""
            print_warn "Apos a instalacao, a janela do VS Code sera recarregada automaticamente."
            read -rp "  Continuar? (s/n): " confirm
            if [[ "$confirm" =~ ^[SsYy]$ ]]; then
                install_project
                reload_vscode
            else
                print_info "Cancelado."
                exit 0
            fi
            ;;
        2)
            select_agents
            echo ""
            print_warn "Apos a instalacao, a janela do VS Code sera recarregada automaticamente."
            read -rp "  Continuar? (s/n): " confirm
            if [[ "$confirm" =~ ^[SsYy]$ ]]; then
                install_global
                reload_vscode
            else
                print_info "Cancelado."
                exit 0
            fi
            ;;
        3) uninstall_project ;;
        4) uninstall_global ;;
        5) show_numbered_list; show_menu ;;
        6) echo ""; print_info "Cancelado."; exit 0 ;;
        *) print_err "Opção inválida"; show_menu ;;
    esac
}

# =============================================================================
# Pós-instalação
# =============================================================================

post_install() {
    print_header "Como usar"
    echo "  1. No Copilot Chat (Ctrl+Shift+I), clique no dropdown de agentes"
    echo "  2. Selecione o agente desejado da lista"
    echo "  3. Converse com o agente especializado"
    echo ""
    print_ok "Pronto!"
}

# =============================================================================
# Main
# =============================================================================

main() {
    load_agents

    if [ $# -eq 0 ]; then
        show_menu
    else
        case "$1" in
            --project)
                select_agents
                print_warn "A janela do VS Code sera recarregada automaticamente apos instalacao."
                install_project
                reload_vscode
                ;;
            --global)
                select_agents
                print_warn "A janela do VS Code sera recarregada automaticamente apos instalacao."
                install_global
                reload_vscode
                ;;
            --uninstall-project)
                uninstall_project
                ;;
            --uninstall-global)
                uninstall_global
                ;;
            --list)     show_numbered_list; exit 0 ;;
            --help|-h)
                echo "Uso: $0 [opção]"
                echo ""
                echo "  --project            Instala em .github/agents/ (workspace)"
                echo "  --global             Instala em ~/.claude/agents/ (todos projetos)"
                echo "  --uninstall-project  Remove agentes de .github/agents/"
                echo "  --uninstall-global   Remove agentes de ~/.claude/agents/"
                echo "  --list               Lista agentes disponíveis"
                echo "  --help               Mostra esta mensagem"
                exit 0
                ;;
            *) print_err "Opção desconhecida: $1"; exit 1 ;;
        esac
    fi

    post_install
}

main "$@"
