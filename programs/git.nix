{ lib, ... }: {
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -f ~/.gitconfig
  '';

  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user = {
        name = "agni";
        email = "a@a4n1.com";
      };

      alias = {
        update = "submodule update --init --recursive";
        foreach = "submodule foreach";
      };

      extraConfig = {
        init.defaultBranch = "master";
        commit.gpgsign = true;
        commit.verbose = true;
        push.autoSetupRemote = true;
        pull.rebase = true;
        column = {
          ui = "auto dense";
          status = "never";
        };
        branch.sort = "-committerdate";
        worktree.guessRemote = true;
        rebase = {
          abbreviateCommands = true;
          stat = true;
        };
        rerere = {
          enabled = true;
          autoUpdate = true;
        };
        merge.conflictstyle = "diff3";
      };
    };
  };
}
