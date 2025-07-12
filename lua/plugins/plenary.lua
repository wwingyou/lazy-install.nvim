-- https://github.com/nvim-lua/plenary.nvim
local async = require "plenary.async"
```
All other modules are automatically required and can be accessed by indexing `async`.
You needn't worry about performance as this will require all the submodules lazily.

#### A quick example

Libuv luv provides this example of reading a file.

```lua
local uv = vim.loop

local read_file = function(path, callback)
  uv.fs_open(path, "r", 438, function(err, fd)
    assert(not err, err)
    uv.fs_fstat(fd, function(err, stat)
      assert(not err, err)
      uv.fs_read(fd, stat.size, 0, function(err, data)
        assert(not err, err)
        uv.fs_close(fd, function(err)
          assert(not err, err)
          callback(data)
        end)
      end)
    end)
  end)
end
```

We can write it using the library like this:
```lua
local a = require "plenary.async"

local read_file = function(path)
  local err, fd = a.uv.fs_open(path, "r", 438)
  assert(not err, err)

  local err, stat = a.uv.fs_fstat(fd)
  assert(not err, err)

  local err, data = a.uv.fs_read(fd, stat.size, 0)
  assert(not err, err)

  local err = a.uv.fs_close(fd)
  assert(not err, err)

  return data
end
