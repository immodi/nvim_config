-- Show warnings beside the text
vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        spacing = 2,
        severity = { min = vim.diagnostic.severity.WARN },
        source = "if_many",
        -- Truncate long messages
        format = function(diagnostic)
            local max_width = 50
            local message = diagnostic.message
            if #message > max_width then
                return message:sub(1, max_width - 3) .. "..."
            end
            return message
        end,
    },
    signs = false, -- Disable signs to avoid duplication
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        max_width = math.floor(vim.o.columns * 0.6),
        wrap = true,
        format = function(diagnostic)
            return string.format("%s: %s", diagnostic.source, diagnostic.message)
        end,
    },
})

-- Combined LSP hover and diagnostics on cursor hold
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        -- Check for diagnostics on current line
        local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
        local has_diagnostics = #diagnostics > 0

        -- Check for LSP clients
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        local has_lsp = #clients > 0

        if has_diagnostics and has_lsp then
            -- Get LSP hover content first
            local client = clients[1] -- Use first available client
            local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
            vim.lsp.buf_request(0, "textDocument/hover", params, function(err, result, ctx, config)
                if result and result.contents then
                    local lsp_content = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
                    local lsp_text = table.concat(lsp_content, "\n")

                    -- Build diagnostic text
                    local diagnostic_text = ""
                    for _, diagnostic in ipairs(diagnostics) do
                        diagnostic_text = diagnostic_text
                            .. string.format("\n\n🔸 %s: %s", diagnostic.source or "LSP", diagnostic.message)
                    end

                    -- Combine both
                    local combined_content = lsp_text .. diagnostic_text

                    -- Show combined popup
                    local lines = vim.split(combined_content, "\n")
                    vim.lsp.util.open_floating_preview(lines, "markdown", {
                        border = "rounded",
                        focusable = false,
                        close_events = { "CursorMoved", "CursorMovedI", "BufHidden" },
                    })
                end
            end)
        elseif has_diagnostics then
            -- Only diagnostics
            vim.diagnostic.open_float(nil, {
                focus = false,
                scope = "cursor",
                close_events = { "CursorMoved", "CursorMovedI" },
            })
        elseif has_lsp then
            -- Only LSP hover
            vim.lsp.buf.hover()
        end
    end,
})
