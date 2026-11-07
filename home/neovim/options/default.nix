{pkgs, ...}: {
  programs.nixvim.opts = {
    number = true;
    expandtab = true;
    tabstop = 2;
    shiftwidth = 2;
    clipboard =
      if pkgs.stdenv.hostPlatform.isDarwin
      then "unnamed"
      else "unnamedplus";
    wrap = false;
  };
}
