{pkgs, ...}: {
  home.packages = with pkgs;
    []
    ++ lib.optionals (pkgs.stdenv.isDarwin) [
      macpm
      xclip
    ];
}
