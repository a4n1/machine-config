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
      nd = "nix develop path:$(pwd)/nix";
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
        export PATH=/bin:$PATH;
        export PROMPT_COMMAND="tmux refresh-client -S &> /dev/null";
        export PS1="\n\001\e[0;36m\002λ\001\e[0m\002 ";
        source "${pkgs.blesh}/share/blesh/ble.sh";
        set -o vi;
        bind 'set keyseq-timeout 1';
      else
        export PS1="\n$ "  
      fi

      source <(COMPLETE=bash jj)

      source clap_alias
      clap_alias jc='jj commit'
      clap_alias jf='jj git fetch'
      clap_alias js='jj squash'
      clap_alias jd='jj diff'
      clap_alias jt="jj bookmark move --from \"heads(::@- & bookmarks())\" --to @-"
      clap_alias ju='jj undo'
      clap_alias jl='jj log -p'
      clap_alias jp='jj git push'
      clap_alias jn='jj new'
      clap_alias je='jj edit'
    '';
  };
}
