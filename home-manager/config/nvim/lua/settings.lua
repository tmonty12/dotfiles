local opt = vim.opt

opt.number = true
opt.syntax = "on"
opt.clipboard = "unnamedplus"
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 300
opt.scrolloff = 8
opt.wrap = false
opt.cursorline = true
opt.guicursor = {
  "n-v-c:block-Cursor",
  "i-ci-ve:ver25-CursorInsert",
  "r-cr:hor20-CursorReplace",
  "o:hor50-Cursor",
}

local function apply_cursor_highlights()
  vim.api.nvim_set_hl(0, "Cursor", { fg = "#000000", bg = "#ffff00" })
  vim.api.nvim_set_hl(0, "CursorInsert", { fg = "#000000", bg = "#00ffcc" })
  vim.api.nvim_set_hl(0, "CursorReplace", { fg = "#000000", bg = "#ff5f5f" })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "#303030" })
end

apply_cursor_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = apply_cursor_highlights,
})

-- Format on save via LSP (ruff for Python, rust-analyzer for Rust)
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
