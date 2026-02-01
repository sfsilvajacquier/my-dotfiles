# --- Oh My Zsh Config ---
ZSH=$HOME/.oh-my-zsh
# --- Custom 'Carp' Prompt ---
# Disable default theme
ZSH_THEME=""

# Custom Prompt Logic (Red/White Circle + Python Env)
# \u25cf is the circle character
prompt_carp_setup() {
  # Red if error (!= 0), White if success (0)
  local circle="%(?:%{$fg_bold[white]%}●%{$reset_color%}:%{$fg_bold[red]%}●%{$reset_color%})"
  
  # Directory color
  local dir="%{$fg_bold[cyan]%}%c%{$reset_color%}"
  
  # Python Virtual Env (Snake + Name)
  local venv=""
  if [[ -n "$VIRTUAL_ENV" ]]; then
    venv=" %{$fg[yellow]%}🐍 $(basename "$VIRTUAL_ENV")%{$reset_color%}"
  fi
  
  PROMPT="${circle} ${dir}${venv} $(git_prompt_info)"
}

# Git prompt settings
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[white]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# Apply the prompt
prompt_carp_setup

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

# --- Global Environment (Carp) ---
# Automatically activate 'carp' if it exists and we aren't already in a venv
if [[ -z "$VIRTUAL_ENV" && -f "$HOME/.virtualenvs/carp/bin/activate" ]]; then
  source "$HOME/.virtualenvs/carp/bin/activate"
fi
