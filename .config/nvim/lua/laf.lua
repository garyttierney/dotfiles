-- Look and feel
local Laf = {}

function Laf.setup()
    -- Icons for diagnostic signs
    local function gutter_sign(name, icon)
        vim.fn.sign_define(
            'DiagnosticSign' .. name,
            { text = icon, texthl = 'Diagnostic' .. name  }
        )
    end

    gutter_sign('Error', '')
    gutter_sign('Information', '')
    gutter_sign('Hint', '')
    gutter_sign('Info', '')
    gutter_sign('Warning', '')
    gutter_sign('Warn', '')

    -- Gitsigns
    -- See `:help gitsigns.txt`
    require('gitsigns').setup()

    -- Replace vim.ui.input and vim.ui.select with pop-up alternatives
    require('dressing').setup()
end

return Laf
