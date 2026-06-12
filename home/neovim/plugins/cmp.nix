{
  programs.nixvim.plugins.cmp = {
    enable = true;
    settings = {
      mapping = {
        "<C-n>" = "cmp.mapping.select_next_item()";
        "<C-p>" = "cmp.mapping.select_prev_item()";
        "<C-d>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-e>" = "cmp.mapping.abort()";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' })";
        "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' })";
      };
      sources = [
        { name = "nvim_lsp"; }
        { name = "copilot"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
    };
  };
}
