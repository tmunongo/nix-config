{ config, pkgs, inputs, ... }:

{
    imports =
        [
            ../../hardware-configuration.nix
            inputs.home-manager.nixosModules.home-manager

            #nvidia support
            ../../modules/nvidia-prime-drivers.nix
            ../../modules/backup-cron.nix
        ];

    # boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub.enable = true;
    boot.loader.grub.devices = [ "nodev" ];
    boot.loader.grub.useOSProber = true;
    boot.loader.grub.efiSupport = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "maverick";

    networking.networkmanager.enable = true;

    time.timeZone = "Africa/Harare";

    i18n.defaultLocale = "en_ZW.UTF-8";

    i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_ZW.UTF-8";
    LC_IDENTIFICATION = "en_ZW.UTF-8";
    LC_MEASUREMENT = "en_ZW.UTF-8";
    LC_MONETARY = "en_ZW.UTF-8";
    LC_NAME = "en_ZW.UTF-8";
    LC_NUMERIC = "en_ZW.UTF-8";
    LC_PAPER = "en_ZW.UTF-8";
    LC_TELEPHONE = "en_ZW.UTF-8";
    LC_TIME = "en_ZW.UTF-8";
  };

  fonts.packages = with pkgs; [
    font-awesome
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  desktop.kde.enable = true;

  services = {
    openssh.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    nixos-config-backup = {
        enable = true;
        user = "maverick";
    };
  };

  hardware.pulseaudio.enable = true;

  users.users.maverick = {
    isNormalUser = true;
    description = "Maverick";
    extraGroups = ["networkmanager" "wheel" "docker" "podman" ];
    shell = pkgs.zsh;
    packages = with pkgs; [

    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
        "maverick" = import ./home.nix;
    };
    backupFileExtension = "backup";
  };

  programs.firefox.enable = true;
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" "history-substring-search" "thefuck" ];
      theme = "jonathan";
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [

  ];

  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    dockerCompat = true;
  };
  virtualisation.containers.cdi.dynamic.nvidia.enable = true;
}