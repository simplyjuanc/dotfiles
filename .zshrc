export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git)
source $ZSH/oh-my-zsh.sh

# --- Environment ---
[[ -f ~/.env.local ]] && source ~/.env.local

export PLEO_DIR="$HOME/Desktop/repos/pleo"
export PATH="/opt/homebrew/opt/openjdk/bin:$HOME/.local/bin:$PATH"
export PNPM_HOME="$HOME/Library/pnpm"
[[ ":$PATH:" != *":$PNPM_HOME:"* ]] && export PATH="$PNPM_HOME:$PATH"
export PATH="$PATH:$HOME/.maestro/bin"

# --- Aliases ---
alias gw="./gradlew"
alias gwf="./gradlew formatKotlin"
alias gwd="./gradlew detekt"

alias oo="source $PLEO_DIR/bin/oo.sh"
alias dev="oo product-dev.AdministratorAccess"
alias stage="oo product-staging.team-retention-and-monetisation"
alias prod="oo product-production.team-retention-and-monetisation"
alias dev-creds="dev && $PLEO_DIR/bin/vault-rds-credentials.sh"
alias stage-creds="stage && $PLEO_DIR/bin/vault-rds-credentials.sh"
alias prod-creds="prod && $PLEO_DIR/bin/vault-rds-credentials.sh"

alias kgp="kubectl get pods"

# --- Functions ---
exercism () {
    local -a out
    out=(${(f)"$(command exercism "$@")"})
    printf '%s\n' "${out[@]}"
    if [[ $1 == "download" && -d "${out[-1]}" ]]; then
        cd "${out[-1]}" || return 1
    fi
}

# --- Tool init (order matters) ---
[[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]] && source "$HOME/google-cloud-sdk/path.zsh.inc"
[[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]] && source "$HOME/google-cloud-sdk/completion.zsh.inc"
eval "$(mise activate zsh)"
[[ $commands[kubectl] ]] && source ~/.zsh_kubectl_completion
eval "$(gh copilot alias -- zsh)"
eval "$(starship init zsh)"
