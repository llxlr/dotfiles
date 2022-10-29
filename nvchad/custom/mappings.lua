local M = {}

M.coderunner = {
  n = {
    -- 使用 Ctrl+Alt+n 运行代码
    ["<C-A-n>"] = { "<CMD>lua require'CodeRunner'.run()<CR>", "" },

    -- 使用 Ctrl+` 开关浮动终端
    ["<C-Space>"] = { "<CMD>lua require'CodeRunner'.show()<CR>", "" },
    ["<C-Space>"] = { "<C-\\><C-n><CMD>lua require'CodeRunner'.hide()<CR>", "" }
  },
}

-- M.markdownpreview = {
--   n = {
--     -- 预览
--     [""] = { "<CMD> MarkdownPreview <CR>", "" },
--     -- 停止预览
--     [""] = { "<CMD> MarkdownPreviewStop <CR>", "" },
--   }
-- }

return M