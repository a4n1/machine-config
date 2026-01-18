{ ... }: {
  imports = [
    ./scripts.nix
    ./bash.nix
    ./blesh.nix
    ./git.nix
    ./delta.nix
    ./jujutsu.nix
    ./tmux.nix
    ./neovim
    ./atuin.nix
  ];
}

