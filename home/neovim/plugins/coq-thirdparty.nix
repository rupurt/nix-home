{
  programs.nixvim.plugins.coq-thirdparty = {
    enable = false;
    sources = [
      {
        src = "copilot";
        accept_key = "<c-f>";
        short_name = "COP";
      }
    ];
  };
}
