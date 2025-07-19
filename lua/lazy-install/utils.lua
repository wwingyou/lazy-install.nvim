M = {}

M.start_with_return = function(str)
  return str:match("^%s*return")
end

local function find_plugin_table(src, url, level)
  if type(src) == "table" and src[1] == url then
    return src, level
  else
    for _, value in pairs(src) do
      local result, _ = find_plugin_table(value, url, level + 1)
      if result then return result end
    end
  end
  
  return nil
end

M.find_plugin_table = function(src, url)
  return find_plugin_table(src, url, 1)
end

return M
