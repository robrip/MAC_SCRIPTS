# 🐍 **CLAUDEWAD PYTHON DOCTOR**  
### **Neon Inspector for Python, Pip, PATH, and Symlinks on macOS**

CLAUDEWAD PYTHON DOCTOR is a menu‑driven diagnostic utility for macOS that inspects your Python installation, pip binaries, PATH ordering, and symlink integrity. 
It’s designed for developers who frequently switch between system Python, Homebrew Python, virtual environments, and CLI tooling — and want instant visibility into what their machine is *actually* using.

This script is fully portable, requires no dependencies, and runs on any macOS system with a POSIX shell.

---

## ⚡ **Features**

### 🔍 Python Version Inspector  
Scans your system for all `python` and `python3` binaries, showing their paths and versions.  
Includes explicit checks for:

- Homebrew Python (`/opt/homebrew/bin/python3`)
- System Python (`/usr/bin/python3`)

### 🔧 Pip Inspector  
Enumerates all `pip` and `pip3` binaries and reports their versions.  
Also checks for Homebrew’s pip installation.

### 🛣 PATH Ordering Inspector  
Displays your current `$PATH` line‑by‑line and highlights:

- Whether Homebrew’s `bin` directory is present  
- Whether Homebrew’s `bin` is *first* (critical for avoiding system Python overrides)

### 🔗 Symlink Inspector  
Shows the real resolved paths behind:

- `python`
- `python3`
- `pip`
- `pip3`

Useful for debugging broken symlinks or unexpected binary routing.

### 🧭 Menu‑Driven Interface  
Interactive menu with options to run individual checks or all checks at once.

---

## 📦 **Installation**

Clone the repository or copy the script directly:

```bash
git clone https://github.com/<your-repo>/claudewad-python-doctor.git
cd claudewad-python-doctor
```

Make the script executable:

```bash
chmod +x python_doctor.sh
```

Run it:

```bash
./python_doctor.sh
```

---

## 🖥️ **Usage**

After launching, you’ll see:

```
==============================
  PYTHON ENVIRONMENT DOCTOR
==============================
1) Inspect Python versions
2) Inspect pip versions
3) Inspect PATH ordering
4) Inspect symlinks
5) Run ALL checks
0) Exit
```

Choose any option to run diagnostics.  
Press Enter to return to the menu after each check.

---

## 🧪 **What This Script Helps You Solve**

- “Why is macOS using the wrong Python?”  
- “Why does pip install packages into a different directory than expected?”  
- “Why does VS Code use a different interpreter than my terminal?”  
- “Why does Homebrew Python not override system Python?”  
- “Why do virtual environments behave inconsistently?”

This script gives you immediate visibility into the underlying routing and PATH behavior that causes these issues.

---

## 🛡️ **Compatibility**

- macOS Ventura, Sonoma, Sequoia  
- Apple Silicon (M1/M2/M3)  
- Intel Macs  
- Works with Zsh, Bash, and POSIX shells

---

## 🎨 **Branding**

Part of the **CLAUDEWAD** suite — neon‑branded, loud, unapologetic diagnostic tools for developers who want clarity *and* style.

---

## 📄 **License**
ROBRip_OpenSource
