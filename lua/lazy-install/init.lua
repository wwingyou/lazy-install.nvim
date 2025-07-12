local M = {}

function M.install(url)
  print("Installing from " .. url)
  local owner, repo = url:match("github.com/([^/]+)/([^/]+)")
  if not owner or not repo then
    print("Invalid GitHub URL")
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
    local func, err = load("return " .. code_block, "=", "t", {})
    if func then
      -- Execute the code in a sandboxed environment
      local ok, result = pcall(func)
      -- Check if the result is a table and the first element is the plugin name
      if ok and type(result) == "table" and result[1] == owner .. "/" .. repo then
        install_example = code_block
        break
      end
    end
  end

  -- Create the plugin file
  local file = io.open(file_path, "w")
  if file then
    file:write("-- " .. url .. "\n")
    if install_example then
        if not install_example:match("^%s*return") then
            file:write("return ")
        end
      file:write(install_example)
    else
      file:write(string.format("return { '%s/%s' }", owner, repo))
    end
    file:close()
    print("Created " .. file_path)
  else
    print("Error creating file: " .. file_path)
  end
end

return M
