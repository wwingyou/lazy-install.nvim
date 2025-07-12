
vim.api.nvim_create_user_command('LazyInstall', function(opts)
  local url = opts.fargs[1]
  if not url or url == '' then
    print("Usage: :LazyInstall <github_url>")
    return
  end
  require('lazy-install').install(url)
end, {
  nargs = 1,
  -- complete = 'url',
})
