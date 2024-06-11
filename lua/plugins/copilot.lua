return {
  "zbirenbaum/copilot.lua",
  event = { "InsertEnter" },
  cmd = { "Copilot" },
  opts = {
    suggestion = { enabled = false },
    panel = { auto_refresh = true, layout = { ratio = 0.2 } },
  },
}
