{pkgs, ...}: {
  imports = [
    ./os/darwin.nix
    ./os/linux.nix
  ];

  home.packages = with pkgs;
    [
      # nix
      cachix
      # auth
      _1password-cli
      # system utils
      htop
      btop
      zenith
      bat
      tree
      # network utils
      tcpdump
      ipcalc
      wireguard-tools
      netbird
      netbird-ui
      tailscale
      whois
      # gftp
      # logs
      lnav
      # general utils
      asciinema-agg
      fzf
      grc
      hey
      hurl
      ripgrep
      rsync
      silver-searcher
      watchman
      # system information
      fastfetch
      neofetch
      # http
      httpstat
      # compression
      unzip
      gzip
      # data utils
      jq
      jql
      fq
      # reverse engineering
      radare2
      # terminal
      # ghostty
      # remote
      upterm
      # tmux
      tmuxinator
      tmuxp
      # source control
      cvsps
      git
      gh
      subgit
      # development utils
      difftastic
      mkcert
      wasmtime
      upx
      hugo
      # storage
      minio-client
      # k8s
      kubectl
      kubernetes-helm
      kubectx
      krew
      k9s
      skaffold
      # cloud
      # awscli2
      eksctl
      (google-cloud-sdk.withExtraComponents [
        google-cloud-sdk.components.gke-gcloud-auth-plugin
      ])
      # load testing
      k6
      # sql
      usql
      sqlite
      sqlite-utils
      # redis
      redis
      # ai
      gemini-cli
      ollama
      whisper-cpp
      # TODO:
      # - oterm is fixed on main
      # - https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/ot/oterm/package.nix#L52
      # oterm
      # python
      uv
    ];
}
