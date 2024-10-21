return {
	-- LSP Zero and related plugins
	{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
	{ "neovim/nvim-lspconfig" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/nvim-cmp" },
	{ "L3MON4D3/LuaSnip" },
	{ "j-hui/fidget.nvim" },
	{ "jose-elias-alvarez/null-ls.nvim" },
	{ "MunifTanjim/prettier.nvim" },
	{ "rafamadriz/friendly-snippets" },

	-- Mason and related plugins
	{ "williamboman/mason.nvim" },
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_lspconfig()
			require("fidget").setup({})
			require("mason").setup()

			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "jdtls", "cssls", "emmet_language_server", "intelephense" },
				handlers = {
					lsp_zero.default_setup,

					emmet_language_server = function()
						require("lspconfig").emmet_language_server.setup({
							cmd = { "emmet-language-server", "--stdio" },
							filetypes = {
								"html",
								"css",
								"javascript",
								"javascriptreact",
								"php",
							},
							init_options = {
								preferences = {
									includeLanguages = {
										html = "html",
										javascript = "javascriptreact",
										css = "css",
									},
								},
							},
						})
					end,

					intelephense = function()
						require("lspconfig").intelephense.setup({
							settings = {
								intelephense = {
									files = {
										maxSize = 5000000, -- Set max file size if needed
									},
								},
							},
						})
					end,
				},
			})

			require("lspconfig").intelephense.setup({
				root_dir = require("lspconfig.util").root_pattern("composer.json", ".git", "*.php", "*.html"),
			})

			local null_ls = require("null-ls")

			local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
			local event = "BufWritePost" -- or "BufWritePost"
			local async = event == "BufWritePost"

			null_ls.setup({
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument.formatting") then
						vim.keymap.set("n", "<Leader>f", function()
							vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
						end, { buffer = bufnr, desc = "[lsp] format" })

						-- format on save
						vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
						vim.api.nvim_create_autocmd(event, {
							buffer = bufnr,
							group = group,
							callback = function()
								vim.lsp.buf.format({ bufnr = bufnr, async = async })
							end,
							desc = "[lsp] format on save",
						})
					end

					if client.supports_method("textDocument.rangeFormatting") then
						vim.keymap.set("x", "<Leader>f", function()
							vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
						end, { buffer = bufnr, desc = "[lsp] format" })
					end
				end,
			})

			local prettier = require("prettier")

			prettier.setup({
				bin = "prettierd", -- or `'prettierd'` (v0.23.3+)
				filetypes = {
					"css",
					"graphql",
					"html",
					"javascript",
					"javascriptreact",
					"json",
					"less",
					"markdown",
					"scss",
					"typescript",
					"typescriptreact",
					"yaml",
				},
				cli_options = {
					use_tabs = true,
					tab_width = 4,
				},
			})

			require("luasnip.loaders.from_vscode").lazy_load({
				paths = { vim.fn.stdpath("data") .. "/lazy/friendly-snippets" },
			})

			local cmp = require("cmp")
			local cmp_select = { behavior = cmp.SelectBehavior.Select }

			cmp.setup({
				sources = {
					{ name = "path" },
					{ name = "luasnip", keyword_length = 2 },
					{ name = "nvim_lsp" },
					{ name = "emmet_ls", keyword_length = 2 }, -- Add this line
					{ name = "nvim_lua" },
					{ name = "buffer" },
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				formatting = lsp_zero.cmp_format(),
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(cmp_select),
					["<Tab>"] = cmp.mapping.select_next_item(cmp_select),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
			})

			vim.api.nvim_set_keymap(
				"i",
				"<C-k>",
				[[<cmd>lua require'luasnip'.expand_or_jump()<CR>]],
				{ noremap = true, silent = true }
			)

			cmp.setup.filetype({ "sql" }, {
				sources = {
					{ name = "vim-dadbod-completion" },
					{ name = "buffer" },
				},
			})
		end,
	},

	-- Initial setup
	init = function()
		require("lazyvim.util").on_attach(function(client)
			-- Uncomment and configure if needed
			-- if client.name == "jdtls" then
			--   local jdtls = require("jdtls")
			--   jdtls.setup_dap({ hotcodereplace = "auto" })
			--   jdtls.setup.add_commands()
			--   -- Auto-detect main and setup dap config
			--   require("jdtls.dap").setup_dap_main_class_configs({
			--     config_overrides = {
			--       -- vmArgs = "-Dspring.profiles.active=local",
			--     },
			--   })
			-- end
		end)
	end,
}
