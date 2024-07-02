{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nixos-config-backup;
  backupScript = pkgs.writeScriptBin "backup-nixos-config" (builtins.readFile ./backup-nixos-config.sh);
in {
  options.services.nixos-config-backup = {
    enable = mkEnableOption "NixOS config backup service";
    user = mkOption {
      type = types.str;
      default = "your-username";
      description = "User to run the backup script as";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.nixos-config-backup = {
      description = "Backup NixOS configuration";
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        ExecStart = "${backupScript}/bin/backup-nixos-config";
      };
    };

    systemd.timers.nixos-config-backup = {
      wantedBy = [ "timers.target" ];
      partOf = [ "nixos-config-backup.service" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };

    # Ensure git is installed
    environment.systemPackages = [ pkgs.git ];

    # Set up SSH for the user
    programs.ssh = {
      startAgent = true;
      extraConfig = ''
        Host github.com
          IdentityFile /home/${cfg.user}/.ssh/id_ed25519
      '';
    };
  };
}
