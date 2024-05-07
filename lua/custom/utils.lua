local M = {}
local LOG_PATH = "/tmp/nvim.log"
os.remove(LOG_PATH)

--
--Global functions
--
--function Keys(dict) return vim.tbl_keys(dict) end

function Print(...)
  local args = { ... }

  --TODO don't hardcode the path
  local file = io.open(LOG_PATH, "a")

  for _, arg in ipairs(args) do
    --write as a vim message
    if not vim.tbl_contains({ "string" }, type(arg)) then
      arg = vim.inspect(arg)
    end
    vim.api.nvim_out_write(arg)

    --append to log file
    if file then
      --file:write(str:gsub("\\n", "\n"))
      file:write(arg .. " ")
    end
  end
  vim.api.nvim_out_write("\n")
  if file then
    file:write("\n")
    file:close() -- Close the file
  end
end

--
--local utils
--
local function GetCurrentTabWindows()
  local tabpage = vim.api.nvim_get_current_tabpage()
  return vim.api.nvim_tabpage_list_wins(tabpage)
end

local BuffTypes = {
  terminal = "terminal",
  file = "file",
  nvimtree = "nvimtree",
  outline = "outline",
}

local function IsRepoBuff(id)
  return vim.wo.diff and M.GetBufferType(id) == nil
end

local function AddHeaderIfRepoFile()
  --heeder prevents line shift which is caused by breadcrumbs displayed at the top of the local file
  if IsRepoBuff(0) then
    local winnr = vim.api.nvim_get_current_win()
    vim.wo[winnr].winbar = "Repo file"
  end
end

local function SetNvimTreeFoldLevel(level)
  local tree = require("nvim-tree.api").tree
  local core = require("nvim-tree.core")
  local renderer = require("nvim-tree.renderer")
  local lib = require("nvim-tree.lib")

  tree.collapse_all(false)

  local function visit(n, currentLevel)
    if not n.nodes or currentLevel > level then
      return
    end

    --expand this node
    local node = lib.get_last_group_node(n)
    node.open = true
    if #node.nodes == 0 then
      core.get_explorer():expand(node)
    end

    --visit children
    for _, child in pairs(n.nodes) do
      visit(child, currentLevel + 1)
    end
  end

  local root = core.get_explorer()
  visit(root, 0)
  renderer.draw()
end

local function SetOutlineFoldLevel(level)
  require("aerial").tree_set_collapse_level(nil, level)
end

--local RepositionTerminal = function()
--  local current_win_id = vim.api.nvim_get_current_win()
--
--  local windows = GetCurrentTabWindows()
--  --Print("try")
--  for _, win in ipairs(windows) do
--    local bufferID = vim.api.nvim_win_get_buf(win)
--    if M.GetBufferType(bufferID) == BuffTypes.terminal then
--      --Print("RepositionTerminal")
--      local height = vim.api.nvim_win_get_height(win)
--      vim.api.nvim_set_current_win(win)
--      vim.cmd("wincmd J") --make sure that the window occupies the whole bottom
--      vim.api.nvim_win_set_height(win, height)
--    end
--  end
--
--  vim.api.nvim_set_current_win(current_win_id)
--end
--
--Exported functions
--
M.GetBufferType = function(id)
  local filetype = vim.api.nvim_buf_get_option(id, "filetype")
  local buftype = vim.api.nvim_buf_get_option(id, "buftype")
  --Print("filetype ", filetype, ", buftype ", buftype)

  if buftype == "terminal" then
    return BuffTypes.terminal
  elseif filetype == "NvimTree" then
    return BuffTypes.nvimtree
  elseif buftype == "" then
    return BuffTypes.file
  elseif filetype == "aerial" then
    return BuffTypes.outline
  end
end

M.SwitchToFileWindow = function()
  --if already editing a file open a file search
  --otherwise switch to file editing
  local current_buffer_type = M.GetBufferType(0)
  if current_buffer_type == BuffTypes.file then
    vim.cmd("Telescope frecency workspace=CWD")
  else
    local windows = GetCurrentTabWindows()
    for _, win in ipairs(windows) do
      local bufferID = vim.api.nvim_win_get_buf(win)
      if M.GetBufferType(bufferID) == BuffTypes.file then
        vim.api.nvim_set_current_win(win)
      end
    end
  end
end

M.SwitchToTerminalWindow = function()
  local windows = GetCurrentTabWindows()
  for _, win in ipairs(windows) do
    local bufferID = vim.api.nvim_win_get_buf(win)
    if M.GetBufferType(bufferID) == BuffTypes.terminal then
      --RepositionTerminal()
      vim.api.nvim_set_current_win(win)
      vim.cmd("startinsert")
      return
    end
  end
  vim.cmd("Terminal")
  --vim.cmd("resize 10")
end

M.SwitchToFileTree = function()
  if vim.fn.exists(":AerialClose") ~= 0 then --prevent errors caused by lazy loading
    --close symbols window if it's open
    vim.cmd("AerialClose")
  end
  vim.cmd("NvimTreeFocus")
  vim.schedule(function()
    --switch to normal mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'n', true)
  end)
  --RepositionTerminal()
end

M.SwitchToOutline = function()
  if vim.fn.exists(":NvimTreeClose") ~= 0 then --prevent errors caused by lazy loading
    vim.cmd("NvimTreeClose")
  end
  vim.cmd("AerialOpen")
end

M.ExitTerminalMode = function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "n", false)
end

M.SetFoldLevel = function(level)
  local bufferType = M.GetBufferType(vim.api.nvim_get_current_buf())
  if bufferType == BuffTypes.nvimtree then
    SetNvimTreeFoldLevel(level)
  elseif bufferType == BuffTypes.outline then
    SetOutlineFoldLevel(level)
  else
    vim.cmd("set foldlevel=" .. level)
  end
end

M.BufEnter = function()
  AddHeaderIfRepoFile()
  if M.GetBufferType(0) == BuffTypes.terminal then
    vim.schedule(function()
      vim.cmd("startinsert")
    end)
  end
end

M.BufLeave = function()
  AddHeaderIfRepoFile()
  if M.GetBufferType(0) == BuffTypes.terminal then
    vim.cmd("stopinsert")
  end
end

M.GitStatus = function()
  local actions = require("telescope.actions")
  local conf = require("telescope.config").values
  local gitsigns = require("gitsigns")
  local git_signs_cache = require("gitsigns.cache")

  --sorter that put staged files at the end of the result list
  local custom_sorter = function(opts)
    local res = conf.file_sorter(opts)
    local old = res.scoring_function
    res.scoring_function = function(arg, prompt, entry)
      local score = old(arg, prompt, entry)
      local first_char = string.sub(entry, 1, 1)
      if first_char == "A" or first_char == "M" or first_char == "D" then
        score = score + 100
      end
      return score
    end
    return res
  end

  require("telescope.builtin").git_status({
    sorter = custom_sorter(),
    attach_mappings = function(_, map)
      --run diff view after choosing an option
      map("i", "<CR>", function(prompt_bufnr)
        local selection = require("telescope.actions.state").get_selected_entry()
        actions.close(prompt_bufnr)

        if vim.wo.diff then
          local diff_window = vim.tbl_filter(function(win)
            return IsRepoBuff(vim.api.nvim_win_get_buf(win))
          end, GetCurrentTabWindows())
          if #diff_window > 0 then
            vim.api.nvim_win_close(diff_window[1], false)
          else
            Print("in diff, but no diff window")
          end
        end

        vim.cmd("e " .. selection.value)
        --vim.cmd("echom @%")

        --diff is not available just after opening a new buffer, so let's try until it's ready
        local timer = vim.loop.new_timer()

        local buff = vim.api.nvim_get_current_buf()
        local function TryDiff()
          local cache = git_signs_cache.cache
          if cache[buff] and cache[buff].compare_text then
            --it's hard to determine if cache is ready even if it exists, so let's catch some errors and potentially try again later
            local status, _ = pcall(gitsigns.diffthis)
            if not status then
              Print("assertion in gitsigns, waiting...")
            end
            if status and timer and not timer:is_closing() then
              timer:stop()
              timer:close()
            end
          end
        end

        if timer then
          timer:start(0, 10, vim.schedule_wrap(TryDiff))
        else
          Print("Timer not set")
        end
      end)

      return true
    end,
  })
end

M.StartAutoReload = function(callback)
  local tab = vim.api.nvim_get_current_tabpage()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  local file_path = vim.api.nvim_buf_get_name(buf)
  local uv = vim.loop
  local last_stat = nil
  local timer = uv.new_timer()

  if timer == nil then
    Print("timer is nil, can't schedule auto reload")
    return
  end

  local function check_for_changes()
    local stat = uv.fs_stat(file_path)

    if
        not vim.api.nvim_buf_is_valid(buf)
        or not vim.api.nvim_win_is_valid(win)
        or file_path ~= vim.api.nvim_buf_get_name(buf)
        or buf ~= vim.api.nvim_win_get_buf(win)
    then
      timer:stop()
      pcall(timer.close, timer)
      Print("file path or buffer in a monitored window was changed, stoping auto reload")
    end

    if
        not last_stat
        or last_stat and (last_stat.mtime.sec ~= stat.mtime.sec or last_stat.mtime.nsec ~= stat.mtime.nsec)
    then
      local line_count = vim.api.nvim_buf_line_count(buf)
      local cursor_at_the_end = vim.api.nvim_win_get_cursor(win)[1] == line_count
      vim.api.nvim_buf_call(buf, function()
        local current_tab = vim.api.nvim_get_current_tabpage()
        vim.api.nvim_set_current_tabpage(tab)
        vim.cmd("e!")
        --vim.cmd("BaleiaColorize")
        vim.api.nvim_set_current_tabpage(current_tab)
        local new_content = vim.api.nvim_buf_get_lines(buf, line_count, -1, false)
        callback(new_content)
        if cursor_at_the_end then
          local last_line = vim.api.nvim_buf_line_count(buf)
          vim.api.nvim_win_set_cursor(win, { last_line, 0 })
        end
      end)
    end

    last_stat = stat
  end

  timer:start(0, 100, vim.schedule_wrap(check_for_changes))
  --vim.cmd("BaleiaColorize")
  vim.cmd("normal G")
end

M.baleia = function()
  return require("baleia").setup({})
end

M.WatchFile = function(path, callback)
  local uv = vim.loop
  local last_stat = nil
  local timer = uv.new_timer()

  if timer == nil then
    Print("timer is nil, can't schedule auto reload")
    return
  end

  local function check_for_changes()
    local stat = uv.fs_stat(path)
    if not stat then
      return
    end
    if
        not last_stat
        or last_stat and (last_stat.mtime.sec ~= stat.mtime.sec or last_stat.mtime.nsec ~= stat.mtime.nsec)
    then
      local lines = vim.fn.readfile(path)
      callback(lines)
    end
    last_stat = stat
  end
  timer:start(0, 100, vim.schedule_wrap(check_for_changes))
end

M.LiveGrepSkipGitSubmodules = function()
  local cmd = [[git config --file .gitmodules --get-regexp path | awk '{ print "!"$2 }']]
  local cmd_output = vim.fn.system(cmd)
  local excluded_dirs = vim.fn.split(cmd_output, "\n")
  table.insert(excluded_dirs, "!bookmarks")
  require("telescope.builtin").live_grep({ glob_pattern = excluded_dirs })
end


M.PrepareTerminalTab = function()
  vim.cmd("tabnew")
  vim.cmd("Terminal")
  M.SwitchToFileWindow()
  vim.cmd("quit")
end

M.PrepareServerTab = function(command)
  vim.cmd("tabnew")
  vim.cmd("Terminal "..command)

  M.SwitchToFileWindow()
  vim.cmd("q")
end

return M
