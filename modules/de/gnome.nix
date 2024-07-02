# gnome.nix

{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.desktop.gnome;
in {
  options.desktop.gnome = {
    enable = mkEnableOption "Enable X server";
  };
  
  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
    	xkb.layout = "us";

        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
        gnome.gnome-tweaks
    ];
    
  };
}
