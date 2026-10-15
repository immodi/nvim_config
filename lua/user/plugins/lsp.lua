-- LSP servers to configure (installed through mason-tool-installer)
local servers = {
	lua_ls = {
		settings = {
			Lua = { completion = { callSnippet = "Replace" } },
		},
	},
}

-- Extra (non-LSP) tools for mason to install
local tools = { "stylua" }

local function on_attach(event)
	local function map(keys, func, desc, mode)
		vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
	end
	local telescope = function(picker)
		return function()
			require("telescope.builtin")[picker]()
		end
	end

	map("gd", vim.lsp.buf.definition, "Go to definition")
	map("gI", vim.lsp.buf.implementation, "Go to implementation")
	map("grn", vim.lsp.buf.rename, "Rename")
	map("gra", vim.lsp.buf.code_action, "Code action", { "n", "x" })
	map("grr", telescope("lsp_references"), "References")
	map("gri", telescope("lsp_implementations"), "Implementations")
	map("grd", telescope("lsp_definitions"), "Definitions")
	map("grD", vim.lsp.buf.declaration, "Declaration")
	map("grt", telescope("lsp_type_definitions"), "Type definition")
	map("gO", telescope("lsp_document_symbols"), "Document symbols")
	map("gW", telescope("lsp_dynamic_workspace_symbols"), "Workspace symbols")

	local client = vim.lsp.get_client_by_id(event.data.client_id)
	if not client then
		return
	end

	-- Highlight references of the word under the cursor
	if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
		local group = vim.api.nvim_create_augroup("user-lsp-highlight", { clear = false })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = event.buf,
			group = group,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = event.buf,
			group = group,
			callback = vim.lsp.buf.clear_references,
		})
		vim.api.nvim_create_autocmd("LspDetach", {
			group = vim.api.nvim_create_augroup("user-lsp-detach", { clear = true }),
			callback = function(detach)
				vim.lsp.buf.clear_references()
				vim.api.nvim_clear_autocmds({ group = "user-lsp-highlight", buffer = detach.buf })
			end,
		})
	end

	-- Toggle inlay hints
	if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
		map("<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
		end, "Toggle inlay hints")
	end
end

return {
	-- Lua LSP setup for the Neovim config / runtime / plugins
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
				callback = on_attach,
			})

			-- Advertise blink.cmp capabilities to every server
			vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
			for name, config in pairs(servers) do
				vim.lsp.config(name, config)
			end

			local ensure_installed = vim.tbl_keys(servers)
			vim.list_extend(ensure_installed, tools)
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			-- Enables every server installed through mason
			require("mason-lspconfig").setup({ ensure_installed = {}, automatic_enable = true })
		end,
	},

	-- Code action picker
	{
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"ibhagwan/fzf-lua",
			{ "folke/snacks.nvim", opts = { terminal = {} } },
		},
		keys = {
			{
				"<leader>ca",
				function()
					require("tiny-code-action").code_action({})
				end,
				desc = "Code action (picker)",
			},
		},
		opts = {},
	},
}
