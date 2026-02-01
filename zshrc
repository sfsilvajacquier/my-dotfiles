# --- Oh My Zsh Config ---
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"

# Optimized plugin list
plugins=(git gitfast last-working-dir zsh-syntax-highlighting zsh-autosuggestions)

export HOMEBREW_NO_ANALYTICS=1
ZSH_DISABLE_COMPFIX=true

source "${ZSH}/oh-my-zsh.sh"

# --- Paths & Tools ---
# 1. Consolidated PATH: Ensuring .local/bin (uv tools) and .antigravity take priority
export PATH="$HOME/.local/bin:$HOME/.antigravity/antigravity/bin:./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"

# 2. Editor Update: Changing default editor to Antigravity
export EDITOR='agy --wait'

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# --- Python & Work Logic ---
export VIRTUAL_ENV_DISABLE_PROMPT=0
export PYTHONBREAKPOINT=ipdb.set_trace

# The Magic Handshake (uv + direnv)
if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# Load your custom aliases
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"
