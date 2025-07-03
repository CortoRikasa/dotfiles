-- See the kickstart.nvim README for more information
--
return {
  --Zen-mode
  -- {
  --   'folke/zen-mode.nvim',
  --   opts = {
  --     -- your configuration comes here
  --     -- or leave it empty to use the default settings
  --     -- refer to the configuration section below
  --   },
  -- },
  -- {
  --   'github/copilot.vim',
  --   config = function()
  --     vim.cmd 'Copilot setup'
  --   end,
  -- },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'

      harpoon:setup()

      -- Key mappings for Harpoon
      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():append()
      end, { desc = 'Add current file to Harpoon' })
      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = 'Toggle Harpoon menu' })

      vim.keymap.set('n', '<C-h>', function()
        harpoon:list():select(1)
      end, { desc = 'Select first Harpoon item' })
      vim.keymap.set('n', '<C-j>', function()
        harpoon:list():select(2)
      end, { desc = 'Select second Harpoon item' })
      vim.keymap.set('n', '<C-k>', function()
        harpoon:list():select(3)
      end, { desc = 'Select third Harpoon item' })
      vim.keymap.set('n', '<C-l>', function()
        harpoon:list():select(4)
      end, { desc = 'Select fourth Harpoon item' })
    end,
  },
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    keys = {
      { '<leader>u', '<cmd>UndotreeToggle<CR>', desc = 'Toggle Undotree' },
    },
  },
  {
    'fasterius/simple-zoom.nvim',
    config = true,
  },
  -- {
  --   'nvim-neo-tree/neo-tree.nvim',
  --   branch = 'v3.x',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
  --     'MunifTanjim/nui.nvim',
  --     -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  --   },
  --   lazy = false, -- neo-tree will lazily load itself
  --   ---@module "neo-tree"
  --   ---@type neotree.Config?
  --   opts = {
  --     -- fill any relevant options here
  --   },
  -- },
  -- {
  --   'nvim-neorg/neorg',
  --   build = ':Neorg sync-parsers',
  --   dependencies = { 'nvim-lua/plenary.nvim' },
  --   config = function()
  --     require('neorg').setup {
  --       load = {
  --         ['core.defaults'] = {}, -- Loads default behaviour
  --         ['core.concealer'] = {}, -- Adds pretty icons to your documents
  --         ['core.dirman'] = { -- Manages Neorg workspaces
  --           config = {
  --             workspaces = {
  --               notes = '~/notes',
  --             },
  --           },
  --         },
  --       },
  --     }
  --   end,
  -- },
}
