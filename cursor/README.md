# Cursor VIMification

## 📁 Files Overview

- **`settings.json`** - Editor settings, UI configuration, and behavior preferences
- **`keybindings.json`** - Custom keyboard shortcuts and Vim-mode bindings
- **`extensions.txt`** - List of extension IDs for automated installation

## 🚀 Quick Setup

### 1. Install Cursor

Download and install Cursor from [cursor.sh](https://cursor.sh/)

### 2. Create Symlinks

Link your dotfiles to Cursor's configuration directory:

```bash
# Navigate to Cursor's user directory
cd ~/Library/Application\ Support/Cursor/User/

# Remove existing files (backup first if needed)
rm settings.json keybindings.json 2>/dev/null

# Create symlinks to dotfiles
ln -s ~/.dotfiles/cursor/settings.json settings.json
ln -s ~/.dotfiles/cursor/keybindings.json keybindings.json
```

### 3. Install Extensions

Install all extensions from the list:

```bash
cat ~/.dotfiles/cursor/extensions.txt | xargs -I {} cursor --install-extension {}
```

### 4. Restart Cursor

Restart Cursor to apply all settings and load extensions.

## 🔧 Extension Management

### Install New Extensions

When you install extensions through Cursor's UI, update your extensions list:

```bash
cursor --list-extensions > ~/.dotfiles/cursor/extensions.txt
```

## ⌨️ Key Bindings

### Side bar

- **`Ctrl+s`** - Toggle sidebar visibility / Focus file explorer
- **`n`** - Create new file (when file explorer focused)
- **`Shift+n`** - Create new folder (when file explorer focused)
- **`r`** - Rename file (when file explorer focused)
- **`d`** - Delete file (when file explorer focused)
- **`Enter`** - Open selected file
- **`Ctrl+d`** - Open Working tree pane / diff

### Terminal

- **`Cmd+j`** - Toggle terminal visibility
- **`Cmd+n`** - Create new terminal
- **`Cmd+w`** - Close current terminal

### Navigation

- **`Cmd+h`** - focus buffer
- **`Cmd+l`** - focus ai pane
- **`Shift+h`** - Previous buffer
- **`Shift+l`** - Next buffer

### Vim Mode (Leader: `<Space>`)

#### File Operations

- **`<leader>w`** - Save file
- **`<leader>q`** - Quit
- **`<leader>x`** - Save and quit
- **`<leader>p`** - Format document
- **`<leader>v`** - Split window vertically

#### Search

- **`<leader>ff`** - Quick file search (find files)
- **`<leader>fg`** - Find in files (file grep)

#### Code Navigation

- **`sd`** - Show definition preview hover
- **`gd`** - Go to definition

#### Visual Mode

- **`<` / `>`** - Indent/outdent lines while staying in visual mode
- **`J` / `K`** - Move selected lines up/down

#### Insert Mode

- **`kj`** - Escape to normal mode

## ⚙️ Settings Highlights

### Vim Configuration

### Editor Behavior

- Format on save enabled
- Prettier as default formatter for TypeScript, TypeScript React, and JSON
- Auto-save on focus change
