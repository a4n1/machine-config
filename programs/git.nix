{
  lib,
  username,
  useremail,
  ...
}: {
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -f ~/.gitconfig
  '';

  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "agni";
    userEmail = "a@a4n1.com";

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

    delta = {
      enable = true;
      options = {
        features = "side-by-side";
      };
    };

    aliases = {
      br = "branch";
      co = "checkout";
      rb = "rebase";
      st = "status";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
      cm = "commit -m";
      ca = "commit -am";
      dc = "diff --cached";
      amend = "commit --amend -m";

      update = "submodule update --init --recursive";
      foreach = "submodule foreach";
    };
  };
}
