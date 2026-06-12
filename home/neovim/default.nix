{pkgs, ...}: {
  imports = [
    ./plugins
    ./options
  ];

  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.MANPAGER = "nvim +Man!";

  programs.nixvim = {
    enable = true;
    nixpkgs.pkgs = pkgs;
    globals.mapleader = " ";
    luaLoader.enable = true;

    colorschemes = {
      gruvbox = {
        enable = false;
      };
      onedark = {
        enable = false;
        settings = {
          style = "cool";
        };
      };
      oxocarbon = {
        enable = false;
      };
      poimandres = {
        enable = false;
      };
      rose-pine = {
        enable = false;
        settings = {
          dark_variant = "moon";
        };
      };
      tokyonight = {
        enable = true;
        settings = {
          style = "storm";
        };
      };
      vscode = {
        enable = false;
      };
    };

    keymaps = [
      {
        action = "<cmd>make<CR>";
        key = "<leader>m";
      }
      {
        action = "<cmd>Explore<CR>";
        key = "\\";
      }
      {
        action = "<cmd>DiffviewOpen<CR>";
        key = "<leader>g";
      }
    ];
  };
}
