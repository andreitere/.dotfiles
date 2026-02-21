-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

-- remove defaults
vim.keymap.del("n", "<leader>e")
vim.keymap.del("n", "<leader>E")

-- reveal (rooted/cwd style)
vim.keymap.set("n", "<leader>e", function()
  require("snacks.explorer").open({ cwd = true })
end, { desc = "Explorer Snacks (cwd)" })

-- simple toggle
vim.keymap.set("n", "<leader>E", function()
  require("snacks.explorer").toggle()
end, { desc = "Explorer Snacks Toggle" })
