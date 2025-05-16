{...}: {
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
        java_language_server.enable = true;
        jsonls.enable = true;
        lua_ls.enable = true;
        nil_ls.enable = true;
        pyright.enable = true;
        ruff.enable = true;
        rust_analyzer = {
          enable = true;
          installRustc = true;
          installCargo = true;
        };
        svelte.enable = true;
        tailwindcss.enable = true;
        terraformls.enable = true;
        ts_ls.enable = true;
        yamlls.enable = true;
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
