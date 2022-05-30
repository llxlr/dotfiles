return {
  ["wakatime/vim-wakatime"] = {},

  ["zpyg/CodeRunner.nvim"] = {
    config = function()
      require"CodeRunner".setup {
        -- 你可以在此处自定义不同语言的执行方式
        tasks = {
          c = "make", -- 可以是字符串，会发送到浮动终端执行
          python = "python <file>", -- 尖括号标记预定义变量。见下方变量。
          go = "go run <file>",
          lua = function() -- 也可以执行一个函数
            vim.cmd("luafile %") -- 使用 VIM API
          end,
        },
        -- 此处可自定义浮动终端样式
        style = {
          -- 边框，见 `:help nvim_open_win`
          border = "rounded", -- 圆角边框
          -- 终端背景色
          bgcolor = "NONE", -- NONE 为透明
          -- 终端大小和位置，为百分数相对位置
          layout = {
            width = .8, -- 80% 编辑器大小
            height = .8,
            x = .5, -- 在编辑器中间
            y = .5
          }
        }
      }
    end,
  },

  ["lervag/vimtex"] = {
    opt = true,
    config = function()
      -- Windows
      vim.g.vimtex_view_general_viewer = 'SumatraPDF' -- SumatraPDF/Okular/Zathura
      vim.g.imtex_view_method = 'SumatraPDF'
      vim.g.vimtex_view_general_options = [[--unique file:@pdf\#src:@line@tex]]
      vim.g.vimtex_view_general_options_latexmk = '--unique'

      -- Linux
      --vim.g.vimtex_view_general_viewer = 'zathura'
      --vim.g.vimtex_view_method = 'zathura'

      -- OS X
      --vim.g.vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
      --vim.g.vimtex_view_general_options = '-r @line @pdf @tex'

      vim.g.vimtex_compiler_latexmk_engines = {
          _ = '-xelatex'
      }
      vim.g.tex_comment_nospell = 1
      vim.g.vimtex_compiler_progname = 'nvr'
    end,
    ft = 'tex',
  },

  -- ["SirVer/ultisnips"] = {
  --   opt = true,
  --   config = function()
  --     vim.g.UltiSnipsExpandTrigger="<tab>"
  --     vim.g.UltiSnipsJumpForwardTrigger="<c-b>"
  --     vim.g.UltiSnipsJumpBackwardTrigger="<c-z>"

  --     vim.g.UltiSnipsEditSplit="vertical"
  --   end,
  -- },

  -- ["honza/vim-snippets"] = {},

}