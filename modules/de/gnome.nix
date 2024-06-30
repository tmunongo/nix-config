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

  config = {
    services.xserver = {
      enable = lib.mkDefault (config.services.xserver.enable || false);
      layout = lib.mkDefault (config.services.xserver.layout or "us");
    };
    services.displayManager.gdm = {
      enable = lib.mkDefault (config.services.displayManager.gdm.enable || false);
    };
    services.desktopManager.gnome = {
      enable = lib.mkDefault (config.services.desktopManager.gnome.enable || false);
    };

    systemd.services."display-manager" = {
        description = "GDM Display Manager";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
        ExecStart = "${pkgs.gdm}/bin/gdm";
        Restart = "always";
        };
        condition = config.services.displayManager.gdm.enable;
    };

    systemd.services."gdm" = {
        description = "GDM service";
        wantedBy = [ "graphical.target" ];
        serviceConfig = {
        Environment = "DISPLAY :0";
        ExecStart = "${pkgs.gdm}/bin/gdm";
        Restart = "always";
        };
        condition = config.services.displayManager.gdm.enable;
    };

    programs.gnome = {
        enable = config.services.desktopManager.gnome.enable;
        packages = [ pkgs.gnome3.gnome-shell pkgs.gnome3.gdm ];
    };
  };
}
