{ ... }: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Agni";
        email = "a@a4n1.com";
      };

      ui = {
        default-command = "log";
        graph.style = "curved";
        should-sign-off = true;
        diff-formatter = ":git";
        pager = "delta";
      };

      signing = {
        behavior = "own";
        backend = "ssh";
        key = "~/.ssh/id_ed25519.pub";
      };

      git = {
        sign-on-push = true;
        write-change-id-header = true;
      };

      template-aliases = {
        "format_timestamp(timestamp)" = "timestamp.ago()";
      };

      templates = {
        draft_commit_description = ''
          concat(
            coalesce(description, default_commit_description, "\n"),
            if(
              config("ui.should-sign-off").as_boolean() && !description.contains("Signed-off-by: " ++ author.name()),
              "\nSigned-off-by: " ++ author.name() ++ " <" ++ author.email() ++ ">",
            ),
            surround(
              "\nJJ: This commit contains the following changes:\n", "",
              indent("JJ:     ", diff.stat(72)),
            ),
            "\nJJ: ignore-rest\n",
            diff.git(),
          )
        '';
      };
    };
  };
}
