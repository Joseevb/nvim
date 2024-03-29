return {
    --lsp-zero
    {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
    {'L3MON4D3/LuaSnip'},
    {"j-hui/fidget.nvim"},

    --mason
    {"williamboman/mason.nvim"},
    --mason-lspconfig
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("fidget").setup({})
            require("mason").setup()
            local lsp_zero = require("lsp-zero")
            lsp_zero.extend_lspconfig()

            require("mason-lspconfig").setup({
                ensure_installed = {"lua_ls", "jdtls", "cssls", "emmet_language_server"},
                handlers = {
                    lsp_zero.default_setup,

                    emmet_language_server = function ()
                       require("lspconfig").emmet_language_server.setup({
                            filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact", "xml", "xsd", "dtd" },
                        })
                    end
                },
            })

            local cmp = require('cmp')
            local cmp_select = {behavior = cmp.SelectBehavior.Select}

            cmp.setup({
                sources = {
                    {name = 'path'},
                    {name = 'nvim_lsp'},
                    {name = 'nvim_lua'},
                    {name = 'luasnip', keyword_length = 2},
                    {name = 'buffer', keyword_length = 3},
                },
                formatting = lsp_zero.cmp_format(),
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<S-Tab>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<Tab>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
            })
        end
    },
}
