{
  programs.nixvim.plugins.copilot-lua = {
    enable = true;
    settings = {
      panel = {
        enabled = false;
      };
      suggestion = {
        enabled = false;
      };
    };
  };
}
