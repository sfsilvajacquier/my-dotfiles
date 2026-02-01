#!/bin/zsh

# --- 0. Init & Safety Checks ---
# Exit on error
set -e

echo "-----> Starting My Dotfiles Setup..."

# Architecture Check
ARCH=$(uname -m)
echo "-----> Detected Architecture: $ARCH"

# Define a function which rename a `target` file to `target.backup` if the file
# exists and if it's a 'real' file, ie not a symlink
backup() {
  target=$1
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
      mv "$target" "$target.backup"
      echo "-----> Moved your old $target config file to $target.backup"
    fi
  fi
}

symlink() {
  file=$1
  link=$2
  if [ -L "$link" ]; then
    rm "$link"
  fi
  if [ ! -e "$link" ]; then
    echo "-----> Symlinking your new $link"
    ln -s $file $link
  fi
}

# --- 0.1 Homebrew Setup ---
if ! command -v brew &> /dev/null; then
  echo "-----> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # M1 Pro / Apple Silicon PATH setup
  if [[ "$ARCH" == 'arm64' ]]; then
    echo "-----> Configuring Homebrew for Apple Silicon..."
    if ! grep -q "opt/homebrew/bin/brew shellenv" $HOME/.zprofile 2> /dev/null; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    fi
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  echo "-----> Homebrew already installed"
fi

# Ensure Brew Bundle is run
echo "-----> Installing software via Homebrew Bundle..."
brew bundle --file="$PWD/Brewfile"

# --- 0.2 Oh My Zsh Setup (Robust) ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "-----> Installing Oh My Zsh..."
  # Prevent it from dropping into a shell
  export RUNZSH=no
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "-----> Oh My Zsh already installed"
fi


# --- 1. Core Shell Configuration ---
# Backup and symlink shell-related files
for name in aliases zprofile zshrc; do
  target="$HOME/.$name"
  backup $target
  symlink $PWD/$name $target
done

# --- 3. Git Configuration ---
# Set up global git config and global ignore
backup ~/.gitconfig
symlink $PWD/git/gitconfig ~/.gitconfig
backup ~/.gitignore_global
symlink $PWD/git/gitignore_global ~/.gitignore_global

# --- 4. Zsh Plugins ---
# Install zsh-syntax-highlighting and autosuggestions if missing
CURRENT_DIR=`pwd`
ZSH_PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"
mkdir -p "$ZSH_PLUGINS_DIR" && cd "$ZSH_PLUGINS_DIR"
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
  echo "-----> Installing zsh plugins..."
  git clone https://github.com/zsh-users/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting
fi
cd "$CURRENT_DIR"

# --- 5. VS Code Configuration ---
# Determine platform-specific path for VS Code settings
if [[ `uname` =~ "Darwin" ]]; then
  CODE_PATH=~/Library/Application\ Support/Code/User
else
  CODE_PATH=~/.config/Code/User
  if [ ! -e $CODE_PATH ]; then
    CODE_PATH=~/.vscode-server/data/Machine
  fi
fi

# Symlink VS Code settings from vscode/ directory
mkdir -p "$CODE_PATH"
for name in settings.json keybindings.json; do
  target="$CODE_PATH/$name"
  backup $target
  symlink $PWD/vscode/$name $target
done

# --- 6. Antigravity Configuration ---
# Symlink Antigravity settings from antigravity/ directory
if [[ `uname` =~ "Darwin" ]]; then
  AGY_PATH="$HOME/Library/Application Support/Antigravity/User"
  mkdir -p "$AGY_PATH"
  target="$AGY_PATH/settings.json"
  backup $target
  symlink $PWD/antigravity/settings.json $target
fi

# --- 7. SSH Configuration ---
# Symlink SSH config from ssh/ directory and add identity to keychain
if [[ `uname` =~ "Darwin" ]]; then
  target=~/.ssh/config
  mkdir -p ~/.ssh && chmod 700 ~/.ssh
  backup $target
  symlink $PWD/ssh/config $target
  # Ensure the identity file exists before adding it
  if [ -f ~/.ssh/id_ed25519 ]; then
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519
  fi
fi

# --- 8. macOS Terminal Settings ---
if [[ `uname` =~ "Darwin" ]]; then
  echo "-----> Configuring macOS Terminal..."
  osascript -e 'tell application "Terminal"
    tell default settings
        set number of columns to 100
        set number of rows to 24
        set font size to 10
    end tell
  end tell'
fi

# Refresh terminal session
echo "👌 Configuration installed successfully!"
exec zsh
