{pkgs, ...}: {
  home.packages = with pkgs;
    []
    ++ lib.optionals (pkgs.stdenv.isLinux) [
      # shell
      zsh
      # network utils
      dhcpdump
      # system utils
      pax-utils
      # observability
      osquery
      # gpu
      nvtopPackages.full
      gotop
      iaito
      insomnia
      # remote
      # ngrok is broken SSL routines::wrong version number
      # ngrok
      # mainframe
      x3270
    ];
}
