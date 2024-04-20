return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  },

  config = function()
    local cmp = require"cmp"
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "tsserver",
        "eslint",
        -- "tailwindcss",
        -- "volar",
        -- "html",
        -- "svelte",
      },

      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities
          }
        end,

        ["lua_ls"] = function() -- custom handler for lua
          require("lspconfig").lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" }
                }
              }
            }
          }
        end,

        ["eslint"] = function() -- custom handler for eslint
          require("lspconfig").eslint.setup {
            capabilities = capabilities,

            on_attach = function(client, bufnr)
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                command = "EslintFixAll",
              })
            end,

            -- TODO: Investigate documentFormattingProvider, could be useful to avoid conflicts with multiple lsps
            -- on_attach = function(client, bufnr)
            --   client.server_capabilities.documentFormattingProvider = true
            --   if client.server_capabilities.documentFormattingProvider then
            --     local lsp_group = vim.api.nvim_create_autogroup("eslint_lsp", { clear = true })
            --     vim.api.nvim_create_autocmd("BufWritePre", {
            --       pattern = "*",
            --       callback = function()
            --         vim.lsp.buf.format(nil)
            --       end,
            --       group = lsp_group,
            --     })
            --   end
            -- end,
          }
        end,
      }
    })

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
      },

      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<cr>"] = cmp.mapping.confirm({ select = true }),
        ["<c-e>"] = cmp.mapping.abort(),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<c-b>"] = cmp.mapping.scroll_docs(-4),
        ["<c-f>"] = cmp.mapping.scroll_docs(4),
      }),

      sources = cmp.config.sources(
        {
          { name = "nvim_lsp" },
          { name = "luasnip" }, -- for luasnip users.
        },
        {
          { name = "buffer" },
        }
      )
    })
  end
}
