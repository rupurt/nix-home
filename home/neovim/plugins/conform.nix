{
  programs.nixvim.plugins.conform-nvim = {
    enable = true;
    settings = {
      formatters_by_ft = {
        rust = [ "rustfmt" ];
        nix = [ "nixfmt" ];
        lua = [ "stylua" ];
        python = [ "ruff_format" ];
        go = [ "gofmt" "goimports" ];
        javascript = [ "biome" ];
        typescript = [ "biome" ];
        json = [ "biome" ];
        css = [ "biome" ];
        html = [ "biome" ];
        yaml = [ "yamlfmt" ];
        terraform = [ "terraform_fmt" ];
        "*" = [ "trim_whitespace" ];
      };
      format_on_save = {
        lspFallback = true;
        timeoutMs = 500;
      };
    };
  };
}
