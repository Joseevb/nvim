return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettierd", "prettier" },
				typescript = { "prettierd", "prettier" },
				javascriptreact = { "prettierd", "prettier" },
				typescriptreact = { "prettierd", "prettier" },
				css = { "prettierd", "prettier" },
				html = { "prettierd", "prettier" },
				json = { "prettierd", "prettier" },
				yaml = { "prettierd", "prettier" },
				markdown = { "prettierd", "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
				-- java = { "google-java-format" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
		})

		conform.formatters.prettier = {
			prepend_args = function()
				return { "--use-tabs", "true", "--tab-width", "4" }
			end,
		}

		conform.formatters.google_java_format = {
			prepend_args = function()
				print("Applying google-java-format with --aosp")
				return { "--aosp" }
			end,
			timeout_ms = 3000,
		}

		vim.keymap.set({ "n", "v" }, "<leader>fa", function()
			conform.format({
				async = false,
				timeout_ms = 500,
				lsp_format = "fallback",
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
