-- AI inline completion (ghost text), similar to Continue's tab-autocomplete.
-- Continue itself has no Neovim plugin, so this uses minuet-ai.nvim with the same
-- default setup Continue recommends: a local Ollama model doing fill-in-the-middle.
--
-- Setup:
--   ollama pull qwen2.5-coder:1.5b      (or :7b if your machine can take it)
--
-- To use a hosted model instead, change `provider` / `provider_options`
-- (supports openai, claude, gemini, codestral, ...): see :help minuet

return {
	"milanglacier/minuet-ai.nvim",
	event = "InsertEnter",
	opts = {
		provider = "openai_fim_compatible",
		n_completions = 1, -- one suggestion is enough for local models
		request_timeout = 10,
		context_window = 256, -- start small to reduce prompt processing

		provider_options = {
			openai_fim_compatible = {
				name = "Llama.cpp",
				api_key = "TERM",
				end_point = "http://localhost:8080/v1/completions",
				model = "Qwen2.5-Coder-0.5B-Q8_0.gguf",
				stream = true,

				template = {
					prompt = function(before, after, _)
						return "<|fim_prefix|>" .. before .. "<|fim_suffix|>" .. after .. "<|fim_middle|>"
					end,
					suffix = false,
				},

				optional = {
					max_tokens = 64,
					top_p = 0.9,
				},
			},
		},

		virtualtext = {
			-- Show suggestions automatically while typing in these filetypes
			auto_trigger_ft = {
				"lua",
				"python",
				"javascript",
				"typescript",
				"javascriptreact",
				"typescriptreact",
				"html",
				"css",
				"templ",
				"svelte",
				"kotlin",
				"cs",
				"go",
			},
			keymap = {
				accept = "<A-a>", -- accept whole suggestion
				accept_line = "<A-l>", -- accept one line
				prev = "<A-[>", -- previous suggestion (also triggers manually)
				next = "<A-]>", -- next suggestion (also triggers manually)
				dismiss = "<A-e>",
			},
		},
	},
}
