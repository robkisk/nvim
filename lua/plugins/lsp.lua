return {
  -- Mason: Package manager for LSP servers
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Mason-LSPConfig: Bridge between mason and lspconfig
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "bashls",
        "gopls",
        "html",
        "jsonls",
        "lua_ls",
        "marksman",
        "rust_analyzer",
        "taplo",
        "terraformls",
        "ty@0.0.32",
        "yamlls",
      },
      automatic_enable = {
        -- rust_analyzer is enabled conditionally in nvim-lspconfig's config
        -- (only when a Rust toolchain is on PATH) to avoid a hard error.
        exclude = { "yamlls", "rust_analyzer" },
      },
    },
  },

  -- yaml-companion: Schema management for YAML LSP
  {
    "mosheavni/yaml-companion.nvim",
    ft = { "yaml" },
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      schemas = {
        {
          name = "Databricks Bundle",
          uri = "file://" .. vim.fn.expand("~/.config/nvim/schemas/databricks_bundle.json"),
        },
      },
      lspconfig = {
        settings = {
          yaml = {
            validate = true,
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = {
              ["file://" .. vim.fn.expand("~/.config/nvim/schemas/databricks_bundle.json")] = {
                "*.yml",
                "*.yaml",
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      local cfg = require("yaml-companion").setup(opts)
      vim.lsp.config("yamlls", cfg)
      vim.lsp.enable("yamlls")
    end,
  },

  -- LSPConfig: LSP server configurations
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- lua_ls: teach it the Neovim runtime. Without this it flags `vim` as an
      -- undefined global on every line of this config. Library is scoped to
      -- $VIMRUNTIME + luv (not the whole lazy plugin dir) to keep indexing fast.
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME .. "/lua",
                "${3rd}/luv/library",
              },
            },
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      -- rust_analyzer's root_dir shells out to `rustc` to locate the sysroot and
      -- throws if no Rust toolchain is on PATH, forcing a "Press ENTER" error
      -- prompt on every .rs buffer. It's excluded from mason-lspconfig's
      -- automatic_enable above; enable it only when a toolchain is present, so it
      -- auto-activates on the next launch once rustc is installed.
      if vim.fn.executable("rustc") == 1 then
        vim.lsp.enable("rust_analyzer")
      end

      -- LSP keybindings (attached when LSP connects)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local opts = { buffer = ev.buf }

          -- Navigation
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
          vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Find references" }))
          vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))

          -- Documentation
          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))

          -- Actions
          vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
          vim.keymap.set({ "n", "v" }, "<Leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))

          -- Diagnostics
          vim.keymap.set("n", "[d", function()
            vim.diagnostic.jump({ count = -1, float = true })
          end, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
          vim.keymap.set("n", "]d", function()
            vim.diagnostic.jump({ count = 1, float = true })
          end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
          vim.keymap.set("n", "<Leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostic" }))
        end,
      })

      -- Diagnostic display configuration
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = true,
        },
      })

      -- Filter marksman's noisy "Ambiguous link to document" warnings.
      -- Marksman's resolver matches the same on-disk file via multiple
      -- strategies (path + basename + frontmatter title) and reports
      -- ambiguity even when only one file exists. Harmless false positive.
      local orig_publish = vim.lsp.handlers["textDocument/publishDiagnostics"]
      vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
        if result and result.diagnostics and ctx and ctx.client_id then
          local client = vim.lsp.get_client_by_id(ctx.client_id)
          if client and client.name == "marksman" then
            result.diagnostics = vim.tbl_filter(function(d)
              return not (d.message and d.message:match("^Ambiguous link to document"))
            end, result.diagnostics)
          end
        end
        return orig_publish(err, result, ctx, config)
      end
    end,
  },
}
