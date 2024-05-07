--code copied from nvchad/tabufline/modules.lua
--the idea is to remove some unnecessary items, like closing icons and extra padding
--changed marked with "customization" comment
local api = vim.api
local fn = vim.fn
local g = vim.g

dofile(vim.g.base46_cache .. "tbline")

local strep = string.rep
--customization
--local style_buf = require("nvchad.tabufline.utils").style_buf
local cur_buf = api.nvim_get_current_buf
--local config = require("nvconfig").ui.tabufline
local config = { order = { "treeOffset", "buffers", "tabs" } } --TODO

txt = function(str, hl)
  str = str or ""
  local a = "%#Tb" .. hl .. "#" .. str
  return a
end

btn = function(str, hl, func, arg)
  str = hl and txt(str, hl) or str
  arg = arg or ""
  return "%" .. arg .. "@Tb" .. func .. "@" .. str .. "%X"
end

---------------------------------------------------------- btn onclick functions ----------------------------------------------

vim.cmd "function! TbGoToBuf(bufnr,b,c,d) \n execute 'b'..a:bufnr \n endfunction"

vim.cmd [[
   function! TbKillBuf(bufnr,b,c,d)
        call luaeval('require("nvchad.tabufline").close_buffer(_A)', a:bufnr)
  endfunction]]

vim.cmd "function! TbNewTab(a,b,c,d) \n tabnew \n endfunction"
vim.cmd "function! TbGotoTab(tabnr,b,c,d) \n execute a:tabnr ..'tabnext' \n endfunction"
vim.cmd "function! TbCloseAllBufs(a,b,c,d) \n lua require('nvchad.tabufline').closeAllBufs() \n endfunction"
vim.cmd "function! TbToggle_theme(a,b,c,d) \n lua require('base46').toggle_theme() \n endfunction"
vim.cmd "function! TbToggleTabs(a,b,c,d) \n let g:TbTabsToggled = !g:TbTabsToggled | redrawtabline \n endfunction"

-------------------------------------------------------- functions ------------------------------------------------------------

local function getNvimTreeWidth()
  --Print("getNvimTreeWidth")
  for _, win in pairs(api.nvim_tabpage_list_wins(0)) do
    local ft = vim.bo[api.nvim_win_get_buf(win)].ft
    --if ft then
    --  Print("ft:", ft)
    --end
    if ft == "NvimTree" or ft == "aerial" then
      --Print("aerial found", api.nvim_win_get_width(win))
      --Print("aerial found")
      return api.nvim_win_get_width(win) + 1
    end
  end
  return 0
end

------------------------------------- modules -----------------------------------------
local M = {}

local function available_space()
  local str = ""

  for _, key in ipairs(config.order) do
    if key ~= "buffers" then
      str = str .. M[key]()
    end
  end

  local modules = api.nvim_eval_statusline(str, { use_tabline = true })
  --Print("available_space: ", vim.o.columns, " ", modules.width)
  --return vim.o.columns - modules.width
  return vim.o.columns - modules.width - 1 --remove space for extra tabs icon
end

M.treeOffset = function()
  return "%#NvimTreeNormal#" .. strep(" ", getNvimTreeWidth())
end

--customization
local buf_name = vim.api.nvim_buf_get_name
local buf_opt = api.nvim_buf_get_option

local function new_hl(group1, group2)
  local fg = fn.synIDattr(fn.synIDtrans(fn.hlID(group1)), "fg#")
  local bg = fn.synIDattr(fn.synIDtrans(fn.hlID("Tb" .. group2)), "bg#")
  api.nvim_set_hl(0, group1 .. group2, { fg = fg, bg = bg })
  return "%#" .. group1 .. group2 .. "#"
end

local function filename(str)
  return str:match "([^/\\]+)[/\\]*$"
end

local function gen_unique_name(oldname, index)
  for i2, nr2 in ipairs(vim.t.bufs) do
    if index ~= i2 and filename(buf_name(nr2)) == oldname then
      return fn.fnamemodify(buf_name(vim.t.bufs[index]), ":p:.")
    end
  end
end

local function custom_style_buf(nr, i)
  -- add fileicon + name
  local icon = "󰈚"
  local len = 1 --icon
  local is_curbuf = cur_buf() == nr
  local tbHlName = "BufO" .. (is_curbuf and "n" or "ff")
  local icon_hl = new_hl("DevIconDefault", tbHlName)

  local name = filename(buf_name(nr))
  name = gen_unique_name(name, i) or name
  name = (name == "" or not name) and " No Name " or name

  if name ~= " No Name " then
    local devicon, devicon_hl = require("nvim-web-devicons").get_icon(name)

    if devicon then
      icon = devicon
      icon_hl = new_hl(devicon_hl, tbHlName)
    end
  end

  -- padding around bufname; 15= maxnamelen + 2 icon & space + 2 close icon
  --local pad = math.floor((23 - #name - 5) / 2)
  --pad = pad <= 0 and 1 or pad

  local maxname_len = 15

  name = string.sub(name, 1, 13) .. (#name > maxname_len and ".." or "")
  len = len + #name

  name = txt(" " .. name, tbHlName)

  --name = strep(" ", pad) .. (icon_hl .. icon .. name) .. strep(" ", pad - 1)
  name = icon_hl .. icon .. name
  name = name .. " "
  len = len + 1

  --local close_btn = btn(" 󰅖 ", nil, "KillBuf", nr)
  name = btn(name, nil, "GoToBuf", nr)
  len = len + 1

  -- modified bufs icon or close icon
  local mod = buf_opt(nr, "mod")
  local cur_mod = buf_opt(0, "mod")

  -- color close btn for focused / hidden  buffers
  --if is_curbuf then
  --  close_btn = cur_mod and txt("  ", "BufOnModified") or txt(close_btn, "BufOnClose")
  --else
  --  close_btn = mod and txt("  ", "BufOffModified") or txt(close_btn, "BufOffClose")
  --end

  --name = txt(name .. close_btn, "BufO" .. (is_curbuf and "n" or "ff"))
  name = txt(name, "BufO" .. (is_curbuf and "n" or "ff"))

  return name, len
end

M.buffers = function()
  local buffers = {}
  local buff_lens = {}
  local taken_space = 0       --customization
  local has_current = false   -- have we seen current buffer yet?
  local too_many_open = false --customization

  --customization
  --for i, nr in ipairs(vim.t.bufs) do
  --  if ((#buffers + 1) * 23) > available_space() then
  --    if has_current then
  --      break
  --    end

  --    table.remove(buffers, 1)
  --  end

  --  has_current = cur_buf() == nr or has_current
  --  table.insert(buffers, style_buf(nr, i))
  --end
  if vim.t.bufs == nil then
    return "Empty"
  end
  for i, nr in ipairs(vim.t.bufs) do
    --Print("t:", i, ",", nr)
    local styled_buf, styled_space = custom_style_buf(nr, i)
    --Print("&", styled_buf, "&", styled_space)
    --local styled_space = get_display_width_with_hl(styled_buf)
    if taken_space + styled_space > available_space() and has_current then
      --Print("breaking:", taken_space, ",", styled_space, ",", available_space(), ",", has_current)
      --Print("breaking, taken_space:", taken_space, "styled_space:", styled_space, "available_space", available_space(),
        --has_current)
      too_many_open = true
      break
    end
    taken_space = taken_space + styled_space
    table.insert(buffers, styled_buf)
    table.insert(buff_lens, styled_space)

    has_current = cur_buf() == nr or has_current
    while available_space() > 0 and taken_space > available_space() do
      --Print("too much", taken_space, ",", #buffers[1], ",", available_space())
      --Print("removing, taken_space:", taken_space, "styled_space:", styled_space, "available_space", available_space(),
        --has_current)
      taken_space = taken_space - buff_lens[1]
      table.remove(buffers, 1)
      table.remove(buff_lens, 1)
      too_many_open = true
    end
  end

  local too_many_open_icon = too_many_open and "%#St_lspError# " or ""
  return table.concat(buffers) .. too_many_open_icon .. txt("%=", "Fill") -- buffers + empty space
end

g.TbTabsToggled = 0

M.tabs = function()
  local result, tabs = "", fn.tabpagenr "$"
  local tabpages = vim.api.nvim_list_tabpages()

  if tabs > 1 then
    for nr = 1, tabs, 1 do
      --local tab_hl = "TabO" .. (nr == fn.tabpagenr() and "n" or "ff")
      local tab_hl
      if nr == fn.tabpagenr() then
        tab_hl = "TabOn"
      else
        local status_color_set, status_color = pcall(vim.api.nvim_tabpage_get_var, tabpages[nr], "status_color")
        if status_color_set then
          tab_hl = status_color
        else
          tab_hl = "TabOff"
        end
      end
      result = result .. btn(" " .. nr .. " ", tab_hl, "GotoTab", nr)
    end

    --local new_tabtn = btn("  ", "TabNewBtn", "NewTab")
    --local tabstoggleBtn = btn(" 󰅂 ", "TabTitle", "ToggleTabs")
    --local small_btn = btn(" 󰅁 ", "TabTitle", "ToggleTabs")

    --return g.TbTabsToggled == 1 and small_btn or new_tabtn .. tabstoggleBtn .. result
    return result
  end

  return ""
end

M.btns = function()
  local toggle_theme = btn(g.toggle_theme_icon, "ThemeToggleBtn", "Toggle_theme")
  local closeAllBufs = btn(" 󰅖 ", "CloseAllBufsBtn", "CloseAllBufs")
  return toggle_theme .. closeAllBufs
end

--return function()
--  local result = {}
--
--  if config.modules then
--    for key, value in pairs(config.modules) do
--      M[key] = value
--    end
--  end
--
--  for _, v in ipairs(config.order) do
--    table.insert(result, M[v]())
--  end
--
--  return table.concat(result)
--end
return M
