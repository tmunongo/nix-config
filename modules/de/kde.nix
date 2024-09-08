# kde.nix
{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.desktop.kde;
in {
  options.desktop.kde = {
    enable = mkEnableOption "Enable KDE Plasma desktop environment";
  };

  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        xkb.layout = "us";
      };
      displayManager.sddm.enable = true;
      displayManager.sddm.wayland.enable = true;
      desktopManager.plasma6.enable = true;
    };

    environment.systemPackages = with pkgs; [
      # KDE applications and utilities
      kdeplasma-addons
      kdePackages.spectacle
      kdePackages.dolphin
      kdePackages.konsole
      kdePackages.kate
      # kdePackages.okular
      kdePackages.ark

      # libsForQt5.krohnkite
      # kdePackages.gwenview
      
      # Additional KDE-related packages
      latte-dock
      # libsForQt5.polonium
      whitesur-kde
      whitesur-cursors
      whitesur-icon-theme
      # kdeconnect
      
      # KWin scripts
#       (pkgs.writeTextFile {
#         name = "kwin-tiling";
#         destination = "/share/kwin/scripts/tiling/metadata.desktop";
#         text = ''
#           [Desktop Entry]
#           Name=Tiling
#           Comment=Tiling script for KWin
#           Icon=preferences-system-windows-script-test
#
#           X-Plasma-API=javascript
#           X-Plasma-MainScript=code/main.js
#
#           X-KDE-PluginInfo-Author=Your Name
#           X-KDE-PluginInfo-Email=your.email@example.com
#           X-KDE-PluginInfo-Name=tiling
#           X-KDE-PluginInfo-Version=1.0
#
#           X-KDE-PluginInfo-Depends=
#           X-KDE-PluginInfo-License=GPL
#           X-KDE-ServiceTypes=KWin/Script
#           Type=Service
#         '';
#       })
#       (pkgs.writeTextFile {
#         name = "kwin-tiling-script";
#         destination = "/share/kwin/scripts/tiling/contents/code/main.js";
#         text = ''
#           // KWin tiling script
#           workspace.clientAdded.connect(function(client) {
#             if (client.normalWindow) {
#               workspace.activeScreen = client.screen;
#               workspace.desktops = 2;
#               workspace.currentDesktop = 1;
#               client.geometry = workspace.clientArea(KWin.PlacementArea, workspace.activeScreen, workspace.currentDesktop);
#             }
#           });
#         '';
#       })
    ];

    # Enable KDE Connect
    programs.kdeconnect.enable = true;

    # Configure KWin
    # programs.kwin = {
    #  enable = true;
    #  scripts = [
    #    "tiling"
    #  ];
    #};
  };
}
