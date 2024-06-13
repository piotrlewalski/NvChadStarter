----remap some commands (configuring prefix was not enough)
local function create_command(name, GpName, complete)
  vim.api.nvim_create_user_command(name, function(params)
    --require has to be wraped in function to avoid loading gp before it's setup
    require("gp").cmd[GpName](params)
  end, {
    nargs = "?",
    range = true,
    desc = "GPT Prompt plugin",
    complete = function()
      return complete
    end,
  })
end

local completions = { "popup", "split", "vsplit", "tabnew" }

create_command("ChatNew", "ChatNew", completions)
create_command("ChatToggle", "ChatToggle", completions)
create_command("ChatPaste", "ChatPaste", completions)
create_command("ChatFinder", "ChatFinder")
create_command("ChatRespond", "ChatRespond")
create_command("ChatDelete", "ChatDelete")
create_command("ChatRewrite", "Rewrite")
create_command("ChatAppend", "Append")
create_command("ChatPrepend", "Prepend")
create_command("ChatRewriteSplit", "New")
create_command("ChatImplement", "Implement")
create_command("ChatContext", "Context")
create_command("ChatAgentPrint", "Agent")
create_command("ChatAgentNext", "NextAgent")
create_command("ChatStop", "Stop")
create_command("ChatInspect", "InspectPlugin")

local function append_to_buffer(buf, text)
  -- If the text is a string, convert it into a table where each line is an entry
  if type(text) == "string" then
    text = { text }
  end

  local line_count = vim.api.nvim_buf_line_count(buf)
  vim.api.nvim_buf_set_lines(buf, line_count, -1, false, text)
end

vim.api.nvim_create_user_command("Chat", function(params)
  --switch to the last chat (while opening it if needed)
  --paste the selected text (if any) to the target buffer
  --paste arguments to the chat buffer
  --
  --heavily based on gp.ChatPaste

  local M = require("gp")

	local cbuf = vim.api.nvim_get_current_buf()
  local last = M.config.chat_dir .. "/last.md"

  -- make new chat if last doesn't exist
  if vim.fn.filereadable(last) ~= 1 then
    M.cmd.ChatNew(params, nil, nil)
    return
  end

  local target = M.resolve_buf_target("split")

  last = vim.fn.resolve(last)
  local buf = M._H.get_buffer(last)
  local win_found = false
  if buf then
    for _, w in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(w) == buf then
        vim.api.nvim_set_current_win(w)
        vim.api.nvim_set_current_buf(buf)
        win_found = true
        break
      end
    end
  end
  buf = win_found and buf or M.open_buf(last, target, M._toggle_kind.chat, true)

  --paste the selected text (if any) to the target buffer
	M.append_selection(params, cbuf, buf)

  if params.args ~= "" then
    --paste arguments to the chat buffer
    append_to_buffer(buf, params.args)
    --vim.cmd("ChatRespond")
  end
	M._H.feedkeys("G", "xn")
end, { nargs = "*", range=true })

return {
  "robitx/gp.nvim",
  config = function()
    require("gp").setup({
      openai_api_key = { "op", "read", "op://Dev/ChatGPT/credential", "--no-newline" },
      cmd_prefix = "ZGp",
      agents = {
        {
          -- Disable ChatGPT 3.5
          name = "ChatGPT3-5",
          chat = false,
          command = false,
        },
        {
          name = "ChatGPT4",
          chat = true,
          command = false,
          -- string with model name or table with model name and parameters
          model = { model = "gpt-4-1106-preview", temperature = 1.1, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = "You are a general AI assistant.\n\n"
              .. "The user provided the additional info about how they would like you to respond:\n\n"
              .. "- If you're unsure don't guess and say you don't know instead.\n"
              .. "- Ask question if you need clarification to provide better answer.\n"
              .. "- Think deeply and carefully from first principles step by step.\n"
              .. "- Zoom out first to see the big picture and then zoom in to details.\n"
              .. "- Use Socratic method to improve your thinking and coding skills.\n"
              .. "- Don't elide any code from your output if the answer requires coding.\n",
        },
        {
          name = "CodeGPT4",
          chat = false,
          command = true,
          -- string with model name or table with model name and parameters
          model = { model = "gpt-4-1106-preview", temperature = 0.8, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = "You are an AI working as a code editor.\n\n"
              .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
              .. "START AND END YOUR ANSWER WITH:\n\n```",
        },
      },
      chat_topic_gen_model = "gpt-4o",
      -- local shortcuts bound to the chat buffer
      -- (be careful to choose something which will work across specified modes)
      --chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><C-g>" },
      --chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = ",,<CR>" },
      chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = ",," },
      chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = ",,d" },
      chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = ",,<Esc>" },
      chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = ",,c" },
    })
  end,
  event = "VeryLazy",
}
