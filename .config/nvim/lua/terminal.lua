local Terminal = {}

function Terminal.setup()
    vim.fn.setenv('EDITOR', 'nvr --remote-wait')

    -- Automatically delete nested git buffers on close
    vim.api.nvim_create_autocmd('FileType', {
        command = 'set bufhidden=delete',
        pattern = {'gitcommit', 'gitrebase', 'gitconfig'}
    })

    -- Go into terminal mode whenever navigating to a terminal
    vim.api.nvim_create_autocmd('BufEnter', {
        command = 'startinsert',
        pattern = 'term://*'
    })
end

return Terminal
