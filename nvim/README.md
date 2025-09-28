# Neovim Configuration Overview

This Neovim setup follows a tiered architecture that keeps core editor behavior, developer tooling, and language-specific integrations isolated while sharing common infrastructure.

## Directory Layout

```
nvim/
├── init.lua                    # Entry point; bootstraps tiered features
└── lua/
    └── features/
        ├── core/               # Universal settings, keymaps, autocmds, minimal UI
        │   ├── init.lua        # Boots lazy.nvim and other core modules
        │   └── plugins/        # Core plugin specs (colorscheme, folds, mini-edit, etc.)
        ├── dev/                # Editor-agnostic developer tooling
        │   ├── init.lua        # Imports `features.dev.plugins`
        │   └── plugins/        # Specs for Git, DAP, Treesitter, completion, formatting, …
        └── lang/               # Language overlays grouped by language name
            ├── init.lua        # Registers each language module
            └── <language>/
                ├── init.lua    # Imports language plugins/settings
                ├── settings.lua# Optional language-specific autocmds/options
                └── plugins/    # LSP, DAP, formatter, and tooling specs per language
```

Lazy.nvim stitches the tiers together using:

```lua
require('lazy').setup({
  { import = 'features.core.plugins' },
  { import = 'features.dev' },
  { import = 'features.lang' },
})
```

## Adding Core Plugins

Core plugins are universal (UI, editing helpers). To add one:

1. Create a new spec under `lua/features/core/plugins/<name>.lua` returning a table that Lazy understands.
2. Keep configuration minimal; if the plugin is aimed at development workflows (debugging, linting, project navigation, etc.), place it in the dev tier even if it feels broadly useful.
3. Re-run `nvim --headless "+Lazy check" +qa` to confirm schema validity.

Example skeleton:

```lua
-- lua/features/core/plugins/statuscolumn.lua
return {
  'some/awesome-plugin',
  event = 'VimEnter',
  opts = {},
}
```

## Adding Developer Tooling

Developer-facing plugins (linting, debugging, git, UI explorers) belong in `lua/features/dev/plugins/`.

- Place each concern in its own spec file (e.g., `git.lua`, `dap.lua`).
- If multiple specs depend on shared helpers, extract them into `lua/features/util/` and require them where needed.
- Ensure the new spec returns a Lazy table; avoid side-effects at file scope.

## Adding a New Language

1. Create a folder under `lua/features/lang/<language>/` with:
   - `init.lua`: returns `{ import = 'features.lang.<language>.plugins' }` and optionally `pcall(require, 'features.lang.<language>.settings')`.
   - `settings.lua` (optional): per-language autocmds or option tweaks.
   - `plugins/` directory containing specs such as `lsp.lua`, `dap.lua`, `formatting.lua`, `tools.lua`.
2. Register the language in `lua/features/lang/init.lua` by adding `{ import = 'features.lang.<language>' }` to the returned table.
3. Extend functionality by using the `opts` callbacks exposed by the shared dev-layer specs (no edits to `features/dev` are required). For example, to add an LSP server:

```lua
-- lua/features/lang/rust/plugins/lsp.lua
return {
  'neovim/nvim-lspconfig',
  opts = function(_, opts)
    opts.servers = opts.servers or {}
    opts.servers.rust_analyzer = {}
    opts.ensure_installed = opts.ensure_installed or {}
    table.insert(opts.ensure_installed, 'rust_analyzer')
  end,
}
```

4. Run the usual checks (`nvim --headless "+Lazy sync" +qa` then `+Lazy check`) to verify installation and schemas.

## General Guidelines

- Each plugin file must `return` a single table; avoid executing configuration on `require` aside from building the spec.
- Use small, well-named files (e.g., `mini-edit.lua`, `statusline.lua`) to keep diffs focused.
- Shared configuration (keymaps, diagnostics, formatting behavior) lives in the dev tier; language folders should only apply overrides for their ecosystem.
- When introducing tools that require external binaries, list them in the appropriate Mason ensure list so `lazy` installs remain reproducible.

## Recommended Validation Commands

- `nvim --headless "+Lazy sync" +qa` – install or update plugins.
- `nvim --headless "+Lazy check" +qa` – validate Lazy specs.
- `nvim --headless "+checkhealth" +qa` – optional health check when editing LSP/DAP configs.

Keeping these tiers separated makes it easy to reason about the configuration, onboard new tooling, and extend language support without disturbing the core editing experience.
