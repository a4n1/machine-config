{ config, pkgs, ...}: {
  programs.bash = {
    enable = true;
    historyIgnore = [ "ls" "exit" "kill" ];

    shellAliases = {
      "..." = "cd -- ../..";
      "...." = "cd -- ../../..";
      grep = "grep --color=auto";
      ls = "ls --color=auto";
      tree = "tree -C";

      gc = "git commit --verbose";
      gd = "git diff --minimal";
      gp = "git push";
      gpf = "git push --force-with-lease";
      gl = "git log -p --abbrev-commit --pretty=medium";
      glo = "git log --pretty=oneline --abbrev-commit";
      gs = "git status --short";

      nd = "nix develop";
      ndd = "nix develop path=$(cwd)";

      vim = "nvim";
    };

    shellOptions = [
      "histappend"
      "autocd"
      "globstar"
      "cdspell"
      "dirspell"
      "expand_aliases"
      "dotglob"
      "gnu_errfmt"
      "histreedit"
      "nocasematch"
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };

    initExtra = ''
      if [[ $(tty) =~ ^/dev/(pts|ttys).* ]]; then
        source "$(${pkgs.blesh.outPath}/bin/blesh-share)/ble.sh";
        export PROMPT_COMMAND="tmux refresh-client -S &> /dev/null";
        export PS1="\n\001\e[0;36m\002λ\001\e[0m\002 ";
        set -o vi;
        bind 'set keyseq-timeout 1';
      else
        export PS1="\n$ "  
      fi
    '';
  };
}
