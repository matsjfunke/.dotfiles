# Neovim Configuration

This README provides an overview of the plugins used in this Neovim configuration and their functionalities. Follow the instructions to understand how each plugin contributes to enhancing the Neovim experience.

## Plugins

### 1. lazy-plugin-manager.lua

- **Function**: Plugin Manager
- **Usage**:
  - Type `:Lazy` to access the GUI for managing plugin installations and updates.
  - Simplifies the process of adding, updating, and removing plugins.

### 2. lsp-config.lua

- **Function**: Language Server Protocol (LSP) Configuration
- **Components**:
  - **mason.nvim**: Manages LSP servers.
  - **mason-lspconfig**: Ensures LSP servers are installed and managed.
  - Defines key mappings for:
    - Hover (`K`)
    - Go to definition (`gd`)
    - Code actions (`<leader>ca`)
- **Usage**:
  - Type `:Mason` to view the GUI for managing LSP servers.
  - `K` information about the symbol under the cursor.
  - `gd` Go to definition.
  - `<leader>ca` Trigger code actions (fixing code issues / refactoring code).

### 3. nvim-cmp.lua

- **Function**: Autocompletion Plugin
- **Usage**:
  - `<Tab>` to go down suggestions
  - `<S-Tab>` to go up suggestions

### 4. vim-settings.lua

- **Function**: General Neovim Settings
- **Features**:
  - Enhanced navigation
  - Custom key bindings
  - Improved indentation
  - Clipboard integration
  - Cursor control
  - Enhanced color support
  - Filetype-specific templates
  - Window splitting
- **Usage**:
  - use kj in every mode to ESC
  - set leader to Space (" ")

### 5. telescope.lua

- **Function**: Fuzzy File Finder
- **Usage**:
  - `<leader>ff` fuzzy find file
  - `<leader>fg` fuzzy find words in files

### 6. harpoon.lua

- **Function**: File Marking and Navigation
- **Usage**:
  - `hx` marks file
  - `hm`harpoon menu
  - `hn` next mark `hp` previous mark
  - `h1 - h4` jump to mark 1 through 4

### 7. gitsigns.lua

- **Function**: Git Integration
- **Features**:
  - Color indicators for different types of git diffs.
  - Toggle for blame annotations to see who last modified a line.
- **Usage**:
  - `<leader>gt` to view git blame

### 8. none-ls.lua

- **Function**: Linter and Formatter Integration
  - Wraps linters and formatters to appear as standard LSP servers to `nvim-lspconfig`, enabling consistent usage of LSP features.
- **Usage**:
  - `<leader>sf` to auto format / or `:w`

### 9. treesiter.lua

- **Function**: Syntax Highlighting
- **Usage**:
  - Enhanced syntax highlighting using Tree-sitter for better code readability and structure.

### 10. kanagawa.lua

- **Function**: Color Theme
- **Usage**:
  - Apply the Kanagawa color theme for a visually appealing coding environment.

### 11. lua-line.lua

- **Function**: Status Line Enhancement
- **Usage**:
  - Provides a pretty and informative status line.

### 12. neo-tree.lua

- **Function**: File Tree Explorer
- **Usage**:
  - Toggle the file tree with a `<C-s>`
