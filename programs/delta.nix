{ ... }: {
  programs.delta = {
    enable = true;
    options = {
      features = "side-by-side";
    };
  };
}
