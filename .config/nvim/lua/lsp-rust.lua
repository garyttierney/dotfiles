local RustLsp = {}

function RustLsp.setup()
    local rt = require("rust-tools")
    rt.setup({
        tools = {
            inlay_hints = {
                auto = false
            }
        },
        server = {
            on_attach = function(client, bufnr)
                -- defaults
                require('key-mapping').setup_on_attach(client, bufnr)

                -- Hover actions
                require('lsp-inlayhints').on_attach(client, bufnr)

                vim.keymap.set("n", "K", rt.hover_actions.hover_actions, {
                    buffer = bufnr
                })
            end,
            settings = {
                ["rust-analyzer"] = {
                    checkOnSave = {
                        command = "clippy"
                    }
                }
            }

        }
    })

    -- null-lsp implementation for Cargo manifests
    require('crates').setup()
end

return RustLsp
