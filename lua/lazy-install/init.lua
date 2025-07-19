local M = {}

local utils = require"lazy-install.utils"

function M.install(url)
  vim.notify("Installing from " .. url, vim.log.levels.INFO)
  local owner, repo = url:match("github.com/([^/]+)/([^/]+)")
  if not owner or not repo then
    vim.notify("Invalid GitHub URL", vim.log.levels.ERROR)
    return
  end

  local plugin_name = repo:gsub("%.nvim", "")
  local config_dir = vim.fn.stdpath('config')
  local plugins_dir = config_dir .. "/lua/plugins"
  if vim.fn.isdirectory(plugins_dir) == 0 then
    vim.fn.mkdir(plugins_dir, "p")
  end
  local file_path = plugins_dir .. "/" .. plugin_name .. ".lua"

  -- Fetch README using curl
  local readme_url = string.format("https://raw.githubusercontent.com/%s/%s/master/README.md", owner, repo)
  local command = string.format("curl -sL %s", readme_url)
  local handle = io.popen(command)
  local readme_content = handle:read("*a")
  handle:close()

  -- Parse installation instructions
  local install_example = nil
  for code_block in readme_content:gmatch("```lua\n(.-)```") do
    -- Wrap the code block in a return statement to make it a valid Lua expression
    if not utils.start_with_return(code_block) then
      code_block = "return " .. code_block
    end

    local func, err = load(code_block, "=", "t", {})
    if func then
      -- Execute the code in a sandboxed environment
      local ok, result = pcall(func)

      -- Check if the result is a table and the first element is the plugin name
      local t, level = utils.find_plugin_table(result, owner .. "/" ..repo)

      -- Use raw string if possible
      if t then
        if level == 1 then
          install_example = code_block
        else
          install_example = vim.inspect(t)
        end
        break
      end
    end
  end

  -- Create the plugin file
  local file = io.open(file_path, "w")
  if file then
    file:write("-- " .. url .. "\n")
    if install_example then
      if not utils.start_with_return(install_example) then
        file:write("return ")
      end
      file:write(install_example)
    else
      file:write(string.format("return { '%s/%s' }", owner, repo))
      vim.notify("Example installation is not found on README. Please check repository.", vim.log.levels.INFO)
    end
    file:close()

    vim.notify("Created " .. file_path, vim.log.levels.INFO)
    vim.cmd.edit(file_path)
  else
    vim.notify("Error creating file: " .. file_path, vim.log.levels.ERROR)
  end
end

return M
