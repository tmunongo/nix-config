{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nixos-config-backup;
  backupScript = pkgs.writeScriptBin "backup-nixos-config" ''
    #!/bin/bash

    set -euo pipefail
    exec &> >(tee -a /tmp/nixos-config-backup.log)

    # Set variables
    CONFIG_DIR="/etc/nixos"
    BACKUP_DIR="/home/${cfg.user}/Documents/repos/nix-config"
    GITHUB_REPO="git@github.com:tmunongo/nix-config.git"

    # Ensure backup directory exists
    echo "Ensuring backup directory exists"
    mkdir -p "$BACKUP_DIR"

    # Copy NixOS configuration
    echo "Copying NixOS configuration"
    cp -r "$CONFIG_DIR"/* "$BACKUP_DIR/"

    # Change to backup directory
    echo "Changing to backup directory"
    cd "$BACKUP_DIR" || exit

    # Initialize git repo if it doesn't exist
    echo "Initializing git repo if it doesn't exist"
    if [ ! -d .git ]; then
        git init
        git remote add origin "$GITHUB_REPO"
    fi

    # Commit changes
    echo "Committing changes"
    git add .
    git commit -m "Automated backup $(date +'%Y-%m-%d %H:%M:%S')"

    # Push to GitHub
    echo "Pushing to GitHub"
    git push -u origin HEAD

    echo "Backup completed at $(date)"
  '';
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
        WorkingDirectory = "/tmp";
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
