{ pkgs, system, ...}:
let
    servers = {
      thirver = true;
    };
    serverPrompt = ''\n\001\e[0;36m\002(\h) λ\001\e[0m\002 '';
    desktopPrompt = ''\n\001\e[0;36m\002λ\001\e[0m\002 '';
    PS1 =
      if servers ? ${system.hostname}
      then serverPrompt
      else desktopPrompt;
    ps1Export = ''export PS1="${PS1}";'';
in {
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
        [[ $- == *i* ]] && source -- "${pkgs.blesh}/share/blesh/ble.sh" --attach=none

        export PATH=/bin:$PATH
        ${ps1Export}
        set -o vi
        bind 'set keyseq-timeout 1'
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

      notes() {
        if [ -z "$1" ]; then
            echo "Usage: notes <name>"
            return 1
        fi
        vim "scp://notes@thirver//home/notes/$1.txt"
      }

      dd() {
          if [ -z "$1" ]; then
              echo "Usage: dd <image_name>"
              return 1
          fi

          local IMAGE_NAME="$1"

          docker build -t "$IMAGE_NAME:latest" . || return 1
          docker tag "$IMAGE_NAME:latest" "a4n1/$IMAGE_NAME:latest" || return 1
          docker push "a4n1/$IMAGE_NAME:latest" || return 1
          echo "Done! Image pushed: a4n1/$IMAGE_NAME:latest"
      }

      dr() {
          if [ $# -lt 2 ]; then
              echo "Usage: dr <image_name> <port>"
              return 1
          fi

          local IMAGE_NAME="$1"
          local PORT="$2"
          shift 2

          docker rm -f "$NAME" 2>/dev/null || true
          docker build -t "$IMAGE_NAME" . || return 1
          docker run -p "$PORT:$PORT" --name "$IMAGE_NAME" "$@" "$IMAGE_NAME"
      }

      pr() {
          if [ -z "$1" ]; then
              echo "Usage: pr <image_name>"
              return 1
          fi

          local NAME="$1"
          local IMAGE="docker.io/a4n1/$NAME:latest"
          local SERVICE="podman-$NAME.service"

          podman pull "$IMAGE" || return 1
          sudo systemctl restart "$SERVICE" || return 1
          echo "Done! $SERVICE restarted with the latest image"
      }

      if [[ $(tty) =~ ^/dev/(pts|ttys).* ]]; then
        [[ ! $\{BLE_VERSION-} ]] || ble-attach
      fi
    '';
  };
}
