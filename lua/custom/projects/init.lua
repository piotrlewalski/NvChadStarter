local utils = require("custom.utils")
local path = vim.fn.getcwd()
local directory = path:match("([^/]+)$")
local project_path = vim.fn.stdpath("config") .. "/lua/custom/projects/" .. directory .. ".lua"
SESSION_FILE = vim.fn.stdpath("data") .. "/" .. directory .. ".session"

function SaveCurrTabBuffersToFile()
  local file = io.open(SESSION_FILE, "w")
  if not file then
    error("Failed to open session file")
  end
  for _, buf in ipairs(vim.t.bufs) do
    if utils.GetBufferType(buf) == "file" then
      local bufname = vim.api.nvim_buf_get_name(buf)
      file:write(bufname .. "\n")
    end
  end
  file:close()
end

function LoadCurrTabBuffersFromFile()
  local file = io.open(SESSION_FILE, "r")
  if not file then
    return
  end
  local files = {}
  for line in file:lines() do
    table.insert(files, line)
  end
  file:close()
  --this is a bit convoluted, the idea is to open each file wait for all it's
  --handlers had a chance to be executed, and then open next one
  --otherwise things like LSP would not work correctly
  --unfortunately scheduling each function call in a single for loop did not work
  --that's why the recursive version that schedules a single call at a time
  local function open_and_wait()
    if #files > 0 then
      local filename = table.remove(files, 1)
      if vim.fn.filereadable(filename) ~= 0 then
        pcall(vim.cmd, "edit " .. filename)
      end
    end
    if #files > 0 then
      vim.schedule(open_and_wait)
    end
  end
  vim.schedule(open_and_wait)
end

local function main()
  if vim.fn.filereadable(project_path) == 1 then
    dofile(project_path)

    --load previously opened buffers and later save the open ones on exit
    vim.schedule(LoadCurrTabBuffersFromFile)
    vim.api.nvim_create_autocmd("VimLeave", {
      callback = SaveCurrTabBuffersToFile
    })

    --not switching to the first tab causes some issues with tabufline initialization
    --but usualy that's the desired behavior anyway
    vim.cmd("tabfirst")

    --if that's a project let's open file exaplorer window
      vim.cmd("NvimTreeFocus")
      vim.schedule(utils.SwitchToFileWindow)
    --vim.schedule(function ()
    --end)
    --Print("switch")

    --switch back to normal mode
    vim.schedule(function()
      vim.cmd("stopinsert")
    end)
  end
end

main()
