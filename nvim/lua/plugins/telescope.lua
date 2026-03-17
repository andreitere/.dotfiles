return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      mappings = {
        i = {
          -- Toggle no_ignore: re-launches picker showing gitignored files
          ["<C-u>"] = function(prompt_bufnr)
            local action_state = require("telescope.actions.state")
            local current_picker = action_state.get_current_picker(prompt_bufnr)
            local prompt = current_picker:_get_prompt()

            require("telescope.actions").close(prompt_bufnr)

            local picker_name = current_picker.prompt_title
            if picker_name == "Find Files" then
              require("telescope.builtin").find_files({
                hidden = true,
                no_ignore = true,
                default_text = prompt,
                find_command = {
                  "rg", "--files", "--hidden", "--no-ignore",
                  "--glob", "!.git",
                },
              })
            elseif picker_name == "Live Grep" then
              require("telescope.builtin").live_grep({
                default_text = prompt,
                additional_args = { "--hidden", "--no-ignore", "--glob", "!.git" },
              })
            end
          end,
        },
      },
      file_ignore_patterns = {
        "%.git/",
      },
      hidden = true,
    },
    pickers = {
      find_files = {
        hidden = true,
        find_command = {
          "rg", "--files", "--hidden",
          "--glob", "!.git",
        },
      },
      live_grep = {
        additional_args = function()
          return { "--hidden", "--glob", "!.git" }
        end,
      },
      grep_string = {
        additional_args = function()
          return { "--hidden", "--glob", "!.git" }
        end,
      },
    },
  },
}
