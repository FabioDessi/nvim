return {
  'numToStr/Comment.nvim',

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },

  lazy = false,
  config = function()
    require('Comment').setup()
  end,
}
