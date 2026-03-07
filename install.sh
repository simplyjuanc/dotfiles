#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info()    { echo "[info] $*"; }
success() { echo "[ok]   $*"; }
warn()    { echo "[warn] $*"; }

# ---------------------------------------------------------------------------
# 1. Homebrew
# ---------------------------------------------------------------------------
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  success "Homebrew already installed"
fi

# ---------------------------------------------------------------------------
# 2. Brew packages
# ---------------------------------------------------------------------------
BREW_PACKAGES=(mise starship gh git-lfs pnpm)

for pkg in "${BREW_PACKAGES[@]}"; do
  if brew list --formula "$pkg" &>/dev/null; then
    success "$pkg already installed"
  else
    info "Installing $pkg..."
    brew install "$pkg"
  fi
done

# ---------------------------------------------------------------------------
# 3. Oh My Zsh
# ---------------------------------------------------------------------------
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  success "Oh My Zsh already installed"
else
  info "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# ---------------------------------------------------------------------------
# 4. Starship config
# ---------------------------------------------------------------------------
mkdir -p "$HOME/.config"
if [[ -f "$HOME/.config/starship.toml" ]]; then
  success "starship.toml already exists"
else
  info "Generating starship config..."
  starship preset plain-text-symbols -o "$HOME/.config/starship.toml"
fi

# ---------------------------------------------------------------------------
# 5. mise: Java + Node
# ---------------------------------------------------------------------------
if ! mise list java &>/dev/null | grep -q .; then
  info "Installing Java via mise..."
  mise install java@latest
fi
if ! mise list node &>/dev/null | grep -q .; then
  info "Installing Node via mise..."
  mise install node@latest
fi

# ---------------------------------------------------------------------------
# 6. kubectl completion cache
# ---------------------------------------------------------------------------
if [[ -f "$HOME/.zsh_kubectl_completion" ]]; then
  success "kubectl completion cache already exists"
elif command -v kubectl &>/dev/null; then
  info "Generating kubectl completion cache..."
  kubectl completion zsh > "$HOME/.zsh_kubectl_completion"
else
  warn "kubectl not found — skipping completion cache (run 'kubectl completion zsh > ~/.zsh_kubectl_completion' after installing)"
fi

# ---------------------------------------------------------------------------
# 7. .env.local
# ---------------------------------------------------------------------------
if [[ -f "$HOME/.env.local" ]]; then
  success ".env.local already exists"
else
  warn ".env.local not found — creating empty template at ~/.env.local"
  cat > "$HOME/.env.local" <<'EOF'
export JOB_RUNR_REPO_PASSWORD=""
export STRIPE_API_KEY=""
export ZUORA_CLIENT=""
export ZUORA_SECRET=""
export VITALLY_TOKEN=""
export ENV0_API_KEY=""
export ENV0_API_SECRET=""
export TF_TOKEN_api_env0_com=""
export NPM_TOKEN=""
EOF
  chmod 600 "$HOME/.env.local"
  warn "Fill in ~/.env.local with your secrets before using the shell."
fi

# ---------------------------------------------------------------------------
# 8. Symlinks
# ---------------------------------------------------------------------------
SYMLINKS=(
  ".zshrc"
  ".npmrc"
  ".gitconfig"
  ".editorconfig"
)

for file in "${SYMLINKS[@]}"; do
  target="$HOME/$file"
  source="$DOTFILES/$file"

  if [[ ! -f "$source" ]]; then
    warn "$source not found in dotfiles — skipping"
    continue
  fi

  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    success "$file already symlinked"
  else
    if [[ -f "$target" && ! -L "$target" ]]; then
      info "Backing up existing $file to ${target}.bak"
      mv "$target" "${target}.bak"
    fi
    ln -sf "$source" "$target"
    success "Symlinked $file"
  fi
done

# ---------------------------------------------------------------------------
echo ""
echo "Done. Open a new shell or run: exec zsh"
