return {
  "hrsh7th/nvim-cmp",
  dependencies = { "hrsh7th/cmp-emoji", "supermaven-inc/supermaven-nvim" },
  opts = function(_, opts)
    table.insert(opts.sources, { name = "emoji" })
    opts.experimental.ghost_text = false
    for _, source in ipairs(opts.sources) do
      if source.name == "codeium" then
        source.priority = 1
        break
      end
    end
  end,
}
