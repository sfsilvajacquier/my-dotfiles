# --- Oh My Zsh Config ---
ZSH=$HOME/.oh-my-zsh


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

# --- Global Environment (CARP) ---
# Automatically activate 'CARP' if it exists and we aren't already in a venv
if [[ -z "$VIRTUAL_ENV" && -f "$HOME/.virtualenvs/CARP/bin/activate" ]]; then
  source "$HOME/.virtualenvs/CARP/bin/activate"
fi

# --- 10. Custom Prompt (Post-Plugin Load) ---
# Use precmd to ensure prompt updates on every command
prompt_carp_precmd() {
  # Left Side: Arrow (Green/Red) + Directory + Git
  # ➜ is the arrow character
  local arrow="%(?:%{$fg_bold[green]%}➜ %{$reset_color%}:%{$fg_bold[red]%}➜ %{$reset_color%})"
  local dir="%{$fg_bold[cyan]%}%c%{$reset_color%}"
  
  # Check if git_prompt_info function exists (from git plugin)
  local git_info=""
  if type git_prompt_info > /dev/null 2>&1; then
    git_info="$(git_prompt_info)"
  fi

  PROMPT="${arrow} ${dir} ${git_info}"

  # Right Side: Time + Venv [ 🐍 NAME ]
  local venv=""
  if [[ -n "$VIRTUAL_ENV" ]]; then
    # Brackets white, Name yellow
    venv="[ 🐍 %{$fg[yellow]%}$(basename "$VIRTUAL_ENV")%{$reset_color%} ]"
  fi
  
  # Time format: 12:31PM
  local time_info="%{$fg[white]%}%D{%I:%M%p}%{$reset_color%}"
  
  RPROMPT="${time_info} ${venv}"
}

# Hook logic to precmd
autoload -U add-zsh-hook
add-zsh-hook precmd prompt_carp_precmd

