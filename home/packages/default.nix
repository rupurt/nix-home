{pkgs, ...}: {
  imports = [
    ./darwin.nix
    ./linux.nix
  ];

  home.packages = with pkgs;
    [
      # system utils
      htop
      btop
      bat
      tree
      # network utils
      wireguard-tools
      netbird
      netbird-ui
      tailscale
      whois
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
      # data utils
      jq
      jql
      fq
      # reverse engineering
      radare2
      # emulation
      qemu
      # remote
      upterm
      # development utils
      tmuxinator
      git
      gh
      gnumake
      cmake
      difftastic
      mkcert
      protobuf
      packer
      wasmtime
      upx
      hugo
      docker
      docker-buildx
      docker-compose
      # observability
      prometheus
      grafana
      # storage
      minio-client
      # k8s
      kubectl
      kubernetes-helm
      kubectx
      krew
      k9s
      # k3d nameclash
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/aliases.nix#L780
      kube3d
      skaffold
      # k3d nameclash
      _1password
      _1password-gui
      # cloud
      awscli2
      eksctl
      (google-cloud-sdk.withExtraComponents [
        google-cloud-sdk.components.gke-gcloud-auth-plugin
      ])
      terraform
      terraform-ls
      pulumi
      flyctl
      # load testing
      k6
      # kafka
      kcat
      kafkactl
      #redpanda
      # sql
      usql
      duckdb
      octosql
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
    ++ lib.optionals (!pkgs.stdenv.isDarwin) [
      zsh
      gotop
      iaito
      insomnia
    ];
}