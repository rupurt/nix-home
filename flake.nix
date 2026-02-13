{
  description = "Home Manager configuration for alex";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    codex = {
      url = "github:openai/codex";
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    home-manager,
    nixvim,
    codex,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [];
      };
      homeConfigurations = {
        alex = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;

          extraSpecialArgs = {
            codex-pkg = let
              codex-base = codex.packages.${system}.default;
            in
              if pkgs.stdenv.isLinux
              then
                codex-base.overrideAttrs (old: {
                  nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.pkg-config];
                  buildInputs = (old.buildInputs or []) ++ [pkgs.libcap];
                })
              else codex-base;
          };

          modules = [
            nixvim.homeModules.nixvim
            ./home
          ];
        };
      };
    in {
      # packages exported by the flake
      packages = {
        homeConfigurations = homeConfigurations;
        default = home-manager.defaultPackage.${system};
      };

      # nix fmt
      formatter = pkgs.alejandra;
    });
  in
    outputs;
}
