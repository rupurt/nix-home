{...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    signing.format = "openpgp";

    settings = {
      user = {
        name = "Alex Kwiatkowski";
        email = "alex+git@fremantle.io";
      };

      alias = {
        st = "status";
        co = "checkout";
        w = "log --raw --no-merges";
        fo = "fetch origin";
        pr = "pull --rebase";
      };

      init.defaultBranch = "main";
      diff.colorMoved = "default";
    };

    ignores = [
      # ".venv"
    ];
  };
}
