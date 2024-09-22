{pkgs, ...}: {
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      servers = {
        clangd.enable = true;
        cssls.enable = true;
        elixirls.enable = true;
        eslint.enable = true;
        gopls.enable = true;
        html.enable = true;
        jsonls.enable = true;
        lua_ls.enable = true;
        nil_ls.enable = true;
        pyright.enable = true;
        ruff_lsp.enable = true;
        rust_analyzer = {
          enable = true;
          installRustc = true;
          installCargo = true;
        };
        svelte.enable = true;
        tailwindcss.enable = true;
        terraformls.enable = true;
        # tsserver.enable = true;
        ts_ls.enable = true;
        yamlls.enable = true;
        # zls fails to compile on darwin with the current flake.lock
        zls.enable = false;
      };
      keymaps = {
        lspBuf = {
          gi = "implementation";
          "<leader>f" = "format";
        };
      };
    };
  };
}
