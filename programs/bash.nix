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
      gdc = "gif diff --cached";
      gp = "git push";
      gpf = "git push --force-with-lease";
      gl = "git log -p --abbrev-commit --pretty=medium";
      glo = "git log --pretty=oneline --abbrev-commit";
      gs = "git status --short";

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

      d() {
        if [ ! -d "./nix" ]; then
          echo "Error: ./nix directory does not exist."
          return 1
        fi

        dir_name=$(basename "$PWD")
        
        if tmux has-session -t "$dir_name" 2>/dev/null; then
          tmux attach-session -t "$dir_name"
        else
          nix develop path:$(pwd)/nix --command tmux new -s "$dir_name" $SHELL         
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

      tg() {
        if [ -z "$1" ]
          then
            session_name=$(basename "$PWD")
          else
            session_name="$1"
        fi

        if tmux has-session -t "$session_name" 2>/dev/null; then
          tmux attach -t "$session_name"
        else
          tmux new -s "$session_name" $SHELL
        fi
      }
    '';
  };
}
