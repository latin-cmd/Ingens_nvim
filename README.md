# Neovim Configuration

A modern Neovim configuration built with [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager.

## Structure

```
nvim/
├── init.lua              # Main entry point
├── lua/
│   ├── config/
│   │   ├── autocmds.lua  # Auto commands configuration
│   │   ├── keymaps.lua   # Key mappings
│   │   └── options.lua   # Neovim options
│   └── plugins/          # Plugin configurations
│       ├── ai.lua        # AI assistance plugins
│       ├── colorscheme.lua
│       ├── completion.lua
│       ├── filetree.lua
│       ├── git.lua
│       ├── lsp.lua       # Language Server Protocol
│       ├── markdown.lua
│       ├── telescope.lua # Fuzzy finder
│       ├── terminal.lua
│       ├── treesitter.lua # Syntax highlighting
│       ├── ui.lua        # UI enhancements
│       └── utils.lua     # Utility plugins
```

## Features

- **Plugin Management**: Uses lazy.nvim for efficient plugin management
- **LSP Support**: Full Language Server Protocol integration
- **AI Integration**: AI-assisted coding capabilities
- **Git Integration**: Built-in git workflow support
- **File Management**: Tree-style file explorer
- **Fuzzy Finding**: Telescope for fast file and content searching
- **Syntax Highlighting**: Treesitter for better syntax highlighting
- **Terminal**: Integrated terminal support
- **Markdown**: Enhanced markdown editing
- **UI Enhancements**: Modern and clean interface

## Installation

1. Backup your current Neovim configuration:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   mv ~/.local/share/nvim ~/.local/share/nvim.backup
   ```

2. Clone this configuration:
   ```bash
   git clone <repository-url> ~/.config/nvim
   ```

3. Start Neovim and let lazy.nvim install all plugins:
   ```bash
   nvim
   ```

## Requirements

- Neovim 0.8+ (0.9+ recommended)
- Git
- Node.js (for some LSP servers)
- Python (for some LSP servers)

## Customization

The configuration is modular and easy to customize. Each plugin has its own configuration file in the `lua/plugins/` directory. You can:

- Add new plugins by creating new files in `lua/plugins/`
- Modify key mappings in `lua/config/keymaps.lua`
- Adjust settings in `lua/config/options.lua`
- Add custom auto commands in `lua/config/autocmds.lua`

## Key Features

### AI Integration
- GitHub Copilot support
- AI-assisted code completion
- Smart code suggestions

### LSP Configuration
- Automatic LSP server installation via Mason
- Support for multiple programming languages
- Integrated diagnostics and formatting

### Git Integration
- Git signs in the gutter
- Git blame visualization
- Git status in file explorer

### File Management
- Nvim-tree for file exploration
- Telescope for fuzzy finding
- Project-wide search and replace

## Troubleshooting

If you encounter issues:

1. Run `:checkhealth` to diagnose common problems
2. Update plugins with `:Lazy update`
3. Sync LSP servers with `:Mason` then update all packages
4. Check plugin configurations in `lua/plugins/` for any needed adjustments

## License

This configuration is provided as-is for educational and personal use.