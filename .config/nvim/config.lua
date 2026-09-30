
local function open_action_menu()
  vim.ui.select({
    { label = "Open file", action = function() require("snacks").picker.files { cwd = vim.fn.getcwd() } end },
    { label = "Find text", action = function() require("snacks").picker.grep { cwd = vim.fn.getcwd() } end },
    { label = "Modified files", action = function() require("snacks").picker.git_status() end },
    { label = "Git diff (working tree)", action = function() require("snacks").picker.git_diff() end },
    {
      label = "Git diff (origin/main)",
      action = function() require("snacks").picker.git_diff { base = "origin/main" } end,
    },
    { label = "Git diff (last commit)", action = function() require("snacks").picker.git_diff { base = "HEAD~1" } end },
    { label = "Git log (work directory)", action = function() require("snacks").picker.git_log() end },
    { label = "Git log (current file)", action = function() require("snacks").picker.git_log_file() end },
    { label = "Blame current line", action = function() require("snacks").git.blame_line() end },
    { label = "History current line", action = function() require("snacks").picker.git_log_line() end },
    { label = "TODOs and FIXMEs", action = function() require("snacks").picker.todo_comments() end },
    { label = "Diagnostics", action = function() require("snacks").picker.diagnostics() end },
    { label = "Symbols", action = function() require("snacks").picker.lsp_symbols() end },
    { label = "Find references", action = function() require("snacks").picker.lsp_references() end },
    { label = "Find definitions", action = function() require("snacks").picker.lsp_definitions() end },
    { label = "Quickfix list", action = function() require("snacks").picker.qflist() end },
    { label = "File tree", action = function() vim.cmd.Neotree "focus" end },
    { label = "Buffers", action = function() require("snacks").picker.buffers() end },
    { label = "Recent files", action = function() require("snacks").picker.recent() end },
  }, {
    prompt = "Actions",
    format_item = function(item) return item.label end,
  }, function(item)
    if item then item.action() end
  end)
end

local astrocore = {
  "AstroNvim/astrocore",
  opts = {
    autocmds = {
      reviewer_file_tree = {
        {
          event = "FileType",
          pattern = "neo-tree",
          desc = "Keep an editable window beside the file tree",
          callback = function()
            vim.schedule(function()
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].filetype ~= "neo-tree" and vim.bo[buf].buftype == "" then return end
              end
              vim.cmd("wincmd v")
              vim.cmd("enew")
            end)
          end,
        },
      },
    },
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = false, -- show absolute line numbers in every buffer
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
      },
    },
    mappings = {
      n = {

        ["<C-o>"] = {
          function() require("snacks").picker.files { cwd = vim.fn.getcwd() } end,
          desc = "Open file",
        },
        ["<C-p>"] = {
          open_action_menu,
          desc = "Command palette",
        },

        ["<Leader>gs"] = {
          function() require("snacks").picker.git_status() end,
          desc = "Git modified files",
        },
        ["<Leader>gd"] = {
          function() require("snacks").picker.git_diff() end,
          desc = "Git diff (working tree)",
        },
        ["<Leader>gD"] = {
          function() require("snacks").picker.git_diff { base = "origin/main" } end,
          desc = "Git diff (origin/main)",
        },
        ["<Leader>g1"] = {
          function() require("snacks").picker.git_diff { base = "HEAD~1" } end,
          desc = "Git diff (last commit)",
        },
        ["<Leader>gl"] = {
          function() require("snacks").picker.git_log() end,
          desc = "Git log (work directory)",
        },
        ["<Leader>gL"] = {
          function() require("snacks").picker.git_log_file() end,
          desc = "Git log (current file)",
        },

        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },


      },
    },
  },
}

local ui = {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true,
      open_on_setup = false,
      filesystem = {
        filtered_items = { hide_dotfiles = false },
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        position = "left",
        width = 32,
        auto_expand_width = false,
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "▎" },
      },
    },
  },
}

local plugins = { astrocore }
vim.list_extend(plugins, ui)

-- Use the optional local Noctalia palette when present.
if vim.fn.filereadable(vim.fn.stdpath("config") .. "/lua/matugen.lua") == 1 then
  plugins[#plugins + 1] = {
    "RRethy/base16-nvim",
    config = function()
      local ok, palette = pcall(require, "matugen")
      if ok then palette.setup() end
    end,
  }
end
return plugins
