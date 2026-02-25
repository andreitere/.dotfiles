return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      file_ignore_patterns = {
        "%.git/",
        "node_modules/",
      },
      hidden = true,
    },
    pickers = {
      find_files = {
        hidden = true,
        no_ignore = true,
        find_command = {
          "rg", "--files", "--hidden", "--no-ignore",
          "--glob", "!.git",
          "--glob", "!node_modules",
        },
      },
      live_grep = {
        additional_args = function()
          return {
            "--hidden", "--no-ignore",
            "--glob", "!.git",
            "--glob", "!node_modules",
          }
        end,
      },
      grep_string = {
        additional_args = function()
          return {
            "--hidden", "--no-ignore",
            "--glob", "!.git",
            "--glob", "!node_modules",
          }
        end,
      },
    },
  },
}
