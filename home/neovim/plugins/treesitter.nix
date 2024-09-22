{
  programs.nixvim.plugins.treesitter = {
    enable = true;
    folding = true;
    # indent = false;

    settings = {
      highlight = {
        enable = true;
        additional_vim_regex_highlighting = true;
        custom_captures = {};
        disable = [];
      };
      incremental_selection = {
        enable = true;
        keymaps = {
          init_selection = false;
          node_decremental = "grm";
          node_incremental = "grn";
          scope_incremental = "grc";
        };
      };
    };

    # incrementalSelection = {
    #   enable = true;
    #   keymaps = {
    #     initSelection = "<leader>ss";
    #     nodeIncremental = "<leader>sn";
    #     scopeIncremental = "<leader>sc";
    #     nodeDecremental = "<leader>sd";
    #   };
    # };
  };
}
