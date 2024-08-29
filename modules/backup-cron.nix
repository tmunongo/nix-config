{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nixos-config-backup;
  backupScript = pkgs.writeShellScriptBin "nixos-config-backup" ''
    # Delay running by 10 seconds post boot
    sleep 10s

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
        ${pkgs.git}/bin/git init
        ${pkgs.git}/bin/git remote add origin "$GITHUB_REPO"
    fi

    # Commit changes
    echo "Committing changes"
    ${pkgs.git}/bin/git add .
    ${pkgs.git}/bin/git commit -m "Automated backup $(date +'%Y-%m-%d %H:%M:%S')"
    # Pull first
    ${pkgs.git}/bin/git pull

    # Push to GitHub
    echo "Pushing to GitHub"
    ${pkgs.git}/bin/git push -u origin HEAD

    echo "Backup completed at $(date)"

    echo "Updating config directory with updated config from repo"
    ${pkgs.rsync}/bin/rsync -r --exclude="$BACKUP_DIR/.git" "$BACKUP_DIR" "CONFIG_DIR" 
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
      # environment={PATH="/run/current-system/sw/bin/ssh";};
      path = [ pkgs.openssh ];
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
	ExecStart = "${backupScript}/bin/nixos-config-backup";
        # WorkingDirectory = "/tmp";
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
