{pkgs, ...}: {
  imports = [
    ./darwin.nix
    ./linux.nix
  ];

  home.packages = with pkgs;
    [
      # nix
      cachix
      # auth
      _1password
      _1password-gui
      # system utils
      htop
      btop
      zenith
      bat
      tree
      pax-utils
      # network utils
      tcpdump
      ipcalc
      wireguard-tools
      netbird
      netbird-ui
      tailscale
      whois
      gftp
      # general utils
      ripgrep
      silver-searcher
      fzf
      asciinema-agg
      grc
      hey
      hurl
      neofetch
      rsync
      watchman
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
      # remote
      upterm
      ngrok
      # tmux
      tmuxinator
      tmuxp
      # git
      git
      gh
      subgit
      # development utils
      difftastic
      mkcert
      packer
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
      awscli2
      eksctl
      (google-cloud-sdk.withExtraComponents [
        google-cloud-sdk.components.gke-gcloud-auth-plugin
      ])
      terraform
      terraform-ls
      flyctl
      # load testing
      k6
      # kafka
      kcat
      kafkactl
      # sql
      usql
      sqlite
      sqlite-utils
      # redis
      redis
      # languages
      jdk
      gopls
      rust-analyzer
      zls

      (nerdfonts.override {fonts = ["FiraCode"];})
    ]
    ++ lib.optionals (pkgs.stdenv.isDarwin) [
      asitop
      xclip
    ]
    ++ lib.optionals (pkgs.stdenv.isLinux) [
      zsh
      # network utils
      dhcpdump
      junkie
      # docker
      # gpu
      nvtopPackages.full
      gotop
      iaito
      insomnia
      # cloud
      pulumi
      # mainframe
      x3270
    ];
}
