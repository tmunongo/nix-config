{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.desktop.hyprland;
in {
  options.services.hyprland = {
    enable = mkEnableOption "enable hyprland WM";

    
  };

  config = mkIf cfg.enable {
    programs.hyprland.enable = true;

    # desktop portals for hyprland
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    # software
    environment.systemPackages = with pkgs; [
      swaync
      waybar
      lxqt.lxqt-policykit
      swww
    ];


    # connectivity
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman.enable = true;
  };
};
