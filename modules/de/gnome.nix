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
        desktopManager.gnome = {
          enable = true;
          extraGSettingsOverridePackages = [ pkgs.mutter ];
          extraGSettingsOverrides = ''
            [org.gnome.mutter]
            experimental-features=['scale-monitor-framebuffer']
          '';
        };
      };
    };

    environment.systemPackages = with pkgs; [
        gnome-tweaks
        gnomeExtensions.blur-my-shell

        gnomeExtensions.clipboard-history
        gnomeExtensions.dash-to-panel
        gnomeExtensions.user-themes
        gnomeExtensions.paperwm
        # gnomeExtensions.tiling-assistant
        gnomeExtensions.caffeine
        gnomeExtensions.miniview
        gnomeExtensions.arcmenu
        gnomeExtensions.appindicator
        gnomeExtensions.mute-spotify-ads
	gnomeExtensions.pop-shell
    ];
    
  };
}
