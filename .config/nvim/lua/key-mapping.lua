local function map(mode, keys, func, desc, options, bufnr)
    local opts = (options ~= nil) and options or {}
    if desc ~= nil then
        opts.desc = desc
    end

    if bufnr ~= nil then
        opts.buffer = bufnr
    end

    vim.keymap.set(mode, keys, func, opts)
end

local nnoremap = function(keys, func, desc, options, bufnr)
    local opts = (options ~= nil) and options or {}
    opts.noremap = true

    map('n', keys, func, desc, opts, bufnr)
end

local KeyMapping = {}

function KeyMapping.setup_on_attach(_, bufnr)
    nnoremap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame', {}, bufnr)
    nnoremap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', {}, bufnr)

    nnoremap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition', {}, bufnr)
    nnoremap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation', {}, bufnr)
    nnoremap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences', {}, bufnr)
    nnoremap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols', {}, bufnr)
    nnoremap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols', {}, bufnr)

    -- See `:help K` for why this keymap
    nnoremap('K', vim.lsp.buf.hover, 'Hover Documentation', {}, bufnr)
    nnoremap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation', {}, bufnr)

    -- Lesser used LSP functionality
    nnoremap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration', {}, bufnr)
    nnoremap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition', {}, bufnr)

    local formatter = vim.lsp.buf.formatting
    if vim.lsp.buf.format ~= nil then
        formatter = function()
            vim.lsp.buf.format({
                async = false
            })
        end
    end

    map({ 'i', 'v', 'n' }, '<M-C-L>', formatter, 'Format code', {}, bufnr)
end

function KeyMapping.setup()
    -- [[ Basic Keymaps ]]
    -- Set <,> as the leader key
    -- See `:help mapleader`
    --  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
    vim.g.mapleader = ','
    vim.g.maplocalleader = ','

    nnoremap('<leader>ft', '<Cmd>NvimTreeToggle<CR>', 'Open [F]ile [T]ree')

    -- Navigation keymaps
    nnoremap('<A-,>', '<Cmd>BufferPrevious<CR>')
    nnoremap('<A-.>', '<Cmd>BufferNext<CR>')
    -- Re-order to previous/next
    nnoremap('<A-<>', '<Cmd>BufferMovePrevious<CR>')
    nnoremap('<A->>', '<Cmd>BufferMoveNext<CR>')
    -- Pin/unpin buffer
    nnoremap('<A-p>', '<Cmd>BufferPin<CR>')
    -- Close buffer
    nnoremap('<A-c>', '<Cmd>BufferClose<CR>')

    -- Diagnostic keymaps
    nnoremap('<leader>ll', require('lsp_lines').toggle, 'Toggle [L]sp [L]ines')
    nnoremap('[d', vim.diagnostic.goto_prev, 'Previous Diagnostic')
    nnoremap(']d', vim.diagnostic.goto_next, 'Next Diagnostic')
    nnoremap('<leader>se', '<cmd>TroubleToggle workspace_diagnostics<cr>', '[e] Show Errors')
    nnoremap('<leader>sfe', '<cmd>TroubleToggle document_diagnostics<cr>', '[fe] Show File Errors')

    -- See `:help telescope.builtin`
    nnoremap('<leader>?', require('telescope.builtin').oldfiles, '[?] Find recently opened files')
    nnoremap('<leader><space>', require('telescope.builtin').buffers, '[ ] Find existing buffers')
    nnoremap('<leader>/', function()
        require('telescope.builtin').current_buffer_fuzzy_find(
            require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false
            })
    end, '[/] Fuzzily search in current buffer]')

    nnoremap('<leader>sf', require('telescope.builtin').find_files, '[f] Search files')
    nnoremap('<leader>sh', require('telescope.builtin').help_tags, '[h] Search help')
    nnoremap('<leader>sg', require('telescope.builtin').live_grep, '[g] Search with grep')
    nnoremap('<leader>sd', require('telescope.builtin').diagnostics, '[d] Search diagnostics')

    -- Use Which-Key to display key mappings
    require('which-key').setup()
end

return KeyMapping
