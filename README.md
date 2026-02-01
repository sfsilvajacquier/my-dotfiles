# Dotfiles

My personal, battle-tested development environment configuration for macOS (Apple Silicon / M1 Pro ready).

## 🛠 Tech Stack

Designed for a robust, "Pro" workflow:

- **Core:** Homebrew, Zsh, Oh My Zsh
- **Production:** Docker Desktop, Google Cloud SDK
- **Languages:** Python (via `uv`)
- **Editors:** VS Code, Antigravity
- **Linters:** Ruff (fastest Python linter/formatter)
- **CLI Tools:**
  - `jq` (JSON processing)
  - `gh` (GitHub CLI)

## 📂 Structure

- `Brewfile`: Defines all system packages, applications (Casks), and CLI tools.
- `install.sh`: **Idempotent** installation script. Handles everything from Homebrew installation to dotfile linking.
- `git/`: Global git config with support for conditional work/personal identities.
- `vscode/`: VS Code settings and keybindings.
- `zshrc` / `zprofile`: Shell configuration and environment variables.
- `aliases`: Custom shortcuts.

## 🚀 Installation

This setup is designed to be a "one-click" restoration for a fresh Mac.

1. Clone the repository:

   ```bash
   git clone https://github.com/sfsilvajacquier/my-dotfiles.git ~/code/personal/my-dotfiles
   cd ~/code/personal/my-dotfiles
   ```
2. Run the installer:

   ```bash
   ./install.sh
   ```

**What it does:**

- Checks for Apple Silicon (`arm64`) and configures paths correctly.
- Installs **Homebrew** if missing.
- Installs **Oh My Zsh** if missing.
- Installs all software defined in `Brewfile` (Docker, VS Code, etc.).
- Symlinks configuration files (`.zshrc`, `.gitconfig`, etc.) to your home directory, backing up old ones.
- Configures **macOS Terminal** settings (Window size: 100x24, Font size: 10pt).

## ⚙️ Post-Installation

### Git Identity

**1. Default Identity (Personal)**
The global configuration is in `git/gitconfig`. This is symlinked to `~/.gitconfig`.

- **Action:** Edit `git/gitconfig` in this repo to set your default `name` and `email`.
- **Scope:** Used for all repositories by default.

**2. Work Identity (Conditional)**
The config supports a conditional include for work repos located in `~/code/work/`.

- **Action:** Create `~/.gitconfig-work` (this file is **not** committed to the repo).
  ```bash
  touch ~/.gitconfig-work
  ```
- **Content:** Add your work overrides:
  ```ini
  [user]
  name = Full Name
  email = work@email.com
  ```

### GitHub Authentication

To enable the GitHub CLI (`gh`) and Git credential helper:

```bash
gh auth login
```

Follow the interactive prompts to authenticate via browser.

### 🐍 Python Development

A helper alias `uv-init` is included to instantly scaffold a new Python project with [`uv`](https://github.com/astral-sh/uv) and [`direnv`](https://direnv.net/).

**To start a new project:**

1. Create a folder and enter it:
   ```bash
   mkdir my-new-project && cd my-new-project
   ```
2. Run the initializer:
   ```bash
   uv-init
   ```

**What this does is run:**

```bash
uv init && echo "layout uv" > .envrc && direnv allow
```

This creates a `.venv` (virtual environment), sets up `pyproject.toml`, configures `direnv` to automatically activate the environment when you enter the directory, and allows the configuration.

**To add dependencies:**
Simply run:

```bash
uv add pandas requests
```

This installs the packages into the virtual environment and adds them to `pyproject.toml` automatically.
