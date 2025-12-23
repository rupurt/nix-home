{
  programs.nixvim.plugins.treesitter-textobjects = {
    enable = true;

    settings = {
      move = {
        enable = true;
      };
      select = {
        enable = true;
        lookahead = true;
        keymaps = {
          "a=" = "@assignment.outer";
          "i=" = "@assignment.inner";
          "l=" = "@assignment.lhs";
          "r=" = "@assignment.rhs";
          "ap" = "@conditional.outer";
          "ip" = "@conditional.inner";
          "af" = "@call.outer";
          "if" = "@call.inner";
          "am" = "@function.outer";
          "im" = "@function.inner";
          "ac" = "@class.outer";
          "ic" = "@class.inner";
          "al" = "@loop.outer";
          "il" = "@loop.inner";
        };
      };
      swap = {
        enable = true;
      };
    };
  };
}
