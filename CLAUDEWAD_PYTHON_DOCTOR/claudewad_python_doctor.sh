#!/bin/bash

# ============================================================
#  CLAUDEWAD PYTHON DOCTOR
#  Neon Inspector for Python + Pip + PATH + Symlinks
# ============================================================

banner() {
    printf "\n\033[95m"
    echo "██████╗  ██████╗ ██████╗ ██████╗  ██╗██████╗ "
    echo "██╔══██╗██╔═══██╗██╔══██╗██╔══██╗ ██║██╔══██╗"
    echo "██████╔╝██║   ██║██████╔╝██████╔╝ ██║██████╔╝"
    echo "██╔══██╗██║   ██║██╔══██╗██╔══██╗ ██║██╔═══╝ "
    echo "██║  ██║╚██████╔╝██████╔╝██║  ██║ ██║██║     "
    echo "╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═╝╚═╝     "
    printf "\033[0m\n"
}

inspect_python() {
  echo "🔍 PYTHON BINARIES FOUND:"
  for p in $(which -a python python3 2>/dev/null); do
    echo "   • $p -> $($p --version 2>/dev/null)"
  done

  echo ""
  echo "🔍 HOMEBREW PYTHON:"
  if [ -f /opt/homebrew/bin/python3 ]; then
    echo "   • /opt/homebrew/bin/python3 -> $(/opt/homebrew/bin/python3 --version)"
  else
    echo "   • Not installed"
  fi

  echo ""
  echo "🔍 SYSTEM PYTHON:"
  if [ -f /usr/bin/python3 ]; then
    echo "   • /usr/bin/python3 -> $(/usr/bin/python3 --version)"
  else
    echo "   • Not present"
  fi
}

inspect_pip() {
  echo "🔧 PIP BINARIES FOUND:"
  for p in $(which -a pip pip3 2>/dev/null); do
    echo "   • $p -> $($p --version 2>/dev/null)"
  done

  echo ""
  echo "🔧 HOMEBREW PIP:"
  if [ -f /opt/homebrew/bin/pip3 ]; then
    echo "   • /opt/homebrew/bin/pip3 -> $(/opt/homebrew/bin/pip3 --version)"
  else
    echo "   • Not installed"
  fi
}

inspect_path() {
  echo "🛣 CURRENT PATH ORDER:"
  echo "$PATH" | tr ':' '\n' | nl

  echo ""
  echo "🧭 PATH PRIORITY CHECK:"
  if echo "$PATH" | grep -q "/opt/homebrew/bin"; then
    echo "   ✔ Homebrew bin is in PATH"
  else
    echo "   ✖ Homebrew bin NOT found — Python may break"
  fi

  if echo "$PATH" | awk -F: '{print $1}' | grep -q "/opt/homebrew/bin"; then
    echo "   ✔ Homebrew bin is FIRST — ideal"
  else
    echo "   ⚠ Homebrew bin is NOT first — system Python may override"
  fi
}

inspect_symlinks() {
  echo "🔗 SYMLINK CHECK:"
  echo "python -> $(readlink -f $(which python) 2>/dev/null)"
  echo "python3 -> $(readlink -f $(which python3) 2>/dev/null)"
  echo "pip -> $(readlink -f $(which pip) 2>/dev/null)"
  echo "pip3 -> $(readlink -f $(which pip3) 2>/dev/null)"
}

menu() {
  echo ""
  echo "=============================="
  echo "  PYTHON ENVIRONMENT DOCTOR"
  echo "=============================="
  echo "1) Inspect Python versions"
  echo "2) Inspect pip versions"
  echo "3) Inspect PATH ordering"
  echo "4) Inspect symlinks"
  echo "5) Run ALL checks"
  echo "0) Exit"
  echo ""
  read -p "Select an option: " choice

  case $choice in
    1) inspect_python ;;
    2) inspect_pip ;;
    3) inspect_path ;;
    4) inspect_symlinks ;;
    5) inspect_python; echo ""; inspect_pip; echo ""; inspect_path; echo ""; inspect_symlinks ;;
    0) exit 0 ;;
    *) echo "Invalid choice" ;;
  esac

  echo ""
  read -p "Press Enter to return to menu..."
  menu
}

banner
menu

