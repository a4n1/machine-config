{ lib, pkgs, system, inputs, ...}: {
  programs.firefox = {
    enable = true;

    package = if builtins.match ".*darwin" system.system != null then null else pkgs.firefox;

    profiles.default = {
      id = 0;
      isDefault = true;

      settings = {
        "browser.aboutConfig.showWarning" = false;
        "browser.ctrlTab.sortByRecentlyUsed" = false;
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.userContext.enabled" = true;
        "privacy.userContext.ui.enabled" = true;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.urlbar.eventTelemetry.enabled" = false;
        "extensions.pocket.enabled" = false;
        "extensions.abuseReport.enabled" = false;
        "identity.fxaccounts.toolbar.enabled" = false;
        "browser.uitour.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.toolbars.bookmarks.visibility" = "never";
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.suggest.recentsearches" = false;
      };

      extraConfig = ''
        user_pref("extensions.autoDisableScopes", 0);
        user_pref("extensions.enabledScopes", 15);
      '';

      extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
        ublock-origin
      ];
    };
  };
}
