local Lsp = {}

function Lsp.capabilities()
    return require('cmp_nvim_lsp').default_capabilities()
end

function Lsp.setup()
    -- Setup mason so it can manage external tooling
    require('mason').setup()

    -- Enable the following language servers
    local servers = { 'clangd', 'rust_analyzer', 'pyright', 'lua_ls' }

    -- Ensure the servers above are installed
    require('mason-lspconfig').setup {
        ensure_installed = servers
    }

    for _, lsp in ipairs(servers) do
        require('lspconfig')[lsp].setup {
            on_attach = require('key-mapping').setup_on_attach,
            capabilities = Lsp.capabilities()
        }
    end

    -- Enable inlay hints
    require('lsp-inlayhints').setup()

    -- Add borders to hover boxes
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "single"
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "single"
    })

    require('lsp_lines').setup()

    vim.diagnostic.config({
        signs = true,
        virtual_text = false,
        virtual_lines = {
            only_current_line = false,
        }
    })
end

return Lsp
