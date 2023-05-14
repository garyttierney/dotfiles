local function run_task(command, opts)
  local output_bufnr = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_call(output_bufnr, function()
    vim.bo[0].buftype = "nofile"
    vim.bo[0].bufhidden = "hide"
    vim.bo[0].swapfile = false
  end)

  vim.fn.jobstart(command, {
    cwd = opts.cwd or '.',

    on_stdout = function(_, data, _)
      vim.api.nvim_buf_set_lines(output_bufnr, -1, -1, false, data)
    end,

    on_exit = function()
      local lines = vim.api.nvim_buf_get_lines(output_bufnr, 0, -1, false)
      vim.api.nvim_buf_delete(output_bufnr, {})

      opts.on_complete(lines)
    end,

    stdout_buffer = true,
  })
end

local function find_cargo_exec_options(opts, callback)
  local cargo_run_subcommand = opts.args.cargoArgs[1]
  local cargo_meta_subcommand = "build"

  if cargo_run_subcommand == "test" then
    cargo_meta_subcommand = "test --no-run"
  end

  local cargoArgs = table.concat(opts.args.cargoArgs, " ", 2)
  local command = string.format("cargo %s %s --message-format=json", cargo_meta_subcommand, cargoArgs)

  run_task(command, {
    cwd = opts.args.workspaceRoot,
    on_complete = function(data)
      local messages = vim.tbl_map(function(json)
        if json == "" then
          return
        else
          return vim.json.decode(json)
        end
      end, data)

      local artifacts = vim.tbl_filter(function(message)
        return message.reason == "compiler-artifact"
            and message.executable ~= vim.NIL
      end, messages)

      -- TODO: selector for >1 artifact
      local executable = artifacts[1].executable
      local executableArgs = opts.args.executableArgs

      callback(executable, executableArgs)
    end
  })
end


vim.lsp.commands["rust-analyzer.runSingle"] = function(command, ctx)
  local opts = command.arguments[1]

  if opts.kind == "cargo" then
    find_cargo_exec_options(opts, function(executable, executableArgs)
      local output_bufnr = vim.api.nvim_create_buf(false, false)

      vim.cmd("botright split")
      local window = vim.api.nvim_get_current_win()

      vim.api.nvim_set_current_buf(output_bufnr)
      vim.api.nvim_win_set_buf(window, output_bufnr)
      vim.fn.termopen(string.format("%s %s", executable, table.concat(executableArgs, " ")), {
        cwd = opts.args.workspaceRoot,
      })
    end)
  end
end

vim.lsp.commands["rust-analyzer.debugSingle"] = function(command, ctx)
  local opts = command.arguments[1]

  if opts.kind == "cargo" then
    find_cargo_exec_options(opts, function(executable, executableArgs)
      table.insert(executableArgs, "--color")
      table.insert(executableArgs, "never")

      require('dap').run({
        name = "Rust",
        type = "lldb_vscode",
        request = 'launch',
        args = executableArgs,
        program = executable,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        initCommands = function()
          -- Find out where to look for the pretty printer Python module
          local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))

          local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
          local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

          local commands = {}
          local file = io.open(commands_file, 'r')
          if file then
            for line in file:lines() do
              table.insert(commands, line)
            end
            file:close()
          end
          table.insert(commands, 1, script_import)

          return commands
        end,

      })
    end)
  end
end

return {}
