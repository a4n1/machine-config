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

      jc = "jj commit";
      jf = "jj git fetch";
      js = "jj squash";
      jd = "jj diff";
      jt = "jj bookmark move --from \"heads(::@- & bookmarks())\" --to @-";
      ju = "jj undo";
      jl = "jj log -p";
      jp = "jj git push";
      jn = "jj new";
      je = "jj edit";

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
        source "$(${pkgs.blesh.outPath}/bin/blesh-share)/ble.sh";
        set -o vi;
        bind 'set keyseq-timeout 1';
      else
        export PS1="\n$ "  
      fi

      t() {
        local dir_name="$(basename "$PWD")"

        if tmux has-session -t "$dir_name" 2>/dev/null; then
          tmux attach-session -t "$dir_name"
        else
          tmux new -s "$dir_name" $SHELL         
        fi
      }

      ts() {
        if [ -n "$TMUX" ]; then
          tmux list-sessions -F '#{session_name}' | fzf | xargs -I {} tmux switch-client -t {}
        else
          session=$(tmux list-sessions -F '#{session_name}' | fzf)

          if [ -n "$session" ]; then
            tmux attach-session -t "$session"
          fi
        fi
      }

      jdr() {
        if [ -z "$1" ]; then
          jj diff -r @-
        else
          jj diff -r "$1"
        fi
      }

      jr() {
        if [ $# -eq 1 ]; then
          jj rebase -b @ -d "$1"
        elif [ $# -eq 2 ]; then
          jj rebase -b "$1" -d "$2"
        else
          echo "Usage jr <base> <dest>"
        fi
      }
    '';
  };
}
