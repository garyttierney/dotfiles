local Navigation = {}

function Navigation.setup()

    -- Buffer and tab navigation header
    require('bufferline').setup()

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    require('telescope').setup {
        defaults = {
            mappings = {
                i = {
                    ['<C-u>'] = false,
                    ['<C-d>'] = false
                }
            }
        }
    }

end

return Navigation
