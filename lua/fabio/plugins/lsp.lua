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
        "astro",
        "tailwindcss",
        "html",
        "svelte",
        "eslint",
        "gopls",
        -- "biome",
        -- "volar",

      },

      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities
          }
        end,

        ["gopls"] = function() -- custom handler for gopls
          require("lspconfig").gopls.setup {
            capabilities = capabilities,
            settings = {
              gopls = {
                analyses = {
                  unusedparams = true,
                },
                staticcheck = true,
                gofumpt = true,
              },
            },

            vim.api.nvim_create_autocmd("BufWritePre", {
              pattern = "*.go",
              callback = function()
                local params = vim.lsp.util.make_range_params()
                params.context = {only = {"source.organizeImports"}}
                -- buf_request_sync defaults to a 1000ms timeout. Depending on your
                -- machine and codebase, you may want longer. Add an additional
                -- argument after params if you find that you have to write the file
                -- twice for changes to be saved.
                -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
                local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
                for cid, res in pairs(result or {}) do
                  for _, r in pairs(res.result or {}) do
                    if r.edit then
                      local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                      vim.lsp.util.apply_workspace_edit(r.edit, enc)
                    end
                  end
                end
                vim.lsp.buf.format({async = false})
              end
            })
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

        ["astro"] = function() -- custom handler for astro
          require("lspconfig").astro.setup {
            capabilities = capabilities,
            settings = {
              astro = {
                format = {
                  enable = true
                },
                eslint = {
                  enable = true
                }
              }
            },

            typescript = {
              serverPath = "/Users/fabio/.nvm/versions/node/v18.20.2/lib"
            },

            on_attach = function(_, bufnr)
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format()
                end,
              })
            end,
          }
        end,

        ["tsserver"] = function() -- custom handler for tsserver
          require("lspconfig").tsserver.setup {
            capabilities = capabilities
          }
        end,

        ["svelte"] = function () -- custom handler for svelte
          require("lspconfig").svelte.setup {
            capabilities = capabilities,

            on_attach = function(_, bufnr)
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format()
                end,
              })
            end,
          }
        end,

        ["eslint"] = function() -- custom handler for eslint
          require("lspconfig").eslint.setup {
            capabilities = capabilities,

            on_attach = function(_, bufnr)
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                command = "EslintFixAll",
              })
            end,
          }
        end,

        -- ["biome"] = function()
        --   require("lspconfig").biome.setup({
        --     capabilities = capabilities,
        --
        --     on_attach = function(_, bufnr)
        --       vim.api.nvim_create_autocmd("BufWritePre", {
        --         buffer = bufnr,
        --         callback = function()
        --           vim.lsp.buf.format()
        --         end,
        --       })
        --     end,
        --   })
        -- end


        -- TODO: Investigate documentFormattingProvider, could be useful to avoid conflicts with multiple lsps
        --
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
        --   }
        -- end,

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
