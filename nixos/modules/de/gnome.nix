# gnome.nix

{ lib, config, pkgs, ... }:

{
  options = {
    services.xserver.enable = lib.mkEnableOption "Enable X server";
    services.xserver.layout = lib.mkOption {
      type = lib.types.string;
      default = "us";
      description = "X server keyboard layout";
    };
    services.displayManager.gdm.enable = lib.mkEnableOption "Enable GDM";
    services.desktopManager.gnome.enable = lib.mkEnableOption "Enable GNOME Desktop Environment";
  };
}
