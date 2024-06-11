return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    {
      "zbirenbaum/copilot-cmp",
      event = { "InsertEnter" },
      config = function()
        require("copilot_cmp").setup()
      end,
    },
  },
  opts = {
    sources = {
      { name = "nvim_lsp" },
      { name = "html-css" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "nvim_lua" },
      { name = "path" },
      { name = "copilot" },
    },
  },
  event = { "InsertEnter" },
}
