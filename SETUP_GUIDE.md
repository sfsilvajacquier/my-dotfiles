# Workstation Setup Guide

This guide details the steps to set up a professional development environment on macOS.
Please **read carefully and execute commands in order**.

## 1. GitHub Account

Ensure you have a [GitHub account](https://github.com/join).

*   **Profile:** Upload a professional picture and set your real name.
*   **Security:** Enable [Two-Factor Authentication (2FA)](https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa).

## 2. Apple Silicon Verification

Check if your Mac uses an Apple Silicon chip (M1/M2/M3) or Intel.

1.  Open Terminal (`Cmd + Space`, type "Terminal").
2.  Run:
    ```bash
    uname -m
    ```
    *   `arm64` = Apple Silicon
    *   `x86_64` = Intel

**For Apple Silicon users:**
Ensure your Terminal is **NOT** using Rosetta.
1.  Find Terminal in Applications > Utilities.
2.  Right-click > Get Info.
3.  Ensure "Open using Rosetta" is **unchecked**.

## 3. macOS Basics

*   **Quitting Apps:** Use `Cmd + Q` to fully quit apps (closing the window with the red 'x' doesn't quit the app).
*   **Spotlight:** Use `Cmd + Space` to launch apps quickly.

## 4. Command Line Tools

Install the Xcode Command Line Tools, required for many developer utilities.

```bash
xcode-select --install
```

*If it says "command line tools are already installed", you are good to go.*

## 5. Homebrew

Install [Homebrew](https://brew.sh), the package manager for macOS.

1.  **Install:**
    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```
2.  **Add to PATH:** (Follow the instructions printed in your terminal after installation).
3.  **Update:**
    ```bash
    brew update
    ```
4.  **Install Basic Utilities:**
    ```bash
    brew install git gh wget jq curl
    ```

## 6. Visual Studio Code

1.  **Install:**
    ```bash
    brew install --cask visual-studio-code
    ```
2.  **Launch:**
    ```bash
    code
    ```
3.  **Extensions:**
    Install recommended extensions for Python and Web Development:
    ```bash
    code --install-extension ms-python.python
    code --install-extension ms-python.vscode-pylance
    code --install-extension ms-toolsai.jupyter
    code --install-extension esbenp.prettier-vscode
    code --install-extension eamodio.gitlens
    ```

## 7. Shell Configuration (Oh My Zsh)

Install [Oh My Zsh](https://ohmyz.sh/) for a better terminal experience.

```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## 8. Environment Management (direnv)

[direnv](https://direnv.net/) loads environment variables automatically when you enter a folder.

```bash
brew install direnv
echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
```

## 9. GitHub CLI Configuration

Authenticate `gh` to interact with GitHub securely.

```bash
gh auth login
```
*   **Account:** GitHub.com
*   **Protocol:** SSH
*   **Upload Key:** Yes (Generate a new one if needed)

Verify:
```bash
gh auth status
```

## 10. Dotfiles Installation

Apply your personal configuration preferences.

1.  **Clone your repository:**
    ```bash
    git clone https://github.com/sfsilvajacquier/my-dotfiles.git ~/code/personal/my-dotfiles
    ```
2.  **Run the Installer:**
    ```bash
    cd ~/code/personal/my-dotfiles
    ./install.sh
    ```

## 11. Python Setup

We use `pyenv` to manage python versions and `pyenv-virtualenv` (or `uv`) for environments.

1.  **Install Prerequisites:**
    ```bash
    brew install xz readline
    ```
2.  **Install pyenv:**
    ```bash
    brew install pyenv pyenv-virtualenv
    ```
3.  **Install Python:**
    ```bash
    pyenv install 3.12.1
    pyenv global 3.12.1
    ```

## 12. Jupyter Configuration

To optimize Jupyter Notebooks:

```bash
pip install jupyterlab
# Additional customization steps if needed
```

## 13. Data Tools

### DBeaver
Universal database tool:
```bash
brew install --cask dbeaver-community
```

### Docker
Container platform:
1.  Download [Docker Desktop](https://www.docker.com/products/docker-desktop/).
2.  Install and start it.
3.  Verify:
    ```bash
    docker info
    ```

## 14. Cloud SDK (Google Cloud)

If you use GCP:

1.  **Install SDK:**
    ```bash
    brew install --cask google-cloud-sdk
    ```
2.  **Authenticate:**
    ```bash
    gcloud auth login
    ```
3.  **Set Project:**
    ```bash
    gcloud config set project <YOUR_PROJECT_ID>
    ```

## 15. Google Cloud Platform Setup

Steps to configure a GCP Project manually:
1.  Go to [Google Cloud Console](https://console.cloud.google.com/).
2.  **Create Project:** Name it appropriately (e.g., "Data Project").
3.  **Billing:** Link a billing account (required for most APIs).
4.  **Service Account:**
    *   IAM & Admin > Service Accounts > Create.
    *   Role: Owner (or specific roles).
    *   Keys: Create new JSON key.
    *   **Save safely:** `~/.gcp/my-key.json` (Never commit this!).
    *   **Environment Variable:**
        ```bash
        export GOOGLE_APPLICATION_CREDENTIALS=~/.gcp/my-key.json
        ```

## 16. Communication Tools

**Slack:**
*   [Download Desktop App](https://slack.com/download).
*   Configure notifications and "Do Not Disturb" to protect focus time.

## 17. macOS Settings

### Security
*   **Lock Screen:** Set to lock after 5 seconds of inactivity.
*   **Hot Corners:** Configure a corner to lock screen instantly.

### Keyboard
*   **Key Repeat:** Set to Fast.
*   **Delay Until Repeat:** Set to Short.

### Dock
*   Pin frequently used apps: Terminal, VS Code, Browser.

---

**Setup Complete!** 🚀
You are now ready to start developing.
