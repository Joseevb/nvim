return {
    --lsp-zero
    {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
    {'L3MON4D3/LuaSnip'},

    --mason
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    --mason-lspconfig
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            local lsp_zero = require("lsp-zero")
            lsp_zero.extend_lspconfig()

            require("mason-lspconfig").setup({
                ensure_installed = {"lua_ls", "jdtls", "cssls", "emmet_language_server"},
                handlers = {
                    lsp_zero.default_setup,
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
