local M = {}

local userPlugins = require "custom.plugins"

M.options = {
  nvChad = {
    -- updater
    update_url = "git@github.com:NvChad/NvChad.git",
    update_branch = "main",
  },
  user = function()
    require("custom.options")
  end,
}

M.ui = {
  hl_override = {},
  changed_themes = {},
  theme_toggle = { "onedark", "one_light" },
  theme = "onedark",
  transparency = true,
}

M.plugins = {
  override = {},
  remove = {},

  options = {
    lspconfig = {
      setup_lspconf = "custom.plugins.lspconfig", -- lspconfig 文件路径
    },
    statusline = {
      separator_style = "round", -- default/round/slant/block/arrow
      config = "%!v:lua.require'ui.statusline'.run()",
    },
    telescope = {
      extensions = { "themes", "terms" },
    }
  },

  user = userPlugins,
}

-- 自定义快捷键
M.mappings = require "custom.mappings"

return M