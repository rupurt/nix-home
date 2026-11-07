{pkgs, ...}: {
  home.packages = with pkgs;
    []
    ++ lib.optionals (pkgs.stdenv.hostPlatform.isLinux) [
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
      # iaito
      insomnia
      # remote
      ngrok
      # mainframe
      # x3270
    ];
}
