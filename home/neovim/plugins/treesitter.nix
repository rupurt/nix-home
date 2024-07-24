{
  programs.nixvim.plugins.treesitter = {
    enable = true;
    settings = {
      folding = true;
      indent = {
        enable = false;
      };
      incremental_selection = {
        enable = true;
        keymaps = {
          init_selection = "<leader>ss";
          node_incremental = "<leader>sn";
          scope_incremental = "<leader>sc";
          node_decremental = "<leader>sd";
        };
      };
    };
  };
}
