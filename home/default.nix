{pkgs, ...}: {
  imports = [
    ./tmux.nix
    ./neovim
    ./zsh.nix
    ./git.nix
    ./difftastic.nix
    ./direnv.nix
    ./packages
  ];

  # homebrew.casks = [
  #   # "amazon-workspaces"
  #   # "tandem"
  #   "dbeaver-community"
  #   # "dbvisualizer"
  # ];

  home.username = "alex";
  home.homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/alex"
    else "/home/alex";

  fonts = {
    fontconfig.enable = true;
    # packages = [
    #   pkgs.nerd-fonts.fira-code
    # ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";
}
