#!/usr/bin/env bash

echo "🐍  Starting Python Environment Bootstrap for macOS..."

# ---------------------------------------------------------
# 1. Ensure Homebrew is on PATH
# ---------------------------------------------------------
echo "🔧  Adding Homebrew to PATH..."
echo 'export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"' >> ~/.zshrc

# ---------------------------------------------------------
# 2. Add Python unversioned symlinks (python, pip)
# ---------------------------------------------------------
echo "🔗  Adding Python unversioned symlinks to PATH..."
echo 'export PATH="/opt/homebrew/opt/python@3.14/libexec/bin:$PATH"' >> ~/.zshrc

# ---------------------------------------------------------
# 3. Install pipx (Python CLI package manager)
# ---------------------------------------------------------
echo "📦  Installing pipx..."
brew install pipx
pipx ensurepath

# ---------------------------------------------------------
# 4. Install pyenv (optional but powerful)
# ---------------------------------------------------------
echo "🧬  Installing pyenv..."
brew install pyenv

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc

# ---------------------------------------------------------
# 5. Install virtualenv
# ---------------------------------------------------------
echo "📁  Installing virtualenv..."
pip3 install virtualenv

# ---------------------------------------------------------
# 6. Install Poetry (Python project manager)
# ---------------------------------------------------------
echo "🎼  Installing Poetry..."
curl -sSL https://install.python-poetry.org | python3 -

echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

# ---------------------------------------------------------
# 7. Reload shell
# ---------------------------------------------------------
echo "🔄  Reloading shell..."
source ~/.zshrc

# ---------------------------------------------------------
# 8. Create a test virtual environment
# ---------------------------------------------------------
echo "🧪  Creating test virtual environment..."
mkdir -p ~/python-env-test
cd ~/python-env-test
python3 -m venv venv

echo "✨  Bootstrap complete!"
echo "➡️  Activate your test environment with:"
echo "   source ~/python-env-test/venv/bin/activate"
