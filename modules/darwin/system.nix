{ pkgs, ... }: {
  system = {
    stateVersion = 5;

    defaults = {
      menuExtraClock.Show24Hour = true;
      
      dock = {
        autohide = true;
        show-recents = false;
        mru-spaces = false;
        persistent-others = [];
      };

      finder = {
        FXDefaultSearchScope = "SCcf";
        FXPreferredViewStyle = "clmv";
      };

      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        Dragging = true;
      };

      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = false;
        "com.apple.sound.beep.feedback" = 0;
        AppleSpacesSwitchOnActivate = false;
        AppleEnableSwipeNavigateWithScrolls = false;
        AppleInterfaceStyle = "Dark";
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 15;
        KeyRepeat = 3;
        NSAutomaticCapitalizationEnabled = false;  
        NSAutomaticDashSubstitutionEnabled = false;  
        NSAutomaticPeriodSubstitutionEnabled = false;  
        NSAutomaticQuoteSubstitutionEnabled = false;  
        NSAutomaticSpellingCorrectionEnabled = false;  
      };

      CustomUserPreferences = {
        "com.apple.Finder" = {
          NewWindowTarget = "Home";
      };

        "com.apple.Spotlight" = {
          orderedItems = [
            { enabled = true; name = "APPLICATIONS"; }
            { enabled = true; name = "SYSTEM_PREFS"; }
            { enabled = false; name = "PDF"; }
            { enabled = false; name = "MENU_SPOTLIGHT_SUGGESTIONS"; }
            { enabled = false; name = "BOOKMARKS"; }
            { enabled = false; name = "EVENT_TODO"; }
            { enabled = false; name = "SPREADSHEETS"; }
            { enabled = false; name = "MENU_OTHER"; }
            { enabled = false; name = "TIPS"; }
            { enabled = false; name = "DIRECTORIES"; }
            { enabled = false; name = "FONTS"; }
            { enabled = false; name = "PRESENTATIONS"; }
            { enabled = false; name = "MUSIC"; }
            { enabled = false; name = "MOVIES"; }
            { enabled = false; name = "MESSAGES"; }
            { enabled = false; name = "IMAGES"; }
            { enabled = false; name = "MENU_EXPRESSION"; }
            { enabled = false; name = "DOCUMENTS"; }
            { enabled = false; name = "MENU_DEFINITION"; }
            { enabled = false; name = "MENU_CONVERSION"; }
            { enabled = false; name = "CONTACT"; }
          ];
        };
      };
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  programs.zsh.enable = true;

  environment.shells = [
    pkgs.bashInteractive
  ];

  environment = {
    etc."pam.d/sudo_local".text = ''
      # Managed by Nix Darwin
      auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
      auth       sufficient     pam_tid.so
    '';
  };

  system.activationScripts.setupLaunchAgents = {
    enable = true;
    text = ''
      #!/usr/bin/env bash

      sudo /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u;

      if [[ $SHELL != *bash* ]]; then
        sudo chsh -s /run/current-system/sw/bin/bash;
      fi

      sudo defaultbrowser firefox;
    '';
  };
}
