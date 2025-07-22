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
      desktopManager.plasma6.enableQt5Integration = false;
    };

    environment.systemPackages = with pkgs; [
      # KDE applications and utilities
      # kdeplasma-addons
      # kdePackages.dolphin
      # kdePackages.konsole
      # kdePackages.kate
      # kdePackages.ark
      
      # Additional KDE-related packages
      # whitesur-kde
      # whitesur-cursors
      # whitesur-icon-theme
      # kdeconnect
      
      # KWin scripts
    ];

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      okular
      gwenview
      spectacle
    ];

    # Enable KDE Connect
    programs.kdeconnect.enable = true;
  };
}
